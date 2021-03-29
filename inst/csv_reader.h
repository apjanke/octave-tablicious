#include<iostream>
#include<sstream>
#include<fstream>
#include<vector>
#include<stdio.h>


/* first take the input , then find the header 
   store them into a vector   consider all of the data as string 
   now  design a 2d vector with 
   each data type as pair consisting the value 
   and the type of data it can be converted
  
  Now we have access to the data with all convinience 

--------------------------------------------------------------------------------
  Allocate the functions for acchiving the points of the csv files


-------------------------------------------------------------------------------
  Convert the data to a table in octave 


*/

namespace csv_reader{


class csv_datatype{
  public:
    std::vector<std::string> header_csv ;
    std::vector<std::vector<std::pair<std::string ,std::string>>> data ; // [ {data , data_type }]


  private :
    bool its_float(std::string value) 
    {
      int dots = 0 ; 
      for(auto i :  value)
      {
        if( i != '.' &&( i < '0' || i > '9' ) )
          return 0 ;  // if it contains any other char 
        if(i=='.')
          dots++ ; 
        if(dots > 1 )
          return 0 ;  // if it has more than one dots
      }
      return 1 ; 


    }

    std::string decide_value(std::string value )
    {
      //the data will either be  a string or a float 

      if (its_float(value) )
      {
        return "std::float" ; 
      }
      return "std::string" ; // the datetime will also come under the string class 
    }

    std::vector<std::pair<std::string ,std::string>>get_individual(std::string line )
    {
      std::vector<std::pair<std::string ,std::string>>output ; 
      std::vector<std::string> devide ; 
      std::string temp ; 

      int block  = 0  ;
      for(auto i : line)
      {
        if(block ==1 )
        {
          if(i=='"')
          {
            block =  0 ; 
          }
          else{
            temp.push_back(i) ; 
          }
        }else 
        {
          if( i== ',' )
          {
            devide.push_back(temp) ; 
            temp = ""; 


          }   
          else if( i== '"')
          {
            block = 1 ;

          }else
          {
            temp.push_back(i) ; 

          }
        }
      }
      if(temp!="")
      {
        devide.push_back(temp) ; 
      }
      for(auto i :  devide )
      {
        output.push_back( { i,decide_value(i)}) ; 

      }

      return output ; 



    }



  public:

  void read_record(std::string location , std::string header_required )  
    { 
  
      std::fstream fin; 
      fin.open(location, std::ios::in); 
      std::vector<std::string> row; 
      std::string line, word, temp; 
      
      
      if(header_required=="1")
      { 
        getline(fin , line) ; 
        std::vector<std::pair<std::string ,std::string>> temps = get_individual(line)  ;
      for(auto i : temps)
      {
        header_csv.push_back(i.first) ;  
      }   

      }
      

      while ( getline(fin, line) ) { 
          data.push_back(get_individual(line)) ; 
      } 
    } 




};

}

