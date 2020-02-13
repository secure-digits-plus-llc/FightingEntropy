 Function Get-ServiceProfile #_______________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Write-Theme -Action "Collecting [+]" "[ Service Configuration ]: Current Profile"

        $Get                          = [ PSCustomObject ]@{ 

            Config                    = Resolve-ViperBomb -Config
            Current                   = Get-CurrentServices
            Index                     = ""
            Scoped                    = @( )
            Profile                   = @( )
            Name                      = @( )
            StartMode                 = @( )
            State                     = @( )
            DisplayName               = @( )
            PathName                  = @( )
            Description               = @( )
            Track                     = [ PSCustomObject ]@{

                Current               = [ PSCustomObject ]@{

                    Include           = ""
                    Exclude           = ""
                    Count             = ""
                }

                Config                = [ PSCustomObject ]@{ 
                    
                    Include           = ""
                    Exclude           = ""
                    Profile           = ""
                    Count             = ""
                }
            }
        }

        $Get.Track                    | % { 
        
            $_.Current                | % { 
        
                $_.Include            = $Get.Current     | ? { $_.Name    -in $Get.Config.Service } | % { $_.Name }
                $_.Exclude            = $Get.Current     | ? { $_.Name -notin $Get.Config.Service } | % { $_.Name }
                $_.Count              = $_.Include.Count + $_.Exclude.Count
            }

            $_.Config                 | % { 

                $_.Include            = $Get.Config      | ? { $_.Service    -in $Get.Current.Name   } | % { $_.Service }
                $_.Exclude            = $Get.Config      | ? { $_.Service -notin $Get.Current.Name   } | % { $_.Service }
                $_.Profile            = $Get.Config      | ? { $_.Service    -in $Get.Current.Name   }
                $_.Count              = $_.Include.Count + $_.Exclude.Count
            }
        }

        $Get.Index                    = 0..( $Get.Current.Count - 1 )

        $Get.Index                    = $Get.Index.Count | Measure -Character | % { $_.Characters } | % {
            
            ForEach ( $I in $Get.Index ) { "{0:d$_}" -f $I }
        }
        
        $Get | % { 

            $_.Scoped                 = $_.Index | % { "[-]" }
            $_.Profile                = $_.Index | % { "-,-,-,-,-,-,-,-,-,-" }
            $_.Name                   = $_.Index | % { "-" }
            $_.StartMode              = $_.Index | % { "-" }
            $_.State                  = $_.Index | % { "-" }
            $_.DisplayName            = $_.Index | % { "-" }
            $_.PathName               = $_.Index | % { "-" }
            $_.Description            = $_.Index | % { "-" }
        }

        $Get.Track.Config.Profile     = $Get.Config | ? { $_.Service -in $Get.Current.Name }

        ForEach ( $I in $Get.Index )
        {
            $Get.Name[$I]             = $Get.Current.Name[$I]
                
            If ( $Get.Name[$I]     -in $Get.Track.Current.Include )
            {
                $Get.Scoped[$I]       = "[+]"
                $Get.Profile[$I]      = $Get.Track.Config.Profile | ? { $_.Service -eq $Get.Name[$i] } | % { $_.Profile }
                $Get.StartMode[$I]    = $Get.Current.StartMode[$I]
                $Get.State[$I]        = $Get.Current.State[$I]
                $Get.DisplayName[$I]  = $Get.Current.DisplayName[$I]
                $Get.PathName[$I]     = $Get.Current.PathName[$I]
                $Get.Description[$I]  = $Get.Current.Description[$I]
            }

            If ( ( $Get.Name[$I] -in $Get.Current.Name ) -and ( $Get.Name[$I] -in $Get.Track.Current.Exclude ) )
            {
                $Get.Scoped[$I]       = "[_]"
                $Get.Profile[$I]      = "-,-,-,-,-,-,-,-,-,-"
                $Get.StartMode[$I]    = $Get.Current.StartMode[$I]
                $Get.State[$I]        = $Get.Current.State[$I]
                $Get.DisplayName[$I]  = $Get.Current.DisplayName[$I]
                $Get.PathName[$I]     = $Get.Current.PathName[$I]
                $Get.Description[$I]  = $Get.Current.Description[$I]
            }
        }

        $Return                       = $Get.Index | % { 
        
            [ PSCustomObject ]@{ 
            
                Index                 = $Get.Index[$_]
                Scoped                = $Get.Scoped[$_]
                Profile               = $Get.Profile[$_]
                Name                  = $Get.Name[$_]
                StartMode             = $Get.StartMode[$_]
                State                 = $Get.State[$_]
                DisplayName           = $Get.DisplayName[$_]
                PathName              = $Get.PathName[$_]
                Description           = $Get.Description[$_]
            } 
        }

        $Return

        Write-Theme -Action  "Importing [+]" "[ Service Configuration ]: Target Profile"

                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}
