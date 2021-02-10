Function Get-FEImage
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Source)

    If ( ! ( Test-Path $Source ) )
    {
        Throw "Invalid path"
    }

    Else
    {
        Get-ChildItem -Path $Source -Recurse -Filter *.wim | % FullName
    }
}
