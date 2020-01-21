    
    Function Get-LineDepth
    {
        [ CmdLetBinding () ] Param (

            [ Parameter ( Mandatory , ValueFromPipeline ) ] [ String ] $Object )

        $Array     = @( $Object.Split( "`n" ) )
        $Return    = @( 0..( $Array.Count - 1 ) )

        ForEach ( $I in $Return )
        {
            $Parse  = [ PSCustomObject ]@{

                Line    = @( $Array[$I].ToCharArray() )
                Space   = 0
                Factor  = 0
                Remain  = 0
                Content = @( )
            }

            ForEach ( $J in $Parse.Line )
            {
                If ( $Parse.Content.Count -eq 0 )
                {
                    If ( $J -ne " " )
                    {
                        $Parse.Content += $J
                    }

                    Else
                    {
                        $Parse.Space ++
                    }
                }

                Else
                {
                    $Parse.Content += $J
                }
            }

            $Parse | % { 
        
                $_.Remain = $_.Space % 4
                $_.Factor = $( 
            
                    If ( $_.Remain -ne 0 ) 
                    {
                        ( $_.Space - $_.Remain ) / 4
                    }

                    Else
                    {
                        $_.Space / 4
                    }
                )
                $_.Content = $_.Content -join ''
            }

            $Return[$I] = $Parse
        }

        $X = 0..( $Return.Count - 1 )
        $Y = 0..( $Return.Count - 1 ) 

        0..( $Return.Count - 1 ) | % { 

            $X[$_] = $Return[$_].Factor
            $Y[$_] = $( 
    
                If ( $Return[$_].Remain -ne 0 )
                {
                    ( " " * $Return[$_].Remain ) + $Return[$_].Content
                }

                Else
                {
                    $Return[$_].Content
                }
            )
        }

        [ PSCustomObject ]@{

            X = $X -join ','
            Y = ( $Y.Replace( '"' , "'" ) | % { '"' + $_ + '"' } )
        }
    }


    Get-LineDepth -Object @"

"@ | % { $X = $_.X ; $Y = $_.Y } 

    $M = 0..3 | % { $X = @( '¯' , '_' , ' ' , '-' )[$_] ; IEX "`$M$_ = [ PSCustomObject ]@{ Char = '$X' };" }

    ForEach ( $I in $M0 , $M1 , $M2 , $M3 )  
    {
        0..120   | % { 
        
            $Value = ( $I.Char * $_ ) -join ''

            $I   | Add-Member -MemberType NoteProperty -Name $_ -Value $Value 
        }
    }
