Function Get-FEHive
{
    [CmdLetBinding()]Param(
    [Parameter(Mandatory)][String]$Type,
    [Parameter(Mandatory)][String]$Version)
    
    If ( $Type -notin "Win32_Client","Win32_Server","RHELCentOS","UnixBSD" )
    {
        Throw "Invalid type"
    }

    [_Hive]::new($Type,$Version)
}
