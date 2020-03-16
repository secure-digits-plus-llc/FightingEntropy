$Ret                         = "HKLM:/Software/Policies/Secure Digits Plus LLC" | % { 

            If ( ( Test-Path $_ ) -eq $Null )
            {
                "Item not found."
            }
            
            Else
            {
                [ PSCustomObject ]@{ 


                    PSPath               =                   $_
                    Path                 =             (  GI $_ ).Name
                    Parent               =  Split-Path (  GI $_ ) -Parent
                    PSChildName          =  Split-Path (  GI $_ ) -Leaf 
                    ChildItems           =             ( GCI $_ ) #| ? { $_.Name -match "Secure Digits*" } 
                    
                    Properties           =                GP $_ | % {  

                        [ PSCustomObject ]@{ 
                            
                            Date     = $_.Date
                            Module   = $_."Hybrid-DSC"
                            Version  = If ( $_.Version -eq $Null ) { "2020.03.20" } Else { $_.Version }
                            Install  = $_."Installation Date"
                        }
                    }
                }
            }
        }
