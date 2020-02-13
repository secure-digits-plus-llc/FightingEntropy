                                                                                     #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
 #____                                                                             __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\___________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Get-AddressResolutionTable Retrieves/Parses the ARP Table __________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯         
    
    Function Get-AddressResolutionTable
    {
        $Return                        = @( )

        $Arpa                          = [ PSCustomObject ]@{ 
            
            Static                     = @( )
            Dynamic                    = @( )
        }

        $Range                         = @( 0 ; @( 1 ) * 126 ; 2 ; @( 3 ) * 64 ; @( 4 ) * 32 ; @( 5 ) * 16 ; @( 6 ) * 15 ; 7 )
        $Class                         = "No Network,X A,Localhost,X B,X C,Multicast,R/D,Broadcast".Replace("X","Class").Split(',')

        $Arp                           = ARP -A

        ForEach ( $i in 0..( $Arp.Count - 1 ) ) 
        { 
            $Arp[$I]                   | % { 
                
                If ( $_ -match "dynamic"  )
                {
                    If ( $_ -notin $Arpa.Dynamic )
                    {
                        $Arpa.Dynamic += $_
                    }
                }

                If ( $_ -match "static" )
                {
                    If ( $_ -notin $Arpa.Static )
                    {
                        $Arpa.Static  += $_
                    }
                }
            }
        }

        $Arp                           = @( )

        $Arpa                          | % { 
        
            $_.Dynamic , $_.Static     | % { 
            
                $Arp                  += $_ 
            }
        }

        ForEach ( $I in 0..( $Arp.Count - 1 ) )
        {
            $Arp[$I]                   | % { 
            
                $X                     = @{ 
                    
                    0                  = $_[  0..23 ] 
                    1                  = $_[ 24..41 ] 
                    2                  = $_[ 46..53 ] 
                }

                0..2                   | % { 
                    
                    $X[$_]             = "$( $X[$_] )".Replace( " " , "" ) 
                }
        
                $Arp[$I]               = [ PSCustomObject ]@{
            
                    Host               = $X[0]
                    MAC                = $X[1]
                    Type               = $X[2]
                    Class              = $Class[ $Range[ ( ( $X[0] ).Split( '.' )[0] ) ] ]

                }
            }
        }

       $Arp 
    }
