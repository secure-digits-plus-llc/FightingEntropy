Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

                $Xaml                                   = @{  
            
            $True                               = $Xaml -Replace "'" , '&apos;'
            $False                              = $Xaml -Replace "'" , '"' 
        
        }[ ( $Xaml -Split '"' ).Count -gt ( $Xaml -Split "'" ).Count ] 
            
        0..5 | % { $Xaml = $Xaml -Replace "([\s]*[=][\s]*),(\s+),([\`"]\s\/\>),([\`"]\/\>),([*]),> <".Split(',')[$_] , "=, ,`"/>,`">,&star;,>`n<".Split(',')[$_] }

        0..5 | % { $Xaml = $Xaml -Replace "&$("quot,amp,apos,star,lt,gt".Split(',')[$_]);" , "&#$((34,38,39,42,60,62)[$_]);" }

        ( [ Regex ] "(&#x)+([0-9A-Fa-f]*;)" ).Matches( $Xaml ).Value | Select -Unique | % { 
            
            $Xaml = $Xaml -Replace $_ , ( "&#{0};" -f ( $_.Replace("&#x","").Replace(";","") | % { [Convert]::ToInt64($_,16)} ) )
        }

        $Xaml                                   = $Xaml -join "`n"

        $Script                                 = [ PSCustomObject ]@{

            Character                           = {

                Param ( $I )

                [ PSCustomObject ]@{

                    Index       = $I
                    Tag         = ""
                    Character   = [ Char ] $I
                    Decimal     = "{0:D}" -f $I
                    Hexidecimal = "{0:X}" -f $I 
                }
            }

            Object                              = {

                Param ( $Xaml )                   

                [ PSCustomObject ]@{ 

                    Array                       = $Xaml.Split("`n")
                    Items                       = $Xaml.Split("`n").Split(' ') | ? { $_.Length -gt 0 }
                    Track                       = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) )
                    {
                        [ PSCustomObject ]@{

                            Index               = $I
                            Line                = $Xaml.Split("`n")[$I]
                        }
                    }
                    Xaml                        = $Xaml 
                }
            }
            
            Template                            = {

                Param ( $Index , $Drive )

                [ PSCustomObject ]@{
                            
                    Index                       = $Index
                    Drive                       = $Drive
                    Track                       = ""
                    Type                        = ""
                    Path                        = ""
                    Parent                      = ""
                    Name                        = ""
                    Depth                       = ""
                    Indent                      = ""
                    Tag                         = ""
                    Property                    = [ Ordered ]@{ }
                }
            }
        }
                
        $Drive                                  = "DSC:"
        $Name                                   = $Null
        $Path                                   = $Null
        $Root                                   = & $Script.Object $Xaml
        $Depth                                  = 0
        $Type                                   = "@"
        $Indent                                 = 0
        $Return                                 = $Root.Items -match "<"
        $Count                                  = $Return.Count - 1
        $Index                                  = 0
        $X                                      = 0
        $I                                      = 0
        $T                                      = @( )

        ForEach ( $X in 0..$Count )
        {
            $T                             += & $Script.Template $X $Drive
            $T[$X].Track                    = $Return[$X]

            If ( $T[$X].Track -notmatch ">" )
            {
                While( $T[$X].Track -notmatch ">" )
                {
                    $Index ++
                    $T[$X].Track            = $T[$X].Track , $Root.Items[ $Index ] -join ' '
                }
            }
            $Index ++

            $T[$X].Track                    = $T[$X].Track -Replace  "(\s+)"  , " " -Replace '(\"\s\/>)' , '"/>' -Replace '(\"\s[>])' , '">'
        }

        ForEach ( $X in 0..$Count )
        {
            Write-Progress -Activity "Collecting [~] Track Information" -PercentComplete ( ( $X / $Count ) * 100 )

            $T[$X].Tag                      = $Return[$X] -Replace "(\s*)" , ""
            $T[$X].Type                     = $Type

            $T[$X].Track -Replace ( "{0} " -f $T[$X].Tag ) , "" | % { 
                
                If ( $_ -ne $T[$X].Tag )
                {
                    $S = $_ -Replace "`" " , "`"`n" -Split "`n"

                    If ( $S.Count -eq 1 )
                    {
                        $P = $S.Split(" = ") 
                        $T[$X].Property.Add( $P[0] , $P[1] )
                    }

                    If ( $S.Count -gt 1 )
                    {
                        0..( $S.Count - 1 )     | % { 
                        
                            $P = $S[$_].Split(" = ")
                            $T[$X].Property.Add( $P[0] , $P[1] )
                        }
                    }
                }
            }

            $Type                           = $T[$X].Track | % {

                If     ( $_ -Match "(<[^/].+[^/]>)" ) { "+" }
                ElseIf ( $_ -Match ".+(\/>)"        ) { "/" }
                ElseIf ( $_ -Match "(<\/).+"        ) { "-" }
                Else                                  { "?" }
            }

            $T[$X].Name                     = $Return[$X] -Replace "(<*/*\>*)" , ""

            If ( $Path -ne $Null )
            {
                $T[$X].Path                 = @{ 
                        
                    "+"                     = $Path , $T[$X].Name -join '\'
                    "/"                     = $Path 
                    "-"                     = Split-Path $Path -Parent
                    
                }[ $T[$X].Type ]

                $Path                       = $T[$X].Path

                $T[$X].Parent               = Split-Path $Path -Parent | % {
                        
                    If ( $_.Length -eq "" -or $_ -eq $Drive ) { "-" } Else { $_ }
                }
            }

            If ( $Path -eq $Null )
            {
                $Name                       = $T[$X].Name
                $Path                       = $Drive , $Name -join '\'
                $T[$X].Parent               = $Drive
                $T[$X].Path                 = $Path
            }

            $Depth                          = $Path.Split('\').Count - 2
            $T[$X].Depth                    = $Depth

            If ( $Sw0 -ne $True  -and $T[$X].Tag    -match "(<\/)" -and $T[$X].Type -eq "/" ) { $Sw0 = $True  }
            If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" ) { $Sw0 = $False }

            $T[$X].Indent                   = @{
                    
                "@"                         = 0
                "/"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                "-"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                "+"                         = $Depth

            }[ $Type ]
        }

        $Max                                = [ PSCustomObject ]@{

            Indent                          = ( $T.Indent                                           | Sort )[ -1 ] * 4
            Tag                             = ( $T.Tag    | % { $_.Length }                         | Sort )[ -1 ]
            Buffer                          = ( $T        | % { $_.Tag.Length + ( $_.Indent * 4 ) } | Sort )[ -1 ]
            Property                        = ( 0..$Count   | % { $T[$_].Property.GetEnumerator() | % { $_.Name.Length } } | Sort )[-1]
        }

        $X                                  = 0
        $Output                             = New-Object System.Collections.ObjectModel.Collection[Object]

        ForEach ( $X in 0..$Count )
        {
            $OP                             = [ PSCustomObject ]@{

                Indent                      = " " * ( $T[$X].Indent * 4 )
                Tag                         = $T[$X].Tag
                Remain                      = $Max.Buffer - ( ( $T[$X].Indent * 4 ) + $T[$X].Tag.Length )
                Buffer                      = $Max.Buffer
            }

            $Slot = @{ 

                $True                       = "{0}{1}{2}" -f $OP.Indent , $OP.Tag , ( " " * $OP.Remain )
                $False                      = "{0}{1}" -f $OP.Indent , $OP.Tag
                
            }[ $OP.Remain -gt 0 ]

            If ( $T[$X].Property.Count -eq 0 )
            {
                $Output += $Slot
            }

            If ( $T[$X].Property.Count -eq 1 )
            {
                $Output += "{0} {1} = {2}" -f $Slot , 
                ( $T[$X].Property.GetEnumerator().Name | % { $_ + ( " " * ( $Max.Property - $_.Length ) ) } ) , $T[$X].Property[0]
            }
            
            If ( $T[$X].Property.Count -gt 1 )
            {
                ForEach ( $J in 0..( $T[$X].Property.Count - 1 ) )
                {        
                    $Output += "{0} {1} = {2}" -f ( @{ $True = $Slot ; $False = " " * $OP.Buffer }[ $J -eq 0 ] ) , 
                    ( $T[$X].Property.GetEnumerator().Name[$J] | % { $_ + ( " " * ( $Max.Property - $_.Length ) ) } ) , $T[$X].Property[$J]
                }
            }
        }

        [ PSCustomObject ]@{ 

            Input  = $Root     # Array, Items, Track, Xaml
            Track  = $T
            Max    = $Max      # Indent, Tag, Buffer, Property
            Output = $Output   # Final
        }
}
