    
    $url = ''

    $chocolateyVersion = $env:chocolateyVersion

    If ( ! [ String ]::IsNullOrEmpty( $chocolateyVersion ) )
    {
        Echo "Downloading specific version of Chocolatey: $chocolateyVersion"
        $url = "https://chocolatey.org/api/v2/package/chocolatey/$chocolateyVersion"
    }

    $chocolateyDownloadUrl = $env:chocolateyDownloadUrl

    If ( ! [ String ]::IsNullOrEmpty( $chocolateyDownloadUrl ) )
    {
        Echo "Downloading Chocolatey from : $chocolateyDownloadUrl"
        $url = "$chocolateyDownloadUrl"
    }

    If ( $env:TEMP -eq $null )
    {
        $env:TEMP    = "$env:SystemDrive\temp"
    }

        $chocTempDir = "$env:TEMP\chocolatey"
        $tempDir     = "$chocTempDir\chocInstall"

    If ( ! [ System.IO.Directory ]::Exists( $tempDir ) ) 
    {
        [ Void ][ System.IO.Directory ]::CreateDirectory( $tempDir )
    }

    $File        = "$tempDir\chocolatey.zip"

    If ( $PSVersionTable.PSVersion.Major -lt 4 )
    {
        Try
        {
            # http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments

            $mainBind     = "Field" , "Property" | % {  [ Reflection.BindingFlags ] "Instance,NonPublic,Get$_" }

            $objectRef    =      $host.GetType().GetField( "externalHostRef" , $mainBind[0] ).GetValue( $host )
      
            $consoleHost  = $objectRef.GetType().GetProperty( "Value" , $mainbind[1] ).GetValue( $objectRef , @() )
      
            [ Void ] $consoleHost.GetType().GetProperty( "IsStandardOutputRedirected" , $mainBind[1] ).GetValue( $consoleHost , @() )
      
            #$bindingFlags = [ Reflection.BindingFlags ] "Instance,NonPublic,GetField"
      
            $field        = $consoleHost.GetType().GetField( "standardOutputWriter" , $mainBind[0] )
      
            $field.SetValue( $consoleHost , [ Console ]::Out )

            [ Void ] $consoleHost.GetType().GetProperty( "IsStandardErrorRedirected" , $mainBind[0] ).GetValue( $consoleHost , @() )
      
            $field2       = $consoleHost.GetType().GetField( "standardErrorWriter" , $mainBind[0] )
      
            $field2.SetValue( $consoleHost , [ Console ]::Error )
        } 
        
        Catch 
        {
            Echo "Unable to apply redirection fix."
        }
    }



    Try 
    {
        [ System.Net.ServicePointManager ]::SecurityProtocol = 3072
    } 
    
    Catch 
    {
        Write-Output ( "Unable to set PowerShell to use TLS 1.2 and TLS 1.1 due to old .NET Framework installed." ,
        "If you see underlying connection closed or trust errors, you may need to do one or more of the following:" , 
        "(1) Upgrade to .NET Framework 4.5+ and PowerShell v3," , 
        "(2) Specify internal Chocolatey package location (set $env:chocolateyDownloadUrl prior to install or host the package internally)," , 
        "(3) Use the Download + PowerShell method of install. See https://chocolatey.org/install for all install options." -join "`n" )
    }

    Function Get-Downloader 
    {
        Param ( [ String ] $url )

        $Obj                                                 = @{ 

            Downloader                                       = [ System.Net.WebClient ]::New() 
        }
        
        [ System.Net.CredentialCache ]::DefaultCredentials   | % { 

            If ( $_ -ne $Null )
            {
                $Obj.Downloader.Credentials                  = $_
            }
        }

        $env:chocolateyIgnoreProxy                           | % { 

            If ( $_ -ne $Null -and $_ -eq $True )
            {
                Write-Debug "Explicitly bypassing proxy due to user environment variable"

                $Obj.Downloader.Proxy                        = [ System.Net.GlobalProxySelection ]::GetEmptyWebProxy()
            }
        }
        
        $env:chocolateyProxyLocation                         | % {

            If ( $_ -ne $Null -or $_ -ne '' )
            {   
                $Obj.Downloader.Proxy                        = New-Object System.Net.WebProxy( $_ , $true )
                
                Write-Debug "Using explicit proxy server '$_'."
                
                $Credential                                  = [ PSCustomObject ]@{ Username = $Null ; Password = $Null }
            }
        }
        
        If ( $Credential )
        {
            $env:chocolateyProxyUser                         | % { 

                If ( $_ -ne $Null -or $_ -ne '' )
                {
                    $Credential.Username                     = $_
                }
            }
                
            $env:chocolateyProxyPassword                     | % { 
                
                If ( $_ -ne $Null -or $_ -ne '' )
                {
                    $Credential.Password                     = ConvertTo-SecureString $_ -AsPlainText -Force
                }
            }

            $Credential                                      | % {
            
                If ( $_.Username -and $_.Password -ne $Null )
                {
                    $Obj.Downloader.Proxy.Credentials        = [ System.Management.Automation.PSCredential ]::New( $_.UserName , $_.Password )
                }
            }

            $Credential                                      = $Null
        }
        
        $Obj.Downloader.Proxy                                | % { 

            If ( !$_.IsBypassed( $url ) )
            {   
                If ( $_.Credentials -eq $null )
                {
                    Write-Debug "Default credentials were null. Attempting backup method"

                    $_.Credentials                           = Get-Credential | % { $_.GetNetworkCredential() }
                }
            }
            
            $_.GetProxy( $url ).Authority                    | % { 

                Write-Debug "Using system proxy server '$_'."
            
                $Obj.Downloader.Proxy                        = New-Object System.Net.WebProxy( $_ )
            }
        }

        Return $Obj.Downloader
    }

    Function Download-String 
    {
        Param ( [ String ] $url )
        
        $downloader                                          = Get-Downloader $url

        Return $downloader.DownloadString( $url )
    }

    Function Download-File 
    {
        Param ( [ String ] $url , [ String ] $file )
        
        #Write-Output "Downloading $url to $file"
        $downloader                                          = Get-Downloader $url

        $downloader.DownloadFile( $url , $file )
    }

    If ( $url -eq $null -or $url -eq '' )
    {
        
        Write-Output "Getting latest version of the Chocolatey package for download."
        
        $url = 'https://chocolatey.org/api/v2/Packages()?$filter=((Id%20eq%20%27chocolatey%27)%20and%20(not%20IsPrerelease))%20and%20IsLatestVersion'
        
        [ Xml ] $Result                                     = Download-String $url
        
        $url                                                = $Result.feed.entry.content.src
    }

    Write-Output "Getting Chocolatey from $url."
    Download-File $url $file

    # Determine unzipping method
    # 7zip is the most compatible so use it by default

    $7zaExe      = "$tempDir\7za.exe"

    $unzipMethod = '7zip'
    $useWindowsCompression = $env:chocolateyUseWindowsCompression
    
    If ( $useWindowsCompression -ne $null -and $useWindowsCompression -eq 'true' )
    {
        Write-Output 'Using built-in compression to unzip'
        $unzipMethod = 'builtin'
    } 
    
    ElseIf ( -Not ( Test-Path ( $7zaExe ) ) )
    {
        Write-Output "Downloading 7-Zip commandline tool prior to extraction."
        
        # download 7zip
        Download-File 'https://chocolatey.org/7za.exe' "$7zaExe"
    }

    # unzip the package
    Write-Output "Extracting $file to $tempDir..."

    If ( $unzipMethod -eq '7zip' )
    {
        $params                                 = "x -o`"$tempDir`" -bd -y `"$file`""

        # use more robust Process as compared to Start-Process -Wait (which doesn't
        # wait for the process to finish in PowerShell v3)

        $process                                = New-Object System.Diagnostics.Process

        $process                                | % { 
        
            $_.StartInfo                        = New-Object System.Diagnostics.ProcessStartInfo( $7zaExe , $params )
            $_.StartInfo.RedirectStandardOutput = $true
            $_.StartInfo.UseShellExecute        = $false
            $_.StartInfo.WindowStyle            = [ System.Diagnostics.ProcessWindowStyle ]::Hidden
            $_.Start()                          | Out-Null
            $_.BeginOutputReadLine()
            $_.WaitForExit()
            $exitCode                           = $_.ExitCode
            $_.Dispose()
        }

        If ( $exitcode -eq 0 ) { Break }
        Else 
        { 
            If ( $exitcode -notin 1..255 ) { $exitcode = 254 }
            Throw ( "Unable to unzip package using 7-zip. Perhaps try setting","$env:chocolateyUseWindowsCompression = 'true' and call install again. Error:", 
            ( "--,Some files could not be extracted,7-Zip encountered a fatal error while extracting the files,--,--,--,--,7-Zip command line error," +
            "7-Zip out of memory,$( "--," * 246 )Extraction cancelled by the user" ).Split( ',' )[ $exitcode ].Replace( '--' , 
            "7-Zip signalled an unknown error (code $exitCode)" ) -join "`n" )
        }
    }

    Else 
    {
        If ( $PSVersionTable.PSVersion.Major -lt 5 )
        {
            Try 
            {
                $shellApplication  = New-Object -COM Shell.Application
                
                $zipPackage        = $shellApplication.NameSpace( $file    )
                
                $destinationFolder = $shellApplication.NameSpace( $tempDir )

                $destinationFolder.CopyHere( $zipPackage.Items() , 0x10 )
            }
            
            Catch 
            {
                Throw ( "Unable to unzip package using built-in compression. Set" , 
                "$env:chocolateyUseWindowsCompression = 'false' and call install again to use 7zip to unzip. Error:" , 
                "$_" -join "`n" )
            }

        }
        
        Else 
        {
            Expand-Archive -Path "$file" -DestinationPath "$tempDir" -Force
        }
    }

    # Call chocolatey install

    Write-Output "Installing chocolatey on this machine"

    $toolsFolder             = "$tempDir\tools"
    $chocInstallPS1          = "$toolsFolder\chocolateyInstall.ps1"

    & $chocInstallPS1

    Write-Output 'Ensuring chocolatey commands are on the path'

    $chocInstallVariableName = "ChocolateyInstall"
    $chocoPath               = [ Environment ]::GetEnvironmentVariable( $chocInstallVariableName )

    If ( $chocoPath -eq $null -or $chocoPath -eq '' )
    {
        $chocoPath           = "$env:ALLUSERSPROFILE\Chocolatey"
    }

    If ( ! ( Test-Path ( $chocoPath ) ) )
    {
        $chocoPath           = "$env:SYSTEMDRIVE\ProgramData\Chocolatey"
    }

    $chocoExePath            = "$chocoPath\bin"

    If ( $( $env:Path ).ToLower().Contains( $( $chocoExePath ).ToLower() ) -eq $false ) 
    {
        $env:Path            = [ Environment ]::GetEnvironmentVariable( 'Path' , [ System.EnvironmentVariableTarget ]::Machine );
    }

    Write-Output 'Ensuring chocolatey.nupkg is in the lib folder'

    $chocoPkgDir             = "$chocoPath\lib\chocolatey"
    $nupkg                   = "$chocoPkgDir\chocolatey.nupkg"
    
    If ( ! [ System.IO.Directory ]::Exists( $chocoPkgDir ) )
    { 
        [ System.IO.Directory ]::CreateDirectory( $chocoPkgDir )
    }

    Copy-Item "$file" "$nupkg" -Force -ErrorAction SilentlyContinue
