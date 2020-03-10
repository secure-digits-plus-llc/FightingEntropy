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

                    Split = $Xaml.Split("`n")
                    Track = 0..( $Xaml.Split("`n").Count - 1 )
                    Depth = 0
                    Count = 0
                    Items = @( )
                    Focus = @( )
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

                $Current              = @( )
                $Index                = 0
                $Track                = 0

                $Items                = $Return.Focus.Items | ? { $_    -match "<" }
                $Props                = $Return.Focus.Items | ? { $_ -notmatch "<" }

                ForEach ( $X in 0..( $Items.Count - 1 ) )
                {
                    $Current          = $Items[$X] -join ''

                    If ( $Items[$X] -notmatch ">" )
                    {
                        Do
                        {
                            $Current  = "{0} {1}" -f $Current , $Props[$Track]
                            $Track    ++
                        }
                        Until ( $Current -match ">" )
                    }

                    $Return.Items    += $Current 
                    $Current          = @( )
                    $Index           ++
                }
            }
        }
