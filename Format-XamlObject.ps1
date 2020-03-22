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
