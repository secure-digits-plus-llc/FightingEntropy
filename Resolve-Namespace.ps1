
Function Resolve-Namespace
{
<#
.Synopsis
   Resolves namespaces

.DESCRIPTION
   Can load single or multiple namespaces

.EXAMPLE [ Single ]
   Resolve-Namespace -Namespace System.Management.Automation
   
   Using Namespace

    System .............................................................................................. [+] Successful

.EXAMPLE [ Multiple ]
   Resolve-Namespace "System System.Collections.Generic System.Linq System.Threading.Tasks".Split(' ')

   Using Namespace

    System .............................................................................................. [+] Successful
    System.Collections.Generic .......................................................................... [+] Successful
    System.Linq ......................................................................................... [+] Successful
    System.Threading.Tasks .............................................................................. [+] Successful
#>
            [ CmdLetBinding () ][ OutputType ("String") ] Param (
            
                [ Parameter ( Mandatory , Position = 0 , ValueFromPipeline = $True , HelpMessage = "Name of namespace" ) ][ String [] ] $Namespace )
               
            "`nUsing Namespace`n"

            $Namespace               | % {                # :Loop

                $Tee                 = 0..2
                $Tee[0]              = "    $_ ..."       #  Echo

                IEX ( "Using Namespace $_" ) -VB          #  Initialize 
                    
                $Tee[2]              = @{  
                        
                    $True            = " [+] Successful"  #  Success Flag
                    $False           = " [!] Exception"   #  Failure Flag
                    
                }[ $? ]
                    
                $Tee[1]              =  120 - ( $Tee[0] + $Tee[2] ).Length | % { "." * $_ }

                $Tee[0..2] -join ''
            }
}
