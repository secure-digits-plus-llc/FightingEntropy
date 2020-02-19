    
        Write-Theme -Action "Scanning [~]" "Network Host Range"

        IEX "Using Namespace System.Net.NetworkInformation"

        Get-NetworkInfo -LocalHost      | % {

            $Range                      = ForEach ( $I in $_.Start , $_.End )
            {
                $I.Replace( $_.Prefix + '.' , "" )
            }

            $HostRange                  = ForEach ( $I in $Range[0]..$Range[1] )
            {
                 $_.Prefix + ".$I"
            }
        }

        $Stopwatch                      = [ System.Diagnostics.Stopwatch ]::StartNew()

        $Return                         = [ PSCustomObject ]@{ 
        
            Success                     = @( )
            Failure                     = @( ) 
        }

        $B                              = 97..119 + 97..105 | % { "0x$( "{0:x}" -f $_ )" }

        $O                              = New-Object PingOptions

        $Report                         = ForEach ( $I in $HostRange )
        {
            New-Object Ping             | % { $_.SendPingAsync( $I , 100 , $B , $O ) } 
        }

        $Stopwatch.Stop()

        $Report.Result                  | ? { $_.Status -eq "Success"   } | % { $Return.Success += $_.Address.ToString() }
            
        $HostRange                      | ? { $_ -notin $Return.Success } | % { $Return.Failure += $_ }

        Write-Theme -Action "Complete [+]" "$( $Stopwatch.Elapsed ) / Hosts Found : [$( $Return.Success.Count )]"

        Return $Return             
        
        
        
        
             $Return                         = @( )

        $IP                             = Start-PingSweep | ? { $_.Success -ne $Null } | % { $_.Success }

        $IPV4                           = Get-NetworkInfo -LocalHost | % { $_.IPV4 }

        $ID                             =  "00" , "01" , "01" , "03" , "06" , "1F" , "20" , "21" , "22" , "23" , "24" , "30" , "31" , "43" , "44" , 
                                           "45" , "46" , "4C" , "42" , "52" , "87" , "6A" , "BE" , "BF" , "03" , "00" , "1B" , "1C" , "1D" , "1E" , 
                                           "2B" , "2F" , "33" , "20" , "01" | % { "<$_>" }

        $Type                           = ( "UNIQUE" , "GROUP" )[ 0 , 0 , 1 + @( 0 ) * 22 + 1 , 0 , 1 , 0 , 1 , 0 , 1 , 1 , 1 , 1 ]

        $SVX                            = "Workstation" , "Messenger" , "Master Browser" , "Messenger" , "RAS Server" , "NetDDE" , "File Server" ,  
                                          "RAS Client" , "Interchange(MSMail Connector)" , "Store" , "Directory" , "Server" , "Client" , "Control" , 
                                          "SMS Administrators Remote Control Tool" , "Chat" , "Transfer" , "on Windows NT" , "mccaffee anti-virus" , 
                                          "on Windows NT" , "MTA" , "IMC" , "Network Monitor Agent" , "Network Monitor Application" , "Messenger" , 
                                          "Name" , "Master Browser" , "Controller" , "Master Browser" , "Browser Service Elections" , "Server" , 
                                          "" , "" , "DCA IrmaLan Gateway Server" , "MS NetBIOS Browse"

        $Filter                         = 0,0,7,0,0,0,0,0,1,1,1,3,3,4,0,4,4,6,7,6,1,1,7,7,0,5,5,5,7,7,2,2,2,7,0

        $Item                           = @( "SVX Service" ; "Microsoft Exchange" , "Lotus Notes" , "Modem Sharing" , "SMS Clients Remote" , "Domain" , 
                                             "DEC TCPIP SVC" | % { "$_ SVX" } ; "SVX" )

        $Service                        = ForEach ( $I in 0..34 ) 
        { 
            $Item[ ( $Filter[$I] ) ].Replace( "SVX" ,"$( $SVX[$I] )" )  
        }

        $List                           = @( )
        
        ForEach ( $I in 0..34 ) 
        { 
            $List                      += [ PSCustomObject ]@{ 
            
                ID                      = $ID[$I]
                Type                    = $Type[$I]
                Service                 = $Service[$I] 
            } 
        }

        Write-Theme -Action "Initiating [~]" "NetBIOS Scanner"

        ForEach ( $I in ( 0..( $IP.Count - 1 ) ) ) 
        {
            Write-Theme -Function "Host # $( $IP[$I] )"

            $DNS = $( Resolve-DnsName -Name $IP[$I] -EA 0 | % { $_.Namehost | % { If ( $_ -ne $Null ) { $_ } Else { "*No Hostname*" } } } )

            $X                          = @( )

            If ( $IP[$I] -eq $IPV4 ) 
            { 
                NBTSTAT -n              | ? { $_ -like "*Registered*" } | % { 
                
                    If ( $_ -notin $X ) 
                    { 
                        $X             += $_ 
                    } 
                } 
            }

            If ( $IP[$I] -ne $IPV4 ) 
            { 
                NBTSTAT -A $IP[$I]      | ? { $_ -like "*Registered*" } | % { 
                
                    If ( $_ -notin $X ) 
                    { 
                        $X             += $_ 
                    } 
                } 
            }

            ForEach ( $y in 0..( $X.Count - 1 ) ) 
            { 
                If ( $X[$Y] -like "*__MSBROWSE__*" ) 
                { 
                    $X[$Y]              = "    MSBROWSE       <01>  GROUP       Registered " 
                } 
            }

            $X                          | % { 

                $Z                      = @( $_[0..18] , $_[19..23] , $_[24..32] | % { ( $_ -ne " " ) -join '' } )

                $List                   | ? { $Z[1] -eq $_.ID -and $Z[2] -eq $_.Type } | % { 
                
                    $SVC                = $_.Service 
                }

                $Return                += [ PSCustomObject ]@{ 
                
                    IP                  = $IP[$I]
                    Host                = $DNS
                    Name                = $Z[0]
                    ID                  = $Z[1]
                    Type                = $Z[2]
                    Service             = $SVC 
                }
            }
        }

        If ( !$Table ) 
        { 
            Return $Return 
        } 

        If ( $Table ) 
        { 
            Return $Return              | FT -AutoSize 
        }                                         




                $Collection                     = Start-PingSweep
        $S                              = $Collection.Success
        $C                              = $S.Count
        $Report                         = 0..( $C - 1 )

        ForEach ( $A in 0..( $C - 1 ) )
        {
            Write-Progress -Activity "Scanning Network $( $S[$A] )" -PercentComplete ( ( $A / $C ) * 100 )

            If ( ( Test-Connection –BufferSize 32 –Count 1 –Quiet –ComputerName $S[$A] -EA 0 ) -ne $Null )
            {
                Try 
                { 
                    New-Object System.Net.Sockets.TcpClient -Args ( $S[$A] , $Port ) -EA 0 | % { 
                        
                        $Report[$A]     = [ PSCustomObject ]@{
                    
                            ID          = $A
                            IPAddress   = $S[$A]
                            Client      = $_.Client
                            Connected   = $_.Connected
                        } 
                    }
                }
                
                Catch 
                {
                    [ Void ]$_.Exception.Message
                    
                    $Report[$A]         = [ PSCustomObject ]@{ 
                    
                        ID              = $A
                        IPAddress       = $S[$A]
                        Connected       = "False" 
                    }
                }
            }
        }

        If ( $Return ) 
        { 
            Return $Report.Client       | FT -AutoSize 
        }
        
        Else 
        { 
            Return $Report 
        }
