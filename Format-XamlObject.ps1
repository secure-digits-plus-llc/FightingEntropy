Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script                                 = [ PSCustomObject ]@{

            Object                              = {

                Param ( $Xaml )                   

                [ PSCustomObject ]@{ 

                    Track                       = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) )
                    {
                        [ PSCustomObject ]@{ 

                            Index               = $I
                            Line                = $Xaml.Split("`n")[$I]
                        }
                    }
                    Xaml                        = $Xaml 
                    Array                       = $Xaml.Split("`n") 
                    Items                       = $Xaml.Split("`n").Split(' ') | ? { $_.Length -gt 0 }
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
                    Slice                       = ""
                    Depth                       = ""
                    Indent                      = ""
                    End                         = ""
                    Tag                         = ""
                    Property                    = $Null
                    Value                       = $Null
                }
            }
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯   Begin Parameter [~] : Pull Objects and loads initial process                                 ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Begin
        {
            $Drive                              = "DSC:"
            $Name                               = $Null
            $Path                               = $Null
            $Root                               = & $Script.Object $Xaml_Input
            $Depth                              = 0
            $Type                               = "@"
            $Indent                             = 0
            $Return                             = $Root.Items -match "<"
            $Count                              = $Return.Count - 1
            $Index                              = 0
            $X                                  = 0
            $I                                  = 0
            $T                                  = @( )
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

                $T[$X].Tag                      = $Return[$X] -Replace "(\s+)" , ""
                $T[$X].Type                     = $Type                
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
                $T[$X].Track                    = $T[$X].Track -Replace "(\s+)" , " " -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"
                $T[$X].Slice                    = $T[$X].Track -Replace ( $T[$X].Tag + " " ) , "" -Replace "' " , "';" -Split ";"

                If ( $T[$X].Slice.Count -gt 1 )
                {
                    If ( $T[$X].Slice.Count -eq 1 )
                    {
                        $T[$X].Property         = $T[$X].Slice.Split(' ')[0]
                        $T[$X].Value            = $T[$X].Slice -Replace ( $T[$X].Property + " = " ) , ''
                    }

                    Else
                    {
                        $T[$X].Property         = 0..( $T[$X].Slice.Count - 1 ) | % { $T[$X].Slice[$_].Split(' ')[0] }
                        $T[$X].Value            = 0..( $T[$X].Slice.Count - 1 ) | % { $T[$X].Slice[$_] -Replace ( $T[$X].Property[$_] + " = " ) , '' }
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

                If ( $Sw0 -ne $True  -and $T[$X].Tag   -match "(<\/)"  -and $T[$X].Type -eq "/" )
                { 
                    $Sw0 = $True
                } 

                If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" )
                {
                    $Sw0 = $False
                }

                $T[$X].Indent                   = @{
                    
                    "@"                         = 0
                    "/"                         = If ( $Sw0 ) { $Depth - 3 } Else { $Depth - 1 }
                    "-"                         = If ( $Sw0 ) { $Depth - 2 } Else { $Depth - 1 }
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
            $Buffer                             = [ PSCustomObject ]@{  # Numbers only

                Indent                          = ""
                MaxIndent                       = ( $T.Indent                     | Sort )[ -1 ] * 4
                PostIndent                      = ""
                OutputIndent                    = ""

                Tag                             = ""
                MaxTag                          = ( $T.Tag      | % { $_.Length } | Sort )[ -1 ]
                PostTag                         = ""
                OutputTag                       = ""

                Property                        = ""
                MaxProperty                     = ( $T.Property | % { $_.Length } | Sort )[ -1 ]
                PostProperty                    = ""
                OutputProperty                  = ""
            }
            
            ForEach ( $X in 0..$Count )
            {
                $Buffer                         | % { 

                    $_.Indent                   = $T[$X].Indent * 4
                    $_.PostIndent               = $_.MaxIndent - $_.Indent
                    $_.OutputIndent             = ( " " * $_.Indent ) 
                
                    $_.Tag                      = $T[$X].Tag.Length
                    $_.PostTag                  = $_.MaxTag - $_.Tag
                    $_.OutputTag                = $T[$X].Tag

                    "{0}{1}" -f $_.OutputIndent , $_.OutputTag
                }
            }

                
                $Indent                         = $T[$X].Indent * 4
                $PostIndent                     = $Indent
                $Item                           = $T[$X].Tag.Length 
                $Space                          = $Buffer.Left + $Buffer.Tag 
                
                - ( $Indent + $Item )

                    $Max                        = [ PSCustomObject ]@{ 

                        Margin                  = $Indent 
                        Item                    = $T[$X].Tag
                        Space                   = $Buffer.Left - ( $T[$X].Indent * 4 )  
                        Indent                  = $Buffer.Left
                        Item                    = $Buffer.Tag
                    }
                }

                "{0} {1}" -f $Indent , $Item
                
                # ____________________________________________________                                                     | MaxIndent  
                #                                                     _______________________________________
                # [        ]                             # Actual Indent                                                   | MaxIndent   
                #           [       ]                    # Actual Tag                                                      | MaxTag
                # [                                    ] # [Indent] + [Item buffer] = Maximum length                       | MaxLength
                #                    [                 ] # Remaining Space                               | MaxSpace


                # /__ General __/
                # Indent                    = $Buffer | % { $_.Left + $_.Tag }
                # Tag                       = 

                $MaxIndent                      = $Buffer | % { $_.Left * 4 }    # {0}[ Maximum Indent/Margin Buffer ]
                $MaxSpace                       = $MaxIndent + $Buffer.Tag       # {1}[ Maximum     Space/Tag Buffer ]
                $MaxProperty                    = $Buffer.Property + $MaxSpace   # {2}[ Maximum      Property Buffer ]

                If ( $T[$X].Property.Count -eq 0 )
                {   

                }

                If ( $T[$X].Property.Count -eq 1 )
                {

                }

                If ( $T[$X].Property.Count -gt 1 )
                {

                    ForEach ( $J in 0..( $T[$X].Property.Count - 1 ) )
                    {
                        If ( $J -eq 0 )
                        {
                        
                        }

                    }
                }
            }
        }
