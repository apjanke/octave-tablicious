#!/usr/bin/env perl
#
# David Bateman Feb 02 2003
# Andrew Janke 2019
# 
# Extracts the help in texinfo format from Octave source code for use
# in documentation and generates <pkg>.texi and <pkg>.qhp files from it.
#
# Usage:
#
#   mktexi.pl <infile> <indexfile> <outfile> <qhpoutfile> <sourcedir> [<sourcedir> ...]
#
#   <file> is the input .texi.in template file.
#   <index> is the main INDEX file at the root of the package repo.
#   <outfile> is the output .texi file to generate.
#   <qhpoutfile> is the output .qhp file to generate.
#   <sourcedir> is an M-code or oct-file source directory. You may specify as many
#       of them as you want.
#
# Takes various input files (the package source code, INDEX, DESCRIPTION, <pkg>.texi.in),
# extracts the Texinfo documentation and metadata from them, and generates
# the combined <pkg>.texi help document, along with the <pkg>.qhp index file
# for generating the QHelp collection.
#
# Emits diagnostic messages to stdout.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
# This program is granted to the public domain.
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

BEGIN {
    push @INC, ".";
}

use strict;
use Data::Dumper;
use Date::Parse;
use File::Find;
use File::Basename;
use Text::Wrap;
use FileHandle;
use IPC::Open3;
use POSIX ":sys_wait_h";
use POSIX qw(strftime);

use OctTexiDoc;

my $infile = shift @ARGV;
my $indexfile = shift @ARGV;
my $outfile = shift @ARGV;
my $qhpoutfile = shift @ARGV;
my @sourcedirs = @ARGV;

my $debug = 0;
my $verbose = 0;

# Extract the Texinfo docs from the source code
my $docs = OctTexiDoc::DocSet->new;
for my $sourcedir (@sourcedirs) {
    $docs->read_source_dir($sourcedir);
}
# Debugging output
if ($debug) {
    open (TMP, ">", "topics.tmp")
        or die "Error: Could not open output file topics.tmp: $!\n";
    print TMP Data::Dumper->Dump([$docs]);
    close TMP;
}

open (IN, $infile)
    or die "Error: Could not open input file $infile: $!\n";
open (OUT, ">", $outfile)
    or die "Error: Could not open output file $outfile: $!\n";

sub emit {
    print OUT @_;
}

# Get metadata from DESCRIPTION file
my $pkg_meta = OctTexiDoc::get_package_metadata_from_description_file();
my $pkg_name = $$pkg_meta{"Name"};
my $pkg_version = $$pkg_meta{"Version"};
my $pkg_date_str = $$pkg_meta{"Date"};
my $pkg_date = str2time($pkg_date_str);
my $pkg_date_month_str = "Date Unknown";
if ($pkg_date) {
    my @pkg_date = strptime($pkg_date_str);
    $pkg_date_month_str = strftime("%B %Y", @pkg_date);
}

sub unique {
    my @vals = @_;
    my %vals = ();
    for (@vals) {
        $vals{$_} = 1;
    }
    return sort(keys %vals);
}

sub setdiff {
    my ($a, $b) = @_;
    my %in_b = map {$_ => 1} @$b;
    my @diff = grep {not $in_b{$_}} @$a;
    return @diff;
}

# Generate the <pkg>.texi file

my $in_tex = 0;
while (my $line = <IN>) {
    $line =~ s/%%%%PACKAGE_VERSION%%%%/$pkg_version/g;
    $line =~ s/%%%%PACKAGE_DATE_YEARMONTH%%%%/$pkg_date_month_str/g;
    if ($line =~ /^\@DOCSTRING/) {
        $line =~ /^\@DOCSTRING\((.*)\)/;
        my $fcn_name = $1;
        $fcn_name =~ /^(.*?),(.*)/;
        my ($func0, $func1) = ($1, $2);
        my $fcn_doco = $docs->get_node_doco($func0);
        emit "$fcn_doco\n";
    } elsif ($line =~ /^\@REFERENCE_SECTION/) {
        $line =~ /^\@REFERENCE_SECTION\((.*?)\)\s*/;
        my $refsection_name = $1;

        my $fcn_index = OctTexiDoc::read_index_file ($indexfile);
        my @all_index_fcns = @{$$fcn_index{"functions"}};
        my @topic_nodes = $docs->topic_node_names;
        my @all_topics = unique(@all_index_fcns, @topic_nodes);
        @all_topics = sort { lc($a) cmp lc($b) } @all_topics;
        my %categories = %{$$fcn_index{"by_category"}};
        my %descriptions = %{$$fcn_index{"descriptions"}};

        # Build "by Category" index based on INDEX listing
        emit "\@node API by Category\n";
        emit "\@section API by Category\n";
        my @all_ctg_fcns;
        for my $category (@{$$fcn_index{"categories"}}) {
            my @ctg_fcns = @{$categories{$category}};
            push @all_ctg_fcns, @ctg_fcns;
            emit "\@subsection $category\n";
            emit "\@table \@asis\n";
            for my $fcn (@ctg_fcns) {
                emit "\@item \@ref{$fcn}\n";
                my $description = $descriptions{$fcn} || $docs->get_node_summary($fcn);
                emit "$description\n";
                emit "\n";
            }
            emit "\@end table\n";
        }
        my @uncategorized = setdiff(\@all_topics, \@all_ctg_fcns);
        if (scalar (@uncategorized)) {
            emit "\@subsection Uncategorized\n";
            emit "\@table \@asis\n";
            for my $fcn (@uncategorized) {
                emit "\@item \@ref{$fcn}\n";
                my $description = $descriptions{$fcn} || $docs->get_node_summary($fcn);
                emit "$description\n";
                emit "\n";
            }
            emit "\@end table\n";
        }
        emit "\n";

        # Build "Alphabetically" listing based on seen nodes + INDEX listing
        emit "\@node API Alphabetically\n";
        emit "\@section API Alphabetically\n";
        emit "\@menu\n";
        for my $node (@all_topics) {
            my $description = $descriptions{$node} || $docs->get_node_summary($node);
            emit wrap("", "\t\t", "* ${node}::\t$description\n");
        }
        emit "\@end menu\n";
        emit "\n";
        for my $node (@all_topics) {
            emit "\@node $node\n";
            emit "\@subsection $node\n";
            my $node = $docs->docs->{$node};
            if ($node) {
                my $main_doc = OctTexiDoc::munge_texi_block_text($$node{block});
                emit "$main_doc\n\n";
                for my $subnode (@{$$node{children}}) {
                    my $subnode_name = $$subnode{node};
                    my $subnode_doc = OctTexiDoc::munge_texi_block_text($$subnode{block});
                    emit "\@node $subnode_name\n";
                    emit "\@subsubsection $subnode_name\n\n";
                    emit "$subnode_doc\n";
                }
            } else {
                emit "\@emph{Not documented}\n";
            }
        }
    } else {
        if ($line =~ /\@tex/) {
            $in_tex = 1;
        }
        if ($in_tex) {
            $line =~ s/\\\\/\\/g;
        }
        emit $line;
        if ($line =~ /\@end tex/) {
            $in_tex = 0;
        }
    }
}

close IN;
close OUT;

# Generate the <pkg>.qhp file

my %level_map = (
	"top" => 1,
	"chapter" => 2,
	"section" => 3,
	"subsection" => 4,
	"subsubsection" => 5
);

open (QHP, ">", $qhpoutfile)
    or die "Error: Could not open output .qhp file $qhpoutfile: $!\n";

sub qhp {
    print QHP @_;
}

my $preamble = <<EOS;
<?xml version="1.0" encoding="UTF-8"?>
<QtHelpProject version="1.0">
    <namespace>octave.community.$pkg_name</namespace>
    <virtualFolder>doc</virtualFolder>
    <filterSection>
        <toc>
EOS
qhp $preamble;

# TOC section

my @files;
my @classes;
my @functions;

open TEXI, $outfile
    or die "Could not open generated .texi file for reading: $outfile: $!\n";

my $level = 0;
my $indent = "        ";
while (my $line = <TEXI>) {
	chomp $line;
	next unless ($line =~ /^\s*\@node +(.*?)(,|$)/);
	my $node_name = $1;
	my $next_line = <TEXI>;
	while ($next_line && $next_line =~ /^\s*$/) {
		$next_line = <TEXI>;
	}
	chomp $next_line;
	unless ($next_line =~ /^\s*\@(\S+) +(.*)/) {
		die "Error: Failed parsing section line for node '$node_name': $next_line";
	}
	my ($section_type, $section_title) = ($1, $2);
	my $section_level = $level_map{$section_type};
	my $section_qhelp_title = $section_title =~ s/@\w+{(.*?)}/\1/rg;
	my $html_title = $node_name =~ s/\s/-/gr;
	$html_title = "index" if $html_title eq "Top";
	my $html_file_base = $html_title =~ s/_/_005f/gr; # I don't know why this happens -apj
    $html_file_base =~ s/\./_002e/g;
	my $html_file = "$html_file_base.html";
	unshift @files, $html_file;
	print "Node: '$node_name' ($section_type): \"$section_title\" => \"$section_qhelp_title\""
	    . " (level $section_level),  HTML: $html_file\n"
	    if $verbose;
	die "Error: Unrecognized section type: $section_type\n" unless $section_level;
	if ($section_level == $level) {
		# close last node as sibling
		qhp $indent . ("    " x $level) . "</section>\n";
	} elsif ($section_level > $level) {
		# leave last node open as parent
		if ($section_level > $level + 1) {
			die "Error: Discontinuity in section levels at node $node_name ($level to $section_level)";
		}
	} elsif ($section_level < $level) {
		# close last two nodes
		my $levels_up = $level - $section_level;
		while ($level > $section_level) {
			qhp $indent . ("    " x $level--) . "</section>\n";
		}
		qhp $indent . ("    " x $level) . "</section>\n";
	}
	qhp $indent . ("    " x $section_level) 
	    . "<section title=\"$section_qhelp_title\" ref=\"html/$html_file\">\n";
	qhp $indent . ("    " x $section_level) 
	    . "    <!-- orig_title=\"$section_title\" node_name=\"$node_name\" -->\n"
	    if $debug;
	$level = $section_level;
}
while ($level > 1) {
	qhp $indent . ("    " x $level--) . "</section>\n";
}
# Include the all-on-one-page version
qhp $indent . ("    " x $level) 
    . "<section title=\"Entire Manual in One Page\" ref=\"$pkg_name.html\"/>\n"
    . "$indent</section>\n";
qhp <<EOS;
        </toc>
EOS
close TEXI;

# Keyword index

my $node_index = $docs->nodes;
my @node_names = keys %$node_index;
@node_names = sort (@node_names);
qhp "        <keywords>\n";
for my $node (@node_names) {
	my $file_base = $node;
    $file_base =~ s/_/_005f/g;
	$file_base =~ s/\./_002e/g; # I don't know why this happens -apj
	qhp "            <keyword name=\"$node\" id=\"$node\" ref=\"html/$file_base.html\"/>\n";
}
qhp "        </keywords>\n";

# Files section

qhp "        <files>\n";
qhp "            <file>$pkg_name.html</file>\n";
foreach my $file (@files) {
	qhp "            <file>html/$file</file>\n";
}
qhp "        </files>\n";

# Closing
qhp <<EOS;
    </filterSection>
</QtHelpProject>

EOS
