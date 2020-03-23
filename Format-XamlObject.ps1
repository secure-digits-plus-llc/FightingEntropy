Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯   Begin Parameter [~] : Pull Objects and loads initial process                                 ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Begin 
        {
            $Script                                 = [ PSCustomObject ]@{

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
                        Property                    = $Null
                        Value                       = $Null
                    }
                }
            }
                
            $Drive                                  = "DSC:"
            $Name                                   = $Null
            $Path                                   = $Null
            $Root                                   = & $Script.Object $Xaml_Input
            $Depth                                  = 0
            $Type                                   = "@"
            $Indent                                 = 0
            $Return                                 = $Root.Items -match "<"
            $Count                                  = $Return.Count - 1
            $Index                                  = 0
            $X                                      = 0
            $I                                      = 0
            $T                                      = @( )
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯           Process [~] : Re-track and Re-calculate positioning of Objects                       ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Process
        {
            ForEach ( $X in 0..$Count )
            {
                Write-Progress -Activity "Collecting [~] Track Information" -PercentComplete ( ( $X / $Count ) * 100 )

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

                $T[$X].Tag                      = $Return[$X] -Replace "(\s*)" , ""
                $T[$X].Type                     = $Type
                $T[$X].Track                    = $T[$X].Track -Replace             "(\s+)"  , " " -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"
                $S                              = $T[$X].Track -Replace ( $T[$X].Tag + " " ) ,  "" -Replace        "' " , "';"  -Split           ";"

                If ( $S -match "=" )
                {
                    If ( $S.Count -eq 1 )
                    {
                        $T[$X].Property         = ( $S -Split ' ' )[0]
                        $T[$X].Value            =   $S -Replace ( ( $S -Split ' ' )[0] + " = " ) , ''
                    }

                    If ( $S.Count -gt 1 )
                    {
                        $T[$X].Property         = ForEach ( $J in 0..( $S.Count - 1 ) ) { ( $S[$J] -Split ' '  )[0] }
                        $T[$X].Value            = ForEach ( $J in 0..( $S.Count - 1 ) ) {   $S[$J] -Replace ( $T[$X].Property[$J] + " = " ) , '' }
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
                        
                        If ( $_.Length -eq "" -or $_ -eq $Drive )
                        {
                            "-"
                        }

                        Else
                        {
                            $_
                        }
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

                If ( $Sw0 -ne $True  -and $T[$X].Tag    -match "(<\/)" -and $T[$X].Type -eq "/" )
                { 
                    $Sw0 = $True
                }

                If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" )
                {
                    $Sw0 = $False
                }

                $T[$X].Indent                   = @{
                    
                    "@"                         = 0
                    "/"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "-"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "+"                         = $Depth

                }[ $Type ]
            }
        }

    #    ____    ____________________________________________________________________________________________________      # 
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  # 
    #   \\__//¯¯¯     End Parameter [~] : Finalize the object arrangement for output                             ___//¯¯\\ # 
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// # 
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  # 
        End
        {
            $Max                                = [ PSCustomObject ]@{

                Indent                          = ( $T.Indent                                             | Sort )[ -1 ] * 4
                Tag                             = ( $T.Tag      | % { $_.Length }                         | Sort )[ -1 ]
                Buffer                          = ( $T          | % { $_.Tag.Length + ( $_.Indent * 4 ) } | Sort )[ -1 ]
                Property                        = ( $T.Property | % { $_.Length }                         | Sort )[ -1 ]
            }

            $X                                  = 0

            ForEach ( $X in 0..$Count )
            {
                $OP                             = $T[$X] | % { 
                    
                    [ PSCustomObject ]@{

                        Indent                  = " " * ( $_.Indent * 4 )
                        Tag                     = $_.Tag
                        Remain                  = $Max.Buffer - ( ( $_.Indent * 4 ) + $_.Tag.Length )
                        Buffer                  = $Max.Buffer
                    }
                }

                If ( $OP.Remain -gt 0 )
                { 
                    $Slot = "{0}{1}{2}" -f $OP.Indent , $OP.Tag , ( " " * $OP.Remain )
                } 
                
                If ( $OP.Remain -eq 0 )
                { 
                    $Slot = "{0}{1}" -f $OP.Indent , $OP.Tag
                }

                If ( $T[$X].Property -ne $Null )
                {
                    If ( $T[$X].Property.Count -eq 1 )
                    {
                        [ PSCustomObject ]@{

                            Object   = $Slot
                            Property = $T[$X].Property + ( " " * ( $Max.Property - $T[$X].Property.Length ) )
                            Value    = $T[$X].Value
                        
                        } | % { "{0} {1} = {2}" -f $_.Object  , $_.Property  , $_.Value }
                    }
        
                    If ( $T[$X].Property.Count -gt 1 )
                    {
                        ForEach ( $J in 0..( $T[$X].Property.Count - 1 ) )
                        {    
                            [ PSCustomObject ]@{

                                Object   = If ( $_ -eq 0 ) { $Slot } Else { " " * $OP.Buffer }
                                Property = $T[$X].Property[$J] + ( " " * ( $Max.Property - $T[$X].Property[$J].Length ) )
                                Value    = $T[$X].Value[$J]
                            
                            } | % { "{0} {1} = {2}" -f $_.Object , $_.Property  , $_.Value }
                        }
                    }
                }

                Else
                {
                    $Slot
                }
            }
        }
