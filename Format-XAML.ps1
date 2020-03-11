Function Create-XamlObject
    {
        [ CmdLetBinding () ] Param ( [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script       = [ PSCustomObject ]@{

            Tab       = {

                Param ( $Line )

                $X,$Y = 0,0

                Do 
                {
                    If ( $Line[$X] -match "\s" ) { $X ++ } Else { $Y = 1 }
                }
                Until ( $Y -eq 1 )

                $X
            }

            XamlObject                = {

                Param ( $XAML )

                $Return               = [ PSCustomObject ]@{

                    Index             = 0
                    Count             = 0
                    Track             = 0..( $Xaml.Split("`n").Count - 1 )
                    Split             = $Xaml.Split("`n")               
                    Items             = @( )
                    Focus             = @( )
                }

                $Return.Focus         = ForEach ( $I in 0..( $Return.Split.Count - 1 ) )
                {
                    $Return.Split[$I] | % {

                        [ PSCustomObject ]@{

                            Track     = $I
                            Tab       = & $Script.Tab $_
                            Line      = $_
                            Items     = $_.Split(" ") | ? { $_.Length -gt 0 }
                        }
                    }
                }

                $Index                = 0
                $Track                = 0
                
                $List                 = $Return.Focus | ? { $_.Items    -match "<" }
                $Tabs                 = $List.Tab
                $Items                = $Return.Focus.Items    -match "<"
                $Props                = $Return.Focus.Items -notmatch "<"

                ForEach ( $X in 0..( $List.Count - 1 ) )
                {
                    $Current          = [ PSCustomObject ]@{

                        Index         = $X
                        Indent        = $Tabs[$X]
                        Item          = $Items[$X]
                        Buffer        = $Tabs[$X] + $Items[$X].Length + 1
                        Value         = @( )
                    }

                    If ( $Items[$X] -notmatch ">" )
                    {
                        Do
                        {
                            $Current.Value += $Props[ $Track ]
                            $Track  ++
                        }
                        Until ( $Props[ $Track - 1 ] -match ">" )

                        $Current.Value = ( $Current.Value -join ' ' ).Replace("' />","'/>").Replace("' >","'>").Replace("' ","';").Split(';')
                    }

                    $Return.Items    += $Current
                    $Index           ++
                }
            }
        }
