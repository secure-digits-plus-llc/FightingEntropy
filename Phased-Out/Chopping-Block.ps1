#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Import-ServiceConfiguration #______________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param ( 
        
            [ Parameter ( ParameterSetName = "Default" ) ] [ Switch ] $Default ,
            [ Parameter ( ParameterSetName =    "Load" ) ] [ Switch ] $Load    ,
            [ Parameter ( ParameterSetname =  "Custom" ) ] [ String ] $Custom  )

        $Configuration          = Resolve-ViperBomb -Config | % { $_.Service }

        $Collect                = [ PSCustomObject ]@{

            State               = '[X]' , 'Disabled' , 'Manual' , 'Auto' , 'Auto (DS)'
            Service             = $Configuration.Service
            Profile             = $Configuration.Profile
            Types               = Resolve-ViperBomb -Types | % { $_.Types }

        }

        If ( $Default )
        {
            $Collect            | % {

                $Return         = ForEach ( $i in 0..( $_.Service.Count - 1 ) )
                {
                    $Split          = $_.Profile[$i].Split(',')

                    [ PSCustomObject ]@{

                        Service     = $_.Service[$I]
                        "10H:D+"    = $_.State[$Split[0]]
                        "10H:D-"    = $_.State[$Split[1]]
                        "10P:D+"    = $_.State[$Split[2]]
                        "10P:D-"    = $_.State[$Split[3]]
                        "DT:S+"     = $_.State[$Split[4]]
                        "DT:S-"     = $_.State[$Split[5]]
                        "DT:T+"     = $_.State[$Split[6]]
                        "DT:T-"     = $_.State[$Split[7]]
                        "LT:S+"     = $_.State[$Split[8]]
                        "LT:S-"     = $_.State[$Split[9]]
                    }
                }
            }

            $Return
        }

        If ( $Load )
        {
            $Scale           = @{  
            
                Base         = Resolve-ViperBomb -Path    | % { "$( $_.Parent        )\Services" }
                File         = Resolve-ViperBomb -Control | % { "$( $_.ServiceConfig ).csv"      }
        
            } | % { IPCSV ( "{0}\{1}" -f $_.Base , $_.File ) } | % { 
            
                IPCSV $_ | % {
                
                    [ PSCustomObject ]@{ 
                    
                        Service  = $_.Service
                        "10H:D+" = $X[$_."10H:D+"]
                        "10H:D-" = $X[$_."10H:D-"]
                        "10P:D+" = $X[$_."10P:D+"]
                        "10P:D-" = $X[$_."10P:D-"]
                        "DT:S+"  = $X[$_."DT:S+"]
                        "DT:S-"  = $X[$_."DT:S-"]
                        "DT:T+"  = $X[$_."DT:T+"]
                        "DT:T-"  = $X[$_."DT:T-"]
                        "LT:S+"  = $X[$_."LT:S+"]
                        "LT:S-"  = $X[$_."LT:S-"]
                    }
                }
            }
        }

        If ( $Custom )
        {
            $Custom = Read-Host "Enter full path to custom service configuration"
            
            If ( ! ( Test-Path $Custom ) )
            {
                Write-Theme -Action "Exception [!]" "Path not a valid file."
            }

            If ( $Custom.Split('.')[-1] -ne ".csv" )
            {
                Write-Theme -Action "Exception [!]" "File not in a valid .csv format"
            }
        }                                                                           #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function New-ServiceTemplate #______________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param (

            [ ValidateNotNullOrEmpty () ]
            [ Parameter ( ParameterSetname = "Object" ) ] [ String [] ] $Names )

        
        $Return = [ PSCustomObject ]@{ }

        $Names | % { $Return | Add-Member -MemberType NoteProperty -Name $_ -Value "-" }

        $Return                                                                     #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____ 
}
