
    $Library          = @( ) 

    "Reflection" , "Runtime.CompilerServices" , "Runtime.InteropServices" | % { 

        $Library     += "using System.$_"
    }

    ( "Title"         ,  '"DatabaseLibrary"' ) ,
    ( "Description"   ,                 '""' ) ,
    ( "Configuration" ,                 '""' ) ,
    ( "Company"       ,                 '""' ) ,
    ( "Product"       ,  '"DatabaseLibrary"' ) ,
    ( "Copyright"     , '"Copyright @ 2020"' ) ,
    ( "Trademark"     ,                 '""' ) ,
    ( "Culture"       ,                 '""' ) ,
    ( "ComVisible"    ,              "false" ) ,
    ( "Guid"          , '"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"' ) ,
    ( "Version"       ,          '"1.0.0.0"' ) ,
    ( "FileVersion"   ,          '"1.0.0.0"' ) | % { 
    
        $Library += "[assembly:$( 
        
            If ( $_[0] -in "ComVisible","Guid" )
            {
                "$( $_[0] )($( $_[1] ))"
            }

            Else
            {
                "Assembly$( $_[0] )($( $_[1] ))"
            })]"
    }