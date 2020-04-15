$Xaml                     = @{  
            
                $True                 = $Xaml -Replace "'" , '&apos;'
                $False                = $Xaml -Replace "'" , '"' 
        
            }[ ( $Xaml -Split '"' ).Count -gt ( $Xaml -Split "'" ).Count ] 

            $Xaml                     = $Xaml -Replace "([{]\s)","{" -Replace "(\s[}])","}"

            0..5                      | % { 
            
                $Xaml                 = $Xaml -Replace "([\s]*[=][\s]*),(\s+),([\`"][\s]*>),([\`"][\s]*/>),([*]),> <".Split(',')[$_] , "=, ,`">,`"/>,&star;,>`n<".Split(',')[$_] 
            }

            0..5                      | % { 
            
                $Xaml                 = $Xaml -Replace "&$("quot,amp,apos,star,lt,gt".Split(',')[$_]);" , "&#$((34,38,39,42,60,62)[$_]);" 
            }

            ( [ Regex ] "(&#x)+([0-9A-Fa-f]*;)" ).Matches( $Xaml ).Value | Select -Unique | % { 
            
                $Xaml                 = $Xaml -Replace $_ , ( "&#{0};" -f ( $_.Replace("&#x","").Replace(";","") | % { [Convert]::ToInt64($_,16)} ) )
            }

            # Run Here 

            $I                        = 0
            $Index                    = 0
            $Type                     = "@"
            $Drive                    = "XAML:"
            $Name                     = "Window"
            $Parent                   = "$Drive\$Name"
            $Path                     = "$Drive\$Name"
            $Depth                    = 0
            $Xaml                     = $Xaml -Split "`n"
            $Count                    = 0..( $Xaml.Count - 1 )

            $Root                     = [ PSCustomObject ]@{
            
                Xaml                  = $Xaml
                Index                 = $Count
                Drive                 = "XAML:"
                Parent                = $Name
                Path                  = "$Drive\$Name"
                Name                  = 0..( $Xaml.Count - 1 ) | % { ( $Xaml[$_] -Split " " )[0] -Replace "<","" -Replace "/","" -Replace ">","" }
                Track                 = 0..( $Xaml.Count - 1 ) | % {   $Xaml[$_] }
                Type                  = 0..( $Xaml.Count - 1 ) | % {
                
                    @{  $True         = "@"
                        $False        = Switch -Regex ( $Xaml[$_] ) { "(<[^/].+[^/]>)" {"+"} "([/]>)" {"/"} "(<[/])" {"-"} } }[ ( $_ -eq 0 -or $_ -eq ( $Xaml.Count - 1 ) ) ]
                }
                Tag                   = 0..( $Xaml.Count - 1 ) | % { ( $Xaml[$_] -Split " " )[0] }        
                Depth                 = $Depth
                Range                 = 0..( $Xaml.Count - 1 )
                Count                 = $Xaml.Count
            }
            
            ForEach ( $I in $Root.Range )
            {
                $Index                = $I

                         @{ Activity  = "Collecting [~] Track Information"   # Progress Indicator
                     PercentComplete  = ( ( $Index / $Root.Count ) * 100 ) } | % { Write-Progress @_ }           
                                 
                $Root.Track[$Index]   = $Root.Xaml[$Index] | % {
                     
                    [ PSCustomObject ]@{  
                
                        Index         = $Index
                        Drive         = $Root.Drive
                        Track         = $Root.Xaml[$Index]
                        Type          = $Root.Type[$Index]

                        Path          = @{  "@" = $Root.Drive , "Window" -Join '\'
                                            "+" = $Path , $Root.Name[$Index] -join '\'
                                            "/" = $Path
                                            "-" = Split-Path $Path -Parent -EA 0 }[ $Root.Type[$Index] ]

                        Parent        = @{  "@" = $Root.Drive
                                            "+" = $Path
                                            "/" = Split-Path $Path -Parent -EA 0
                                            "-" = Split-Path $Path -Parent -EA 0 | ? { ( Split-Path $_ -Parent ) -ne "" } }[ $Root.Type[$Index] ]

                        Name          = $Root.Name[$Index]
                        Depth         = $Path.Split("\").Count - 2
                        Tag           = $Root.Tag[$Index]
                        Property      = [ Ordered ]@{ }
                    }
                }
               
                If ( $Root.Tag[$Index] -notmatch "([>])" ) 
                {
                    $Line             = $Root.Xaml[$Index] -Replace ( "{0} " -f $Root.Tag[$Index] ) , "" -Replace "([\`"])+([\s])" , "`"`n" -Split "`n"

                    If ( $Line.Count -gt 1 )
                    {
                        ForEach ( $Z in 0..( $Line.Count - 1 ) )
                        {
                            $Root.Track[$Index].Property.Add( $Line[$Z].Split("=")[0] , $Line[$Z].Split("=")[1] )
                        }
                    }

                    If ( $Line.Count -eq 1 )
                    {
                        $Root.Track[$Index].Property.Add( $Line.Split("=")[0] , $Line.Split("=")[1] )
                    }
                }
                    
                $Path                  = $Root.Track[$Index].Path
                $Root.Track[$Index]
            }
