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
            Upper                     = ""
            Lower                     = ""
        }

        $Get | % { 

            If ( $_.Config.Count -gt $_.Current.Count )
            {
                $_.Index              = 0..( $_.Config.Count - 1 )
                $_.Upper              = $_.Config.Service
                $_.Lower              = $_.Current.Name
            }

            Else
            {
                $_.Index              = 0..( $_.Current.Count - 1 )
                $_.Upper              = $_.Current.Name
                $_.Lower              = $_.Config.Service
            }

            $Get.Index                = $Get.Upper.Count | Measure -Character | % { $_.Characters } | % {
            
                ForEach ( $I in $Get.Index ) { "{0:d$_}" -f $I }
            }
            
            $_.Scoped                 = $_.Index | % { "-" }
            $_.Profile                = $_.Index | % { "-,-,-,-,-,-,-,-,-,-" }
            $_.Name                   = $_.Index | % { "-" }
            $_.StartMode              = $_.Index | % { "-" }
            $_.State                  = $_.Index | % { "-" }
            $_.DisplayName            = $_.Index | % { "-" }
            $_.PathName               = $_.Index | % { "-" }
            $_.Description            = $_.Index | % { "-" }
        }

        $Master                       = [ PSCustomObject ]@{
            
            Config                    = $Get.Upper       | ? { $_ -in $Get.Config.Service }
            Current                   = $Get.Upper       | ? { $_ -in $Get.Current.Name   }

            Bound                     = [ PSCustomObject ]@{ Config = @( ) ; Current = @( ) }
            Unbound                   = [ PSCustomObject ]@{ Config = @( ) ; Current = @( ) }

            Aggregate                 = @( )
        }

        ForEach ( $I in $Get.Index )
        {       
            $Get.Upper[$I]            | % {

                If ( $_ -in    $Get.Config.Service ) { $Master.Bound.Config       += $I }
                If ( $_ -in      $Get.Current.Name ) { $Master.Bound.Current      += $I }
                If ( $_ -notin $Get.Config.Service ) { $Master.Unbound.Config     += $I }
                If ( $_ -notin   $Get.Current.Name ) { $Master.Unbound.Current    += $I }
            }
        }

        $Y                  = $Master | % { $_.Bound , $_.Unbound | % { $_.Config , $_.Current } } | % { $_.Count } | Sort
        $C                  = 0

        0..$Get.Index.Count | % {

            If ( $Y[$C] -eq $_ )
            {
                $Z[$C]      = ( "X,-,~,+".Split(',') | % { "[$_]" } )[$C]
                $C ++
            }
        }

        $C = 0
        
        $Master | % { $_.Unbound , $_.Bound } | % { 

            If ( $_.Config.Count -gt $_.Current.Count )
            {
                $_.Config  , $_.Current       | % { 
                    
                    $Get.Scoped[$_]           = $Z[$C] 
                    
                    $C ++ 
                }
            }
        }

        $Master.Bound | % { 
        
            If ( $_.Config.Count -gt $_.Current.Count )
            {
                $_.Config  | % { $Get.Scoped[$_] = $Z[2] }
                $_.Current | % { $Get.Scoped[$_] = $Z[3] }
            }
        }

            If ( $_.Current.Count -gt $_.Config.Count )
            {
                $_.Current | % { $Get.Scoped[$_] = $Z[0] }
                $_.Config  | % { $Get.Scoped[$_] = $Z[1] }
            }
        }

        $Master.Bound | % { 
        
            If ( $_.Config.Count -gt $_.Current.Count )
            {
                $_.Config  | % { $Get.Scoped[$_] = $Z[2] }
                $_.Current | % { $Get.Scoped[$_] = $Z[3] }
            }

            If ( $_.Current.Count -gt $_.Config.Count )
            {
                $_.Current | % { $Get.Scoped[$_] = $Z[2] }
                $_.Config  | % { $Get.Scoped[$_] = $Z[3] }
            }
        }
                

            

        $Master.Unbound.Config  | % { $Get.Scoped[$_] = $Z[0] }
        $Master.Unbound.Current | % { $Get.Scoped[$_] = $Z[1] }
        $Master.Bound.Config    | ? { $_ -notin $Master | % { $Get.Scoped[$_] = $Z[2] }
        $Master.Bound.Current   | % { $Get.Scoped[$_] = $Z[3] }
        
        
        
            $Get.Name[$I]                = $Get.Upper[$I]
            $Get.Profile[$I]             = $Get.CFG[$I].Profile
            $Get.Current.Name[$I]        = 
            $Get.Current.StartMode[$I]   = $Current.StartMode
            $Get.State[$I]               = $Current.State
            $Get.DisplayName[$I]         = $Current.DisplayName
            $Get.PathName[$I]            = $Current.PathName
            $Get.Description[$I]         = $Current.Description

                If ( $Get.CFG[$I].Service -in $Master.Scoped )
                {
                    $Get.Scoped[$I]   = "+"
                }
            }
        }
