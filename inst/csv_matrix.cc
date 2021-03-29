#include <iostream>
#include <octave/oct.h>
#include "csv_reader.h"
#include<vector>
#include "str-vec.h"

DEFUN_DLD (csv_matrix,  args, , "String Demo")
{

 // check if the data is provided or not 
 int nargin = args.length ();

// convert the file location into the string 
  charMatrix ch = args(0).char_matrix_value ();
  std::string file_location  = ch.row_as_string(0) ;

// do the file has a header 

  charMatrix need_header = args(1).char_matrix_value ();
  std::string header_req  = need_header.row_as_string(0) ;



//declare the data type  
csv_reader::csv_datatype table ;
table.read_record(file_location , header_req ) ; 



octave_value_list  retval ; 
/*retur 

    header 
    data 
    data_type 
*/

octave_value_list  header_values , data , data_type;
long long int count = 0 ; 

for( auto headers : table.header_csv )
{
    //headers are an individual strings 
    header_values(count) = octave_value(headers , '\'') ; 
    count++ ; 

}

long long int number_rows = table.data.size() ,  number_columns = table.data[0].size()   ;




std::vector<bool> data_type_per_col ; 
for( long long int j = 0 ; j < number_columns ;j++) 
{       
        data_type(j) = octave_value(0) ; 
        if(table.data[0][j].second == "std::string")
            data_type_per_col.push_back(0) ; // 0 for string and 1 for float datatype  
        else {
            bool is_str = 0 ; 
            for(long long int i = 0 ; i< number_rows ; i++)
                if(table.data[i][j].second == "std::string" )     // check is there any string in the column
                    {is_str = 1 ; break ;}
            if(is_str)
                data_type_per_col.push_back(0) ;  //  the datatype is a string  
            else 
                {
                    data_type_per_col.push_back(0) ;  //  the data type is a float 
                    data_type(j) = octave_value(1) ;
                }

        } 
}



for( long long int j = 0 ; j < number_columns ;j++) 
{
    octave_value_list  column ; 
    for(long long int  i =0 ; i< number_rows ;i++)
    {
        if(data_type_per_col[j]==0)
            column(i) =  octave_value(table.data[i][j].first , '\'' ) ;  // for string 
        else  
            column(i) =  octave_value(std::stof(table.data[i][j].first )) ; // for float 
    }
    data(j) = octave_value(column , false ) ;
}











retval(0) =   octave_value(header_values , false ) ; 
retval(1) =   octave_value(data , false ) ;
retval(2) =   octave_value(data_type , false ) ;
return retval ; 






}

