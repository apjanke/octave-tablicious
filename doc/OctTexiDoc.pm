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

# OctTexiDoc module: common code for mk*.pl in Chrono Octave package

use strict;

# A DocSet is a collection of Texinfo doco from Octave source files.
# It knows how to read in source directories, accumulating the Texinfo
# blocks as it goes.
package OctTexiDoc::DocSet;
use Moose;

use File::Basename;

# Docs: top-level thing index
#  {$node => {node => $node, block => $block, file => $file, children => [...]}}
# Children are also {node => $node, block => $block, file => $file}
# where:
#   $node is the fully-namespace-qualified class or function name
#   $block is the stripped text of the texinfo block
#   $file is the path to the file where this block came from
has 'docs' => ( is  => 'rw', isa => 'HashRef', default => sub { {} } );
# Index into all the nodes: {$node => {}}
has 'nodes' => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

sub topic_node_names {
    my $this = shift;
    return keys %{$this->docs};
}

sub all_node_names {
    my $this = shift;
    return keys %{$this->nodes};
}

sub add_thing {
    my $self = shift;
    my ($node_name, $block) = @_;
    die "Node name was undefined" unless $node_name;
    die "Node name cannot be empty or blank" 
        if ($node_name eq "" or $node_name eq " ");
    my $file = $$block{file};
    if ($self->docs->{$node_name}) {
        my $other_file = $self->docs->{$node_name}{file};
        printf STDERR "Warning: Node $node_name from file $file is shadowed by previous file $other_file\n";
        return;
    }
    $self->docs->{$node_name} = $block;
    $self->nodes->{$node_name} = $block;
    for my $child (@{$$block{children}}) {
        $self->nodes->{$$child{node}} = $child;
    }
}

sub add_sub_thing {
    my $self = shift;
    my ($node_name, $parent_thing_name, $block) = @_;
    die "Sub-thing node name was undefined" unless $node_name;
    die "Sub-thing node name cannot be empty or blank" 
        if ($node_name eq "" or $node_name eq " ");
    my $file = $$block{file};
    if ($self->nodes->{$node_name}) {
        my $other_file = $self->nodes->{$node_name}{file};
        printf STDERR "Warning: Node $node_name from file $file is shadowed by previous file $other_file\n";
        return;
    }
    my $parent_thing = $self->docs->{$parent_thing_name};
    if ($parent_thing) {
        push @{$$parent_thing{children}}, $block;
    } else {
        printf STDERR "Warning: Parent thing $parent_thing_name for node $node_name from file $file does not exist\n";
    }
    $self->nodes->{$node_name} = $block;
}

sub read_source_dir {
    my $self = shift;
    my ($dir, $namespace) = @_;
    opendir my $dh, $dir
        or die "Unable to open directory $dir: $!\n";
    while (my $file_name = readdir($dh)) {
        next if $file_name =~ /^\./;
        my $file = "$dir/$file_name";
        if (-d $file) {
            if ($file_name =~ /^\+/) {
                # Ignore +internal namespaces; they're not part of the public API
                next if ($file_name eq "+internal");
                $self->read_source_dir ($file, OctTexiDoc::append_namespace ($namespace, $file_name));
            } elsif ($file_name =~ /^\@/) {
                $self->read_class_at_dir ($file, $namespace);
            } else {
                # ignore
            }
        } else {
            next if $file_name =~ /^__/;  # __foo__ functions are internal impl details
            if ($file_name =~ /\.m$/) {
                $self->read_m_source_file ($file, $namespace);
            } elsif ($file_name =~ /\.cc$/) {
                $self->read_cxx_source_file ($file, $namespace);
            } else {
                # ignore
            }
        }
    }
}

# Read a regular, top-level .m function or classdef source file
sub read_m_source_file {
    my $self = shift;
    my ($file, $namespace) = @_;
    my $blocks = OctTexiDoc::extract_multiple_texinfo_blocks_from_mfile ($file, $namespace);
    my $n_blocks = scalar (@$blocks);
    my $ns_name = $namespace || "";
    return unless (scalar (@$blocks));
    my $first_block = shift @$blocks;
    my $node = $$first_block{node};
    my $texi = $$first_block{block};
    $$first_block{children} = $blocks;
    $$first_block{file} = $file;
    $self->add_thing($node, $first_block);
}

# Read a top-level .cxx oct-file source file
# This assumes oct-files are always in the base namespace/package
sub read_cxx_source_file {
    my $self = shift;
    my ($file, $namespace) = @_;
    my $blocks = OctTexiDoc::extract_texinfo_from_cxxfile ($file);
    for my $block (@$blocks) {
        my $node = $$block{node};
        my $texi = $$block{block};
        $$block{file} = $file;
        $$block{children} = [];
        $self->add_thing($node, $block);
    }
}

# Read a @<classname> class source directory
sub read_class_at_dir {
    my $self = shift;
    my ($dir, $namespace) = @_;

    # Locate and read the main classdef file
    my $dir_base = basename ($dir);
    my $class_name = $dir_base;
    $class_name =~ s/^\@//;
    my $class_file_name = "$class_name.m";
    my $class_file = "$dir/$class_file_name";
    unless (-f $class_file) {
        printf STDERR "Warning: No classdef file found in dir $dir\n";
        return;
    }
    my $main_blocks = OctTexiDoc::extract_multiple_texinfo_blocks_from_mfile ($class_file);
    return unless (scalar (@$main_blocks));
    my $class_block = shift @$main_blocks;
    $$class_block{file} = $class_file;
    $$class_block{children} = $main_blocks;

    # Then go through the other method files
    opendir my $dh, $dir
        or die "Unable to open directory $dir: $!\n";
    while (my $file_name = readdir($dh)) {
        next if $file_name =~ /^\./;
        next unless $file_name =~ /\.m$/;
        next if $file_name eq $class_file_name;
        my $method_file = "$dir/$file_name";
        my $blocks = OctTexiDoc::extract_multiple_texinfo_blocks_from_mfile ($method_file);
        push @{$$class_block{children}}, @$blocks;
    }

    # Stash the docs
    my $node = OctTexiDoc::append_namespace($namespace, $class_name);
    $self->add_thing($node, $class_block);
}

# Get a given node's full doc text
sub get_node_doco {
    my $self = shift;
    my ($node_name) = @_;
    my $block = $self->nodes->{$node_name};
    return undef unless $block;
    my $block_text = $$block{block};
    return OctTexiDoc::munge_texi_block_text($block_text);
}

sub get_node_summary {
    my $self = shift;
    my ($node_name) = @_;
    my $texi = $self->get_node_doco($node_name);
    return undef unless $texi;
    return OctTexiDoc::first_sentence($texi);
}


# Get the first sentence of a given node's doc text

package OctTexiDoc;

use File::Basename;
use IO::File;
use IPC::Open3;

sub append_namespace {
    my ($parent, $child) = @_;
    $child =~ s/^\+//; # convenience hack
    return $child unless $parent and $parent ne "";
    return "$parent.$child";
}

# Munge texinfo doco blocks into actual texinfo, or whatever it is that
# we put in the <pkg>.texi file.
sub munge_texi_block_text {
    my ($txt) = @_;
    my $texi = "";
    my @lines = split ("\n", $txt);
    my $in_doctex = 0;
    for my $line (@lines) {
        if ($line =~ /\@tex/) {
            $in_doctex = 1;
        }
        if ($in_doctex) {
            $line =~ s/\\\\/\\/g;
        }
        if ($line =~ /\@end tex/) {
            $in_doctex = 0;
        }
        $texi .= "$line\n";
    }
    $texi =~ s/\@seealso\{(.*[^}])\}/See also: $1/g;
    return $texi;
}


# Read an INDEX file. Returns hashref:
# {
#   "name" => $toolbox_name,
#   "long_name" => $long_toolbox_name,
#   "categories" => \@category_names,
#   "by_category" => { $category_name => \@category_fcn_names }, 
#   "functions" => \@all_fcn_names,
#   "descriptions" => { $function_name => $description }
# }
#
# This is based on a really simple understanding of the INDEX file
# format, with just a header line, category lines, and function/class
# names.
#
# TODO: Implement full INDEX file format based on spec at
# https://octave.org/doc/v4.2.1/The-INDEX-File.html#The-INDEX-File.
sub read_index_file { # {{{1
    my ($index_file    # in path to INDEX file
        )               = @_;

    unless ( open(IND, $index_file) ) {
        die "Error: Could not open INDEX file $index_file: $!\n";
    }
    my ($current_category, @all_functions, @categories, %by_category, %fcn_descrs);
    my $line = <IND>;
    $line = <IND> while ($line =~ /^\s*(#.*)?$/);
    # First line is header
    chomp $line;
    unless ($line =~ /^\s*(\w+)\s+>>\s+(\S.*\S)\s*$/) {
    	die "Error: Invalid header line in INDEX file $index_file: $line\n";
    }
    my ($toolbox, $toolbox_long_name) = ($1, $2);
    while (my $line = <IND>) {
    	chomp $line;
    	next if $line =~ /^\s*(#.*)?$/;
    	if ($line =~ /^\S/) {
    		$current_category = $line;
            push @categories, $current_category unless grep (/^$current_category$/, @categories);
    		$by_category{$current_category} ||= [];
        } elsif ($line =~ /^(\S+)\s*=\s*(\S.*?)\s*$/) {
            my ($fcn, $descr) = ($1, $2);
            $fcn_descrs{$fcn} = $descr;
            push (@{$by_category{$current_category}}, $fcn);
            push @all_functions, $fcn;
    	} else {
    		my $txt = substr ($line, 1);
    		my @functions = split /\s+/, $txt;
    		push (@{$by_category{$current_category}}, @functions);
    		push @all_functions, @functions;
    	}
    }
    return {
        "name" => $toolbox,
        "long_name" => $toolbox_long_name,
        "categories" => \@categories,
    	"by_category" => \%by_category,
    	"functions" => \@all_functions,
        "descriptions" => \%fcn_descrs
    };
}


# Extract the entire main documentation comment from an m-file.
# This grabs the first comment block after an optional initial copyright block.
# It ignores M-code syntax, so if you don't have a file-level comment block,
# it may end up grabbing a comment block from inside one of your functions.
sub extract_description_from_mfile {
    my ($mfile) = @_;
    my $retval = '';

    unless (open (IN, $mfile)) {
        die "Error: Could not open file $mfile: $!\n";
    }
    # Skip leading blank lines
    while (<IN>) {
        last if /\S/;
    }
    # First block may be copyright statement; skip it
    if (m/\s*[%\#][\s\#%]* Copyright/) {
        while (<IN>) {
            last unless /^\s*[%\#]/;
        }
    }
    # Skip everything until the next comment block
    while (!/^\s*[\#%]+\s/) {
        $_ = <IN>;
        last if not defined $_;
    }
    # Next comment block is the documentation; strip it and return it
    while (/^\s*[\#%]+\s/) {
        s/^\s*[%\#]+\s//; # strip leading comment characters
        s/[\cM\s]*$//;    # strip trailing spaces.
        $retval .= "$_\n";
        $_ = <IN>;
        last if not defined $_;
    }
    close(IN);
    return $retval;
}

# Extract all Octave Texinfo documentation comments from an m-file
# Returns an arrayref of extracted blocks, with each block being
# a hashref with keys "node" and "block".
sub extract_multiple_texinfo_blocks_from_mfile {
    my ($mfile, $namespace) = @_;
    my $retval = '';
    my $file_node_name = basename($mfile, ('.m'));

    my $fh = IO::File->new($mfile, "r")
        or die "Error: Could not open file $mfile: $!\n";

    # Skip leading blank lines
    while (<$fh>) {
        last if /\S/;
    }
    # First block may be copyright statement; skip it
    if (m/\s*[%\#][\s\#%]* Copyright/) {
        while (<$fh>) {
            last unless /^\s*[%\#]/;
        }
    }

    # Okay, now detect all Texinfo comment blocks
    #
    # This is currently broken: I'm using @node lines in the Texinfo to indicate node
    # starts, but the @node and @section/@subsection/@subsubsection are emitted automatically
    # by mktexi.pl.
    my @blocks;
    my $block; # the current block
    my $in_block = 0;
    my $line;
    my $node;
    while (<$fh>) {
        my $line_num = $fh->input_line_number();
        if (/^\s*## -\*- texinfo -\*-/) {
            # block start
            if ($in_block) {
                push @blocks, { node => $node, block => $block};
            }
            $block = "";
            $in_block = 1;
            # Grab next line so we can detect node name
            $line = <$fh>;
            $line = strip_mfile_block_line ($line);
            if ($line =~ /^\s*\@node (\S*)/) {
                my $node_basename = $1;
                $node = append_namespace($namespace, $node_basename);
            } else {
                # For back-compatibility, the first block may take the file as its node name
                # Only the first block! Otherwise you'd have collisions.
                if ((scalar (@blocks)) == 0) {
                    $node = append_namespace($namespace, $file_node_name);
                } else {
                    die "Found non-first block with no \@node statement in file $mfile at line $line_num\n";
                }
                $block .= "$line\n";
            }
        } elsif (/^\s*##\s/) {
            if ($in_block) {
                $line = strip_mfile_block_line ($_);
                $block .= "$line\n";
            }
        } else {
            if ($in_block) {
                push @blocks, { node => $node, block => $block};
                $block = "";
                $in_block = 0;
            }
        }
    }
    my $line_num = $fh->input_line_number();
    if ($in_block) {
        push @blocks, { node => $node, block => $block};
        $block = "-*- texinfo -*-";
        $in_block = 0;
    }

    my $n_blocks = scalar @blocks;
    return \@blocks;
}

sub strip_mfile_block_line {
    my ($line) = @_;
    $line =~ s/^\s*##\s?//;   # strip leading comment characters
    $line =~ s/[\cM\s]*$//;   # strip trailing spaces.
    return $line;
}

# Extract all Octave Texinfo documentation comments from a C++ oct-file
# source file.
# Returns an arrayref of extracted blocks, with each block being
# a hashref with keys "node" and "block".
sub extract_texinfo_from_cxxfile {
    my ($file) = @_;
    open(IN, $file)
        or die "Error: Could not open file $file: $!\n";
    my @blocks;
    while (<IN>) {
        # skip to the next defined Octave function
        next unless /^DEFUN_DLD/;
        # extract function name
        /\DEFUN_DLD\s*\(\s*(\w+)\s*,/;
        my $function = $1;
        # Advance to the comment string in the DEFUN_DLD
        # The comment string in the DEFUN_DLD is the first line with "..."
        $_ = <IN> until /\"/;
        my $desc = $_;
        $desc =~ s/^[^\"]*\"//;
        # Slurp in C-style implicitly-concatenated strings
        while ($desc !~ /[^\\]\"\s*\S/ && $desc !~ /^\"/) {
            # if line ends in '\', chop it and the following '\n'
            $desc =~ s/\\\s*\n//;
            # join with the next line
            $desc .= <IN>;
            # eliminate consecutive quotes, being careful to ignore
            # preceding slashes. XXX FIXME XXX what about \\" ?
            $desc =~ s/([^\\])\"\s*\"/$1/;
        }
        $desc = "" if $desc =~ /^\"/; # chop everything if it was ""
        $desc =~ s/\\n/\n/g;          # insert fake line ends
        $desc =~ s/([^\"])\".*$/$1/;  # chop everything after final '"'
        $desc =~ s/\\\"/\"/;          # convert \"; XXX FIXME XXX \\"
        $desc =~ s/$//g;              # chop trailing ...
        if (!($desc =~ /^\s*-\*- texinfo -\*-/m)) {
            printf STDERR ("Function %s (file %s) does not contain texinfo help:%s\n",
                    $function, $file);
        }
        push @blocks, { node => $function, block => $desc};
    }
    return \@blocks;
}

sub get_package_metadata_from_description_file {
    my $description_file = "../DESCRIPTION";
    unless (open (IN, $description_file)) {
        die "Error: Could not open file $description_file: $!\n";
    }
    my ($key, $value, %defn);
    while (<IN>) {
        chomp;
        next if /^\s*(#.*)?$/; # skip comments
        if (/^ /) {
            die "Error: Failed parsing $description_file: found continuation line before any key line: \"$_\""
                unless $key;
            # continuation line
            my $txt = $_;
            $txt =~ s/^\s+//;
            $value .= $txt;
        } elsif (/^(\S+)\s*:\s*(\S.*?)\s*$/) {
            $defn{$key} = $value if $key;
            ($key, $value) = ($1, $2);
        } else {
            die "Error: Failed parsing $description_file: Unparseable line: \"$_\"";
        }
    }
    $defn{$key} = $value if $key;
    return \%defn;
}

sub first_sentence { # {{{1
# grab the first real sentence from the function documentation
    my ($desc) = @_;
    my $retval = '';
    my $line;
    my $next;
    my @lines;

    my $trace = 0;
    # $trace = 1 if $desc =~ /Levenberg/;
    return "" unless defined $desc;

    # Run the texinfo through makeinfo to get plain text
    my $cmd = "makeinfo --fill-column 1600 --no-warn --no-validate "
        . "--no-headers --force --ifinfo";
    open3(*Writer, *Reader, *Errer, $cmd)
        or die "Error: Could not run makeinfo: $!";
    print Writer "\@macro seealso {args}\n\n\@noindent\nSee also: \\args\\.\n\@end macro\n";
    print Writer "$desc";
    close (Writer);
    @lines = <Reader>;
    close (Reader);
    my @err = <Errer>;
    close (Errer);
    # I think this &WNOHANG needs "use POSIX ":sys_wait_h"" -apj
    #waitpid (-1, &WNOHANG);
    waitpid (-1, 0);

    # Display source and errors, if any
    if (@err) {
        my $n = 1;
        foreach $line ( split(/\n/,$desc) ) {
            printf "%2d: %s\n",$n++,$line;
        }
        print ">>> @err";
    }

    # Skip prototype and blank lines
    while (1) {
        return "" unless @lines;
        $line = shift @lines;
        next if $line =~ /^\s*-/;
        next if $line =~ /^\s*$/;
        last;
    }

    # Try to make a complete sentence, including the '.'
    if ( "$line " !~ /[^.][.]\s/ && $#lines >= 0) {
        my $next = $lines[0];
        $line =~ s/\s*$//;   # trim trailing blanks on last
        $next =~ s/^\s*//;   # trim leading blanks on next
        $line .= " $next" if "$next " =~ /[^.][.]\s/; # ends the sentence
    }

    # Tidy up the sentence.
    chomp $line;
    $line =~ s/^\s*//;             # trim leading blanks on line
    $line =~ s/([^.][.])\s.*$/$1/; # trim everything after the sentence
    print "Skipping:\n$desc---\n" if $line eq "";

    # And return it.
    return $line;

} # 1}}}


1;