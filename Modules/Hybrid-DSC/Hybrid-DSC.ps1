    Function Resolve-NetworkMap # Obtains Extensive Network Information _________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯     
        
        Write-Theme -Action "Loading [~]" "Network Mapping Components"

             #_    ____________________________
             #\\__//¯¯[___ Resolve Vendors ___]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        $Resource                                  = [ PSCustomObject ]@{

            Path                                   = Get-ScriptRoot | % { "{0}\Map" -f $_.Parent }
            Count                                  = ""
            Index                                  = ""
            Vendor                                 = ""
        }
             #_    ____________________________
             #\\__//¯¯[___ Overload Scripts __]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        $Script                                    = [ PSCustomObject ]@{

            Class                                  = {
                
                Param ( $Address )("No Network,X A,Localhost,X B,X C,Multicast,R/D,Broadcast"
                ).Replace("X","Class").Split(',')[@(0;@(1)*126;2;@(3)*64;@(4)*32;@(5)*16;@(6)*15;7)][$Address.Split('.')[0]]
            }

            Netmask                                = {
            
                Param ( $Mask )

                $Mask | % { 
                
                    $X = @{ 0 = 255 ; 1 = 0 ; 2 = 0 ; 3 = 0 }
                    $Y = $_ % 8 ; $Z = ( $_ - ( $Y ) ) / 8
                    If ( $_ -in 16..30 ) { $X[1] = 255 } 
                    If ( $_ -in 24..30 ) { $X[2] = 255 }

                    $X[$Z] = "0,128,192,224,240,248,252,254,255".Split(',')[$Y]
                    $X[0..3] -join '.'
                }
            }
                                                    
            Vendor                                 = {

                Param ( $Vendor )
                
                $Convert    = [ Convert ]::ToInt64( $Vendor , 16 )

                $Rank       = 0 
                                    
                ForEach ( $J in 1..( $Resource.Count.Count ) )
                {
                    $Rank   = $Rank + $Resource.Count[$J]

                    If ( $Rank -eq $Convert )
                    { 
                        $Resource.Vendor[ ( $Resource.Index[ $J + 1 ] ) ]
                    }
                }
            }

            Range                                  = {

                Param ( $Address , $Mask )

                $ID           = [ PSCustomObject ]@{

                    IPAddress = ( [ IPAddress ] $Address ).GetAddressBytes()
                    Mask      = ( [ IPAddress ] $Mask    ).GetAddressBytes()
                    Build     = 0..3
                    Range     = 0..3
                    Count     = @( )
                }

                $ClassID      = & $Script.Class $Address

                If ( $ID.IPAddress[0] -in @( 0 , 127 ; 224..255 ) )
                {
                    Write-Theme -Action "Exception [!]" "$( $ClassID[$ID.IPAddress[0]] ) Address Detected" 12 4 15
                    Break
                }

                If ( ( $ID.IPAddress[0..1] -join '.' ) -eq "169.254" )
                {
                    Write-Theme -Action "Exception [!] " "Automatic Private IP Address Detected" 12 4 15
                    Break
                }

                ForEach ( $I in 0..3 )
                {
                    $ID.Build[$I] = 256 - $ID.Mask[$I]

                    If ( $ID.Build[$I] -eq 1 )
                    {
                        $ID.Range[$I] = $ID.IPAddress[$I]
                    }

                    If ( $ID.Build[$I] -in 2..255 )
                    {
                        $Z = $ID.Build[$I]

                        ForEach ( $Y in 0..( ( 256 / $Z ) - 1 ) )
                        { 
                            $X = $Z * $Y | % { $_..( $_ + ( $Z - 1 ) ) }

                            If ( $ID.IPAddress[$I] -in $X )
                            {
                                $ID.Range[$I] = "$( $X[0] )..$( $X[$Z - 1] )"
                            }
                        }
                    }

                    If ( $ID.Build[$I] -eq    256 ) { $ID.Range[$I]  = "*" }
                }

                $ID.Count = ( IEX ( ( 0..3 | % { $ID.Build[$_] } ) -join "*" ) ) - 2

                $ID
            }
        }

             #_    ____________________________
             #\\__//¯¯[_____ Gather Info _____]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        $Root                                      = [ PSCustomObject ]@{ 
        
            Domain                                 = GP "HKLM:\System\CurrentControlSet\Services\TCPIP\Parameters" | % { $_.Domain.ToUpper() }
            Hostname                               = GP "HKLM:\System\CurrentControlSet\Services\TCPIP\Parameters" | % { $_.Hostname.ToUpper() }
            ARP                                    = @( ARP -A )
            NetStat                                = @( netstat -ant | ? { $_ -match "TCP" -or $_ -match "UDP" } )
            Computer                               = GCIM Win32_ComputerSystem
        }
        
        $C = 0

        GCI $Resource.Path "*zip*"                 | % { 
        
            Write-Progress -Activity "Loading $( $_.BaseName )" -PercentComplete ( ( $C / 3 ) * 100 )

            Expand-Archive -Path $_.FullName -DestinationPath $_.DirectoryName -Force ; $C ++
        }

        $C = 0

        GCI $Resource.Path "*txt*"                 | % { 

            Write-Progress -Activity "Loading $( $_.BaseName ).txt" -PercentComplete ( ( $C / 3 ) * 100 )
        
            $Resource.$( $_.Basename )             = GC $_.FullName ; $C ++ ; RI $_.FullName -VB 
        }

             #_    ____________________________
             #\\__//¯¯[___ Parse ARP Table ___]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        $Return                                   = [ PSCustomObject ]@{
        
            ARP                                   = [ PSCustomObject ]@{ 
            
                Interface                         = $Root.Arp | ? { $_ -match "Interface" } | % { $_.Replace('Interface: ','').Split(' ')[0] }
                Table                             = @( )
            }

            Interface                             = @( )
            Current                               = @( )
            Range                                 = @( )
            NBT                                   = @( )
            Report                                = @( )
            Switch                                = 0
        }

        If ( $Return.ARP.Interface.Count -eq 1 )
        { 
            $Return.Current = $Root.ARP 
        }
        
        If ( $Return.ARP.Interface.Count -gt 1 )
        {
            $Return.Switch                        = 1
            $Y                                    = 0
            $C                                    = $Return.ARP.Interface.Count

            $Item                                 = [ PSCustomObject ]@{
                
                Count                             = ( $Root.ARP.Count / $C )
                Rank                              = 0
                Line                              = $Null
                Current                           = @{ }
            }

            0..( $Root.Arp.Count - 1 )            | % { 
                
                If ( $Item.Line      -eq $Null ) 
                { 
                    $Item.Current.Add( $Item.Rank , @( ) )
                    $Item.Line = 0 
                }
                
                $Item.Current[ $Item.Rank ]      += $Root.Arp[ $Item.Line ]
                $Item.Line ++
                    
                If ( $Item.Line % 14 -eq     0 ) 
                { 
                    $Item.Rank ++ 

                    If ( $Item.Current.Count -ne $C ) 
                    { 
                        $Item.Current.Add( $Item.Rank , @( ) ) 
                    }
                }
            }
        }
            
        Do
        {
            If ( $Return.Switch -eq 1 )
            {
                $Return.Current = $Item.Current[$Y]
            }

            $Return.Current | % { 
    
                ForEach ( $i in "dynamic" , "static" )
                {
                    If ( $_ -match $I )
                    {
                        $X = @{ 0 = ( $_[0..23] ) ; 1 = ( $_[24..41] ) }
                        
                        0..1 | % { $X[$_] = "$( $X[$_] )".Replace(' ','') }
                            
                        If ( $X[0] -notin $Return.Adapter.IPV4 )
                        {
                            $Return.Arp.Table += [ PSCustomObject ]@{

                                Hostname              = "-"
                                IPV4                  = ($X[0])
                                Class                 = & $Script.Class $X[0]
                                Mac                   = ($X[1])
                                Vendor                = ($X[1])[0,1,3,4,6,7] -join ''
                                    
                            }
                        }
                    }
                }
            }

            If ( $Return.Switch -eq 1 )
            {
                If ( $Y -eq $Item.Range.Count - 1 ) 
                {
                    $Y ++ 
                }
                
                Else 
                {
                    $Return.Switch = 0 
                }
            }
        }
        
        Until ( $Return.Switch -eq 0 )

             #_    ____________________________
             #\\__//¯¯[__ Format ARP Tables __]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        If ( $Return.Arp.Table.Count -eq 0 )
        {
            Write-Theme -Action "Exception [!]" "Functional Adapter(s) Not Detected" 12 4 15
            Break
        }
        
        $C = 0

        $Return.Arp.Table | ? { 

            Write-Progress -Activity "Collecting Interface Information" -PercentComplete ( ( $C / $Return.Arp.Table.Count ) * 100 )

            If ( $_.Vendor -in "ffffff","01005e" )
            {
                $_.Hostname = "-----------------"
                $_.Vendor   = "-----------------"
            }
            
            If ( $_.Vendor -notin "ffffff","01005e","-----------------" )
            {
                $_.HostName = Try { Resolve-DNSName $_.IPV4 -EA 0 | % { $_.NameHost } } Catch { "Unknown" }
                $_.Vendor   = ( & $Script.Vendor $_.Vendor )
            }

            $C ++
        }
             #_    ____________________________
             #\\__//¯¯[__ Collect Interface __]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

        $Return.Interface = @( Get-NetRoute | ? { $_.DestinationPrefix -eq "0.0.0.0/0" }  | % { 
        
            Get-NetIPConfiguration -InterfaceIndex $_.InterfaceIndex -Detailed | % { 

                [ PSCustomObject ]@{ 

                    ComputerName   = $_.ComputerName
                    Alias          = $_.InterfaceAlias
                    Index          = $_.InterfaceIndex
                    Description    = $_.InterfaceDescription
                    MacAddress     = $_.NetAdapter.LinkLayerAddress
                    Vendor         = & $Script.Vendor ( ( $_.NetAdapter.LinkLayerAddress)[0,1,3,4,6,7] -join '' )
                    Domain         = $_.NetProfile.Name.ToUpper() | % { If ( $_ -ne $Root.Domain ) { "$_ [$( $Root.Domain)]" } Else { $Root.Domain } }
                    IPV4Address    = $_.IPV4Address.IPAddress
                    IPV4Prefix     = $Int | % { & $Script.Netmask $_.PrefixLength }
                    IPV4Gateway    = $_.IPv4DefaultGateway | % { $_.NextHop }
                    IPV4DNS        = $_.DNSServer | ? { $_.AddressFamily -eq  2 } | % { $_.ServerAddresses }
                    IPV4ARP        = @( )
                    IPV4NET        = @( )
                    IPV4NBT        = @( )
                    IPV6Address    = $_.IPV6Address
                    IPV6Prefix     = Get-NetIPAddress -InterfaceIndex $_.InterfaceIndex | ? { $_.IPV6Address } | % { $_.PrefixLength }
                    IPV6Gateway    = $_.IPV6DefaultGateway | % { $_.NextHop }
                    IPV6DNS        = $_.DNSServer | ? { $_.AddressFamily -eq 23 } | % { $_.ServerAddresses }
                }
            }
        })

        If ( $Return.Interface -eq $Null )
        {
            Write-Theme -Action "Exception [!]" "Gateway not detected. Aborting" 12 4 15
            Break
        }

        Write-Theme -Action "Found [+]" "($( $Return.Interface.Count )) Network Interface(s)" 11 11 15

        $Return.Interface         | % {
            
            $_.IPV4ARP            = $Return.Arp | % { 
            
                If ( $_.Interface.Count -eq 1 )
                {
                    $_.Table
                }
                Else
                {
                    ForEach ( $I in 0..( $_.Interface.Count - 1 ) )
                    { 
                        $_.Table[$I]
                    }
                }
            }

            $_.IPV4NET            = & $Script.Range $_.IPV4Address $_.IPV4Prefix | % {
                    
                [ PSCustomObject ]@{

                    Count         = $_.Count + 2
                    Range         = ( $_.Range -join '/' ).Replace( "*" , "0..255" )
                    Collect       = @( )
                
                }
            }
        }

        $Return.Interface            | % { 

            $_.IPV4Net               = $_.IPV4Net | % { 
        
                $Obj                 = $_
            
                ForEach ( $I in 3..0 )
                {
                    $Current         = IEX $Obj.Range.Split('/')[$I]
                
                    If ( $_.Collect.Count -eq 0 ) 
                    { 
                        $Current     | % { $Obj.Collect += $_ } 
                    }

                    Else
                    {
                        $Expand      = $Obj.Collect.Clone()
                        $Obj.Collect = @( )
                    
                        ForEach ( $J in $Current ) 
                        {
                            $Expand  | % { $Obj.Collect += $J , $_ -join '.' }
                        }
                    }
                }

                [ PSCustomObject ]@{

                    Network          = $Obj.Collect[0]
                    Start            = $Obj.Collect[1]
                    End              = $Obj.Collect[-2]
                    Broadcast        = $Obj.Collect[-1]
                    Report           = ForEach ( $I in 1..$( $Obj.Collect.Count - 2 ) )
                    {
                        [ PSCustomObject ]@{ 

                            Status   = New-Object System.Net.NetworkInformation.Ping | % { $_.SendPingAsync( 
                            
                                $Obj.Collect[$I] , 
                                100 , 
                                ( 97..119 + 97..105 | % { "0x$( "{0:x}" -f $_ )" } ) , 
                                ( New-Object System.Net.NetworkInformation.PingOptions ) ) } | % { $_.Result.Status }

                           Address  = $Obj.Collect[$I]
                        }
                    }
                }
            }
        }
        
        $Return                                                                      #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}
