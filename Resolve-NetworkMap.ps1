
    Function Resolve-NetworkMap
    {
        [ CmdLetBinding() ] Param (

            [ Parameter ( ParameterSetName = "ARP"  ) ] [ Switch ] $ARP  ,
            [ Parameter ( ParameterSetName = "MAC"  ) ] [ Switch ] $MAC  ,
            [ Parameter ( ParameterSetName = "Full" ) ] [ Switch ] $Full )

        Write-Theme -Action "Loading [~]" "Network Mapping Components"

        $Return                                   = [ PSCustomObject ]@{

            Class                                 = "No Network,X A,Localhost,X B,X C,Multicast,R/D,Broadcast".Replace("X","Clas" + 
                                                "s").Split(',')[@(0;@(1)*126;2;@(3)*64;@(4)*32;@(5)*16;@(6)*15;7)]

            ARP                                   = [ PSCustomObject ]@{

                Static                            = @( )
                Dynamic                           = @( )
                Object                            = ARP -A
                Collect                           = @( )
            }

            MAC                                   = Resolve-MacAddress | % { 

                [ PSCustomObject ]@{

                    Addresses                     = @( )

                    Count                         = $_.Count
                    Index                         = $_.Index
                    Vendor                        = $_.Vendor

                    Frame                         = @( )
                    Hex                           = @( )

                    Stack                         = 0

                    Return                        = @( )
                }
            }

            Full                                  = @( )
        }                                                                            #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
 #____                                                                             __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\___________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
#//¯¯\\____[ Scope ARP Table ]___________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯     
# ¯¯¯¯
        If ( ( $ARP ) -or ( $Full ) )
        {
            ForEach ( $I in 0..( $Return.Arp.Object.Count - 1 ) ) 
            { 
                $Return.Arp.Object[$I]            | % { 
                
                    If ( $_ -match "dynamic"  ) { If ( $_ -notin $Return.Arp.Dynamic ) { $Return.Arp.Dynamic  += $_ } }
                    If ( $_ -match "static"   ) { If ( $_ -notin $Return.Arp.Static  ) { $Return.Arp.Static   += $_ } }
                }
            }

            $Return.Arp | % { $_.Collect          = @( ) ; $_.Dynamic , $_.Static | % { $Return.Arp.Collect += $_ } }

            ForEach ( $I in 0..( $Return.Arp.Collect.Count - 1 ) )
            {
                $Return.Arp.Collect[$I]           | % { $X  = @{ 0 = $_[  0..23 ] ; 1 = $_[ 24..41 ] ; 2 = $_[ 46..53 ] }

                                         0..2     | % { $X[$_] =  "$( $X[$_] )".Replace( " " , "" ) } 
        
                    $Return.Arp.Collect[$I]       = [ PSCustomObject ]@{
            
                        Host                      = $X[0]
                        Class                     = $Return.Class[ ( $X[0] ).Split( '.' )[0] ]
                        MAC                       = $X[1]
                        Type                      = $X[2]
                        

                    }
                }
            }

            If ( $ARP ) 
            { 
                $Return.Arp.Collect 
            }
        }                                                                            #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
 #____                                                                             __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\___________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
#//¯¯\\____[ Does some cool stuff with MAC Addresses ]___________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
# ¯¯¯¯
        If ( $MAC -or $Full )
        { 
            $Return.MAC.Addresses                 = @(  $Return.Arp.Collect.Mac | % { $_ } )

            $Return.MAC.Frame                     = @(  $Return.Arp.Collect.Mac | % { ( $_.Replace('-','') )[0..5] -join '' } )

            $Return.MAC.Return                    = 0..( $Return.Arp.Collect.Mac.Count - 1 )

            ForEach ( $I in 0..( $Return.MAC.Addresses.Count - 1 ) )
            {
                $Return.MAC.Hex                   = $Return.MAC.Frame[$I] | % { [ Convert ]::ToInt64( $_ , 16 ) }

                $Return.MAC.Stack                 = 0
                
                Write-Progress -Activity "Collecting [~]" -PercentComplete ( ( $I / $Return.MAC.Addresses.Count ) * 100 )

                ForEach ( $X in 1..( $Return.MAC.Count.Count ) )
                {
                    $Return.MAC.Stack             = $Return.MAC.Stack + $Return.MAC.Count[$X]
                
                    $Return.MAC.Return[$I]        = If ( ( $Return.MAC.Stack -eq  16580522 ) -or ( $Return.Mac.Hex -in 65630 , 16777215 ) ) 
                    { 
                        "< Unknown / Multicast >" 
                    }
                                                    
                    ElseIf ( $Return.MAC.Stack -eq  $Return.MAC.Hex ) 
                    { 
                        $Return.MAC.Vendor[ ( $Return.MAC.Index[ $X + 1 ] ) ] 
                    }
                }
            }

            

            If ( $Full )
            {
                If ( $Return.ARP.Collect -ne $Null )
                {
                    $Return.Full                  = ForEach ( $I in 0..( $Return.Arp.Collect.Count - 1 ) )
                    { 
                        [ PSCustomObject ]@{ 

                            Host                  = $Return.Arp.Collect.Host[$I]
                            Class                 = $Return.Arp.Collect.Class[$I]
                            MAC                   = $Return.Arp.Collect.Mac[$I]
                            Vendor                = $Return.Mac.Return[$I]
                            Type                  = $Return.Arp.Collect.Type[$I]
                        }
                    }
                }
            }

            If ( $Mac )
            {
                $Return.MAC.Return
            }
        }
    }
