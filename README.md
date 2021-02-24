# An ode to the Microsoft Deployment Toolkit...

    Once upon a time, there were a bunch of experts sitting at a table,
    talking among themselves as to what awesome thing they were likely
    to (build/do) next.

    Then, a voice from the crowd of these like minded geniuses emerged… 
    “What if we make a tool that can automatically install Windows? Like,
    over the network?”

    Ever since that day...? <br>
    Well, the world’s best software engineers put their heads together...
    ...and made a series of service and software suites…
    (Windows Deployment Services/WDS):
    - When you need an (image file/ISO), and no funny business.
    (Microsoft Deployment Toolkit/MDT):
    - When you need to be seen as an adult, not a child.
    (System Center Configuration Manager/SCCM):
    - The end all, be all... of system configurations. 
    (Windows Assessment and Deployment Kit/WinADK):
    - When you feel like whittling away at the build process.
    (Windows Preinstallation Environment/WinPE):
    - When all else fails, this is the last line of defense.

    Now, there are various other names and pieces of software that COULD go
    along with this process... there’s Hyper-V, Internet Information Services,
    Background Intelligent Transfer Service, but in the end, everything ties
    right back to… The Microsoft Deployment Toolkit.
    
    These geniuses, assembled a toolkit like no other.
    With it, you can install Windows like a pro. 
    There used to be a day and age where people had a hard time
    transferring all of their stuff around.
    
    Not anymore. 
    With the Microsoft Deployment Toolkit, and Active Directory Domain Services…? 
    You can really show people who the boss is, and keep it moving and flowing nicely. 

    Some people might even stop and ask you,
    “Hey, how do you keep things moving so smoothly like that…?”
    Your response will be... *pull your shades down slightly*
    “I simply learned from the best…”

# About FightingEntropy
FightingEntropy is a PowerShell modification for:
- Microsoft Deployment Toolkit
- Windows Assessment and Deployment Kit
- Windows Preinstallation Environment
- IIS/BITS/ASP.Net Framework
- Image Factory derivative
- DSC for Active Directory, DNS, DHCP, WDS
- Endpoint Service Configuration (ViperBomb)
- Endpoint branding
- Automation and installation of these tasks

This tool is still in deep development
In it's current state, the module is broken down into several classes and functions. 
If you would like to install/test/use it...

# Install [2021.2.0]

    Invoke-Expression ( Invoke-RestMethod https://github.com/secure-digits-plus-llc/FightingEntropy/blob/master/Install.ps1?raw=true )

