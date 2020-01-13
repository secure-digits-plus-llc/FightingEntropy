    # https://devblogs.microsoft.com/scripting/use-powershell-to-manipulate-information-with-cim/
    $Time = [ System.Diagnostics.Stopwatch ]::StartNew()

    $ClassList = Get-CimClass;

    $Return = Foreach ( $CimClass in $ClassList )
    {
        Foreach ( $CimProperty in $CimClass.CimClassProperties )
        {
            If ( $CimProperty.Qualifiers.Name -contains 'write' )
            {
                [ PSCustomObject ]@{

                    ClassName    = $CimClass.CimClassName
                    PropertyName = $CimProperty.Name
                    Writable     = $true

                }
            }
        }
    }

    $Time.Stop()

    Write-Output "Complete [+] Time: $( $Time.Elapsed )"
    
    # What I rewrote, reducing variables and time (tried to go completely with the $X but, couldn't do it.

    $Time = [ System.Diagnostics.Stopwatch ]::StartNew()

    $Report                   = Get-CimClass | ? { $_.CimClassProperties.Qualifiers.Name -contains 'write' } | % { 

        $X                    = $_.CimClassName

        $_.CimClassProperties | ? { $_.Qualifiers.Name -contains 'write' } | % {

            [ PSCustomObject ]@{ 

                ClassName     = $X
                PropertyName  = $_
                Writeable     = $True
            } 
        }
    }

    $Time.Stop()

    Write-Output "Complete [+] Time: $( $Time.Elapsed )"
