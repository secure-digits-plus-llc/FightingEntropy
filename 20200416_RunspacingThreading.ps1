#[¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯]
#[ [1] https://thesurlyadmin.com/2013/02/11/multithreading-powershell-scripts          ]
#[_____________________________________________________________________________________]

# 1: Jobs
Do { Start-Sleep -Seconds 1 } Until ( @( Get-Job ).Count -le 5 )

# 2: Runspace Pool
$MaxThreads   = 5
$RunspacePool = [ RunspaceFactory ]::CreateRunspacePool(1, $MaxThreads)
$RunspacePool.Open()

# 3: Script Block
$ScriptBlock = { 
    
    Param ( [ Int ] $RunNumber )

    $RanNumber = Get-Random -Minimum 1 -Maximum 10
    Start-Sleep -Seconds $RanNumber
    $RunResult = New-Object PSObject -Property @{
       RunNumber = $RunNumber
       Sleep = $RanNumber
    }
    Return $RunResult
 }

# 4: Process
 $Jobs = @()
 $Job = [powershell ]::Create().AddScript( $ScriptBlock ).AddArgument( $argument1 )
 $Job.RunspacePool = $RunspacePool
 $Jobs += New-Object PSObject -Property @{
    Pipe = $Job
    Result = $Job.BeginInvoke()
 }

# 5: End Condition
 Write-Host "Waiting.." -NoNewline
Do {
   Write-Host "." -NoNewline
   Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false )
Write-Host "All jobs completed!"

# 6: Results
$Results = @()
ForEach ($Job in $Jobs )
{   $Results += $Job.Pipe.EndInvoke($Job.Result)
}

# ----------------------------------------------------------

[ System.Console ]::Clear()

" .Collections.Generic .Linq .Text .Console" -Split " " | % { 
    
    "Using Namespace System{0}" -f $_ | % { 
        
        $_ 
        IEX $_ 
    }
}

Class RSObject
{
#   Param (Id,Name,Width,Depth,Range,Script) 
#   [ RSObject ]@{          # [ Runspace Object Parameters/Properties ]

    [      Int ]        $Id #        Id |           Param (Index)
    [   String ]      $Name #      Name |           Param (Name)
    [      Int ]     $Width #     Width |           Param (x/Width)
    [      Int ]     $Depth #     Depth |           Param (y/Depth)
    [   Int [] ]     $Range #     Range |           Param (z/Range)
    [    Array ]      $Code #      Code |           Param (Script Array)

    RSDepth ( [ Int ] $Depth, [ Int ] $Range ) # Collects Optimal Thread Depth 
    {
        GCIM Win32_Processor -Property * 
        GCIM Win32_Processor -Property "ThreadCount" , "CpuStatus", "LoadPercentage"
        {
            @{  
                ClassName = "Win32_Processor" 
                Property  =               $I 
            
            }             | % { GCIM @_ } 
        }

            $Throttle =            $Depth
    }

    RSRange ( )
    {

    }

    RSJobs ( )
    {

    }

    RSPool ( [Int] $Throttle , [Int[]] $Range )
    {
        $This.Throttle   = $Throttle
        $This.Factory    = [ RunspaceFactory ]::CreateRunspacePool( 1 , $This.Throttle )
        $This.Factory.ApartmentState = "MTA"
        $This.Factory.Open()

        $This.Index      = $Range | Select -First 1
        $This.Total      = $Range | Select -Last  1
        $This.Range      = $Range

        [ System.Console ]::WriteLine( "Runspace {0} Opened" -f $This.Factory.ThreadOptions )
    }

    RSThread ( [ PSObject ] $RSPool , [Int] $Index )
    {
        [Int] $Throttle , [PSObject] $Thread, [Int] $Index
        
        # Method with two values for input
        RSThread ( [ Int ] $Index )
        {
            ( [ String ] $ScriptBlock , [ String ] $Argument )

            $Job              = [ PowerShell ]::Create().AddScript( $ScriptBlock ).AddArgument( $Argument )
            $Job.RunspacePool = & $Script.Runspace $Throttle
            $Jobs            += @{ Pipe = $Job ; Result = $Job.BeginInvoke() }
        }
    }

    RSScriptBlock ( [ Int ] $Index )
    {    
        @{  RunNumber   = $Index
            Sleep       = Get-Random ( 0..10 ) } | % { Start-Sleep -S @_ }
    }

    RSObject ()
    {
        [ ]
    }
}


    Class RSPool
    {
        [ PSObject ]  $Factory
        [ Int ]      $Throttle
        [ Int ]         $Total
        [ Int []]       $Range
        [ Array ]        $Jobs

        RSPool ( [ Int ] $Throttle , [ Int [] ] $Range )
        {
            $This.Factory = [ RunspaceFactory ]::CreateRunspacePool( 1 , $Throttle )
            $This.Factory.
                
                ApartmentState( "MTA" ).
                Open();
            
            $This.Index   = $Range[0]
            $This.Total   = $Range[-1]
            $This.Range   = $Range
            
            [ System.Console ]::WriteLine( "Runspace {0} Opened" -f $This.Factory.ThreadOptions )
        }
    }

    Class RSThread
    {
        [PSObject] $Pool
        [PSObject] $Thread
             [Int] $Index
           [Int[]] $Range
             [Int] $Start 
             [Int] $End
        
        # Method with two values for input 
        Thread ( [Int] $Index, [Int[]] $Range )
        {
            $This.Thread

        }
    }

    ScriptBlock ( [ Int ] $Index )
    {    
        @{  RunNumber   = $Index
            Sleep       = Get-Random ( 0..10 ) } | % { Start-Sleep -S @_ }
    }

    Argument ( [ String ] $Argument )
    {
        "{0}" -f $Argument
    }

    Process ( [ String ] $ScriptBlock , [ String ] $Argument )
    {
        $Job              = [ PowerShell ]::Create().AddScript( $ScriptBlock ).AddArgument( $Argument )
        $Job.RunspacePool = & $Script.Runspace $Throttle
        $Jobs            += @{ Pipe = $Job ; Result = $Job.BeginInvoke() }
    }
}


    & $Script.Collect

    1..20 | % { 

        & $Script
    }
 
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Throttle)
$RunspacePool.Open()
$Jobs = @()
 
1..20 | % {
   #Start-Sleep -Seconds 1
   $Job = [powershell]::Create().AddScript($ScriptBlock).AddArgument($_)
   $Job.RunspacePool = $RunspacePool
   $Jobs += New-Object PSObject -Property @{
      RunNum = $_
      Pipe = $Job
      Result = $Job.BeginInvoke()
   }
}

Write-Host "Waiting.." -NoNewline
Do {
   Write-Host "." -NoNewline
   Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false)
Write-Host "All jobs completed!"
 
$Results = @()
ForEach ($Job in $Jobs)
{   $Results += $Job.Pipe.EndInvoke($Job.Result)
}

$Results | Out-GridView





$Jobs       = @( Get-Job )
$MaxThreads = 5
$Run        = 0

$Scripts    = [ PSCustomObject ]@{ 
    
    ":Jobs" = { 
    
        While ( $Jobs.Count -le 5 )
        {
            Start-Sleep -Seconds 1
            $Jobs += @( Get-Job )
        }
    }

    ":Runspace" = {

        $Runspace = [ RunspaceFactory ]::CreateRunspacePool( 1 , $MaxThreads )
        $Runspace.Open()
    }

    ":Count" = {

        Param ( [ Int ] $Run )
        
        $This.RunNumber = $Run
        $This.Sleep     = Get-Random -Minimum 1 -Maximum 10
        Start-Sleep -Seconds $This.Sleep
        $This
    }

    ":ProcessJobs" = {
    
        $Jobs = @()
        $Job = [ PowerShell ]::Create().AddScript( $ScriptBlock. ).AddArgument( $argument1 )
        $Job.RunspacePool = $RunspacePool
        $Jobs += New-Object PSObject -Property @{ Pipe = $Job ; Result = $Job.BeginInvoke() }
    }
}





$ScriptBlock = 
 
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Throttle)
$RunspacePool.Open()
$Jobs = @()
 
1..20 | % {
   #Start-Sleep -Seconds 1
   $Job = [powershell]::Create().AddScript($ScriptBlock).AddArgument($_)
   $Job.RunspacePool = $RunspacePool
   $Jobs += New-Object PSObject -Property @{
      RunNum = $_
      Pipe = $Job
      Result = $Job.BeginInvoke()
   }
}

Write-Host "Waiting.." -NoNewline
Do {
   Write-Host "." -NoNewline
   Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false)
Write-Host "All jobs completed!"
 
$Results = @()
ForEach ($Job in $Jobs)
{   $Results += $Job.Pipe.EndInvoke($Job.Result)
}

$Results | Out-GridView

