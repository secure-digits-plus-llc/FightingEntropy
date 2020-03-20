Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( # Still revising
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        # [ Custom Types / Script Blocks ]

        $Script                                 = [ PSCustomObject ]@{ 
        
            Reg                                 = "(?<=\<).+?(?=\>)"   

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
                        
                    Drive                       = $Drive
                    Parent                      = ""
                    Path                        = ""
                    Name                        = ""
                    Depth                       = ""
                    Indent                      = ""
                    Track                       = ""
                    Index                       = $Index
                    Slice                       = ""
                    Property                    = @{ }
                    Children                    = @( )
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
            $Root                               = & $Script.Object $Xaml_Input
            $Drive                              = "DSC:"
            $Name                               = $Null
            $Path                               = $Null
            $Depth                              = 0
            $Return                             = $Root.Items -match "<"
            $Count                              = $Return.Count - 1
    #     _______________________________________________________________________________________________________________  #
    #    /¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[ Start All Templates ]¯\ #
    #    \_______________________________________________________________________________________________________________/ #

            $Index                              = 0
            $X                                  = 0
            $I                                  = 0
            $T                                  = @( )

            ForEach ( $X in 0..$Count )
            {
                $T                             += & $Script.Template $X $Drive 

                $T[$X].Name                     = $Return[$X]
                #-------------

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

                $T[$X].Track                    = $T[$X].Track -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"
                #-------------

                $T[$X].Depth                    = $T[$X].Track | % {

                        If ( $_ -Match "(<[^/].+[^/]>)" ) { "+" } # Indent
                    ElseIf ( $_ -Match ".+(\/>)"        ) { "/" } # No indent
                    ElseIf ( $_ -Match "(<\/).+"        ) { "-" } # Subtract Indent
                    Else                                  { "?" } # Item is unknown
                }
                # -----------

                $T[$X].Slice                    = $T[$X].Track -Replace ( $Return[$X] + " " ) , "" -Replace "' " , "';" -Split ";"
                
                # -----------

                $T[$X].Name                     = $Return[$X]  -Replace "(<*/*\>*)" , ""

                If ( $Path -ne $Null )
                {
                    $T[$X].Path                 = @{

                            "+"                 = $Path , $T[$X].Name -join '\'
                            "/"                 = $Path
                            "-"                 = Split-Path $Path -Parent
    
                    }[ $T[$X].Depth ]

                    $Path                       = $T[$X].Path
                }

                If ( $Path -eq $Null )
                {
                    $Name                       = $T[$X].Name
                    $Path                       = $Drive , $Name -join '\'
                    $T[$X].Path                 = $Path
                }

                $T[$X].Parent                   = Split-Path $Path -Parent
                $T[$X].Indent                   = $Path.Split('\').Count - 1


            }
