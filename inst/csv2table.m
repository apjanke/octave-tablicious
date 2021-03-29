
function value =  csv2table(file_location , headers = "0" )
    [header , data , data_type] = csv_matrix(file_location , headers ) ;

    index = 0 ;
    
    values = table() ; 
    for i_s = data
        i = i_s{1,1} ; 
        index = index+1  ;

        if (headers =="0")

            hist = [ 65 ] ; %a blank matrix
            hist_index = 1 ;

            %now convert the integer  i into  a string 
            index_string = num2str(index)  ;

            for indi_i= index_string 
                value_i_ind = str2num(indi_i) ; 
                hist(hist_index+1 )= value_i_ind + 48;
                hist_index = hist_index+1 ;
            endfor 
            variablename  = char(hist) ; 

        else 
             
            header_val = header(1,index){1,1} ;
            for header_col = 1:columns(header_val)  ;
                if header_val(1,header_col ) == ' ' 
                    header_val(1,header_col ) ='_' ;
                endif 
            endfor  

            variablename = header_val ;

            
        endif
        
        
        
        
        if(data_type(index){1,1} == 0 ) %i.e the value is string 
            values = addvars(values  , i ,'NewVariableNames', { variablename } ) ;
            continue ; 
        endif


        %now the value is float so we will convert each element of the array i into  num using str2num and then add it to the matrix  
        index_final_matrix = 0 ;
        sd = [ 1 3 4 5 6 7 8 ] ;
        a = [1] ;
        mats = [] ; 
        for isd = i 
            value_of_isd = isd{1,1} ; 
            mats = [mats ;  str2double(value_of_isd) ] ;
        endfor



        
        values = addvars(values  , mats ,'NewVariableNames', { variablename } ) ;


        %disp((i))  


    endfor 
    value = values  ;
endfunction  