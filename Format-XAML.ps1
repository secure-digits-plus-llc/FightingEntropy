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

            XamlObject = {

                Param ( $XAML )

                $Return = [ PSCustomObject ]@{

                    Split   = $Xaml.Split("`n")
                    Track   = 0..( $Xaml.Split("`n").Count - 1 )
                    Count   = 0
                    Items   = @( )
                    Indent  = @( )
                    Focus   = @( )
                }

                ForEach ( $I in 0..( $Return.Split.Count - 1 ) )
                {
                    $Return.Focus += $Return.Split[$I] | % { 

                        [ PSCustomObject ]@{

                            Track = $I
                            Tab   = & $Script.Tab $_
                            Line  = $_
                            Items = $_.Split(" ") | ? { $_.Length -gt 0 }
                        }
                    }
                    $Return.Count ++
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

                        Track         = $X
                        Indent        = $Tabs[$X]
                        Item          = $Items[$X]
                        Values        = @( )
                    }

                    If ( $Items[$X] -notmatch ">" )
                    {
                        Do
                        {
                            $Value           = $Props[$Track]
                            $Current.Values += $Value
                            $Track          ++
                        }

                        Until ( $Value -match ">" )

                        $Current.Values      = ( $Current.Values -join ' ' ).Replace("' ","'`n")
                    }

                    $Return.Items    += $Current
                    $Index           ++
                }
            }
        }
