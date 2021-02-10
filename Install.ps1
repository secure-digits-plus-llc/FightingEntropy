Function Install-FEModule
{
    [CmdLetBinding()]
    Param(
    
    [ValidateSet("2021.1.0","2021.1.1","2021.2.0")]
    [Parameter(Mandatory)]
    [String]$Version)

    $Install = @( )
    
    ForEach ( $Item in "OS Root Manifest RestObject Hive Install" -Split " " )
    {
        $Install += Invoke-RestMethod https://github.com/secure-digits-plus-llc/FightingEntropy/blob/master/$Version/Classes/_$Item.ps1?raw=true
    }
    
    Invoke-Expression ( $Install -join "`n" )
    
    [_Install]::New($Version)
}

$Install = Install-FEModule -Version 2021.2.0
