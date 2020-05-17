            $Model                      = [Model]::new("Action")

            $Track                      = "   \\__//¯¯¯[ ________________________________________________________________________________________ ]    ___//¯¯\\   "
                                            
            $Slot                       = ([Range]$Track.Length).Range | ? { $_ % 4 -eq 0 } | % { [Face]::New($Track.Substring($_,4)) }

            $Mode                       = ([Range]$Slot.Count).Range | % { [Mask]::new($_,$Slot[$_].Rank,$Slot[$_].String) } 

            $Mask                       = @( )

            $Index                      = -1
            $String                     = -1
            $Last                       = $Null
            $Table                      = @{ }

            $Return                     = @( )

            ForEach ( $X in 0..( $Slot.Count - 1 ) )
            {
                If ( $Mode[$X] | % { $_.Index -eq 0 -or $_.String -ne $Mode[$X-1].String } ) 
                {
                    $Switch             = 1
                    $Index             ++
                    $Mask              += $Mode[$X]
                }
                
                Else 
                {
                    $Switch             = 0
                    $Mask[$Index].Count ++
                }

                $Mask[$Index].Index     = $Index

                If ( $Last -eq $Null -or $Last -ne $Switch )
                {
                    $String            ++
                    $Table.Add( $String , @( ) )
                }

                $Table[$String]        += $Index

                $Last                   = $Switch
            }

            $Return                     = ForEach ( $X in 0..( $Table.Count - 1 ) )
            { 
                $Total                  = $Table[$X] | Select -Unique

                If ( $Total.Count -gt 1 ) { "{0}..{1}" -f $Total[0,-1] }

                Else { "@({0})*{1}" -f $Total[0] , $Table[$X].Count }
            }

            $Return                    = "@({0})" -f ( $Return -join ';' )
