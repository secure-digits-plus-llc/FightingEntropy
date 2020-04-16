#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\____  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                                    // 
#//¯¯¯                                                                                                                                               \\ 
#\\  [ Use-ViperBombServices ] @: Services & Group Policy Template Generator [ Modified version of "MadBomb122" & Charles Spark's scripts ]          // 
#//   ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____   \\ 
#\\__/----\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//==\\__/---\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//==\\__// 
#//¯¯\\___________________________________________________________________________________¯¯¯¯ -- ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___ __ ____ -- ____ __ ____ -- ____ __ ____ -- ____ __ ___// 
# ¯¯¯\\__[ Initial Script Prerequisite Declarations ]____________________________________//¯¯\----/¯¯\\==//¯¯\----/¯¯\\==//¯¯\----/¯¯\\==//¯¯\----/¯¯¯  
#     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯      
#
#    [2020/03/05]
#
#       Foreword: This script/program has been extensively modified/completely revamped.
#
#       The GUI in this version was originally developed by MadBomb122. His program is originally based on Black Viper's service configurations @
#
#       www.blackviper.com
#
#       Other details are in the readme and links are provided in the GUI.
#
#       I redesigned it and began to implement various changes that could add a consistent and scalable update system for [HybridDSC/FightingEntropy].
#
#       Fork Revisions/Updates include: 
#
#           - All necessary files are included within this single PowerShell script and module.
#
#           - No external files are necessary for it's use. 
#
#           - Heavily modified Service Profile loading , filtering, and sorting.
#
#           - XAML based GUI has been through a complete redesign
#
#           - MadBomb122 has a real name and in respect to him, I have chosen to leave that information outside of this script.
#               I have collaborated with MadBomb122 over the course of the last 6-7 months, tentatively, in helping to teach him some refinement
#               techniques on my journey to advance my Application Development experience.
#
#               The desired end result of working with this script, is to easily implement government grade STIG templates for end users, which 
#               you can find some of those technical details/documents here -> @ https://github.com/nsacyber/Windows-Secure-Host-Baseline
#              
#               - MCC / SDP
#   _________________________
#   [ Original Script & GUI ] -> I will be adding an option that enables the use of his legacy script
#   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
#       Author: Madbomb122
#      Website: https://GitHub.com/Madbomb122/BlackViperScript/
#   _________________________
#   [ Service Configuration ] -> I will be adding additional service configuration types for Windows Server 20(08/12/16/19) (eventually)
#   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
#       Author: Charles "Black Viper" Sparks
#      Website: http://www.BlackViper.com/                                          #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
# ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Resolve-ViperBomb # Provides ViperBomb Script Definitions _________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param (

            [ Parameter ( ParameterSetName =    "Version" ) ] [ Switch ] $Version   ,
            [ Parameter ( ParameterSetName =     "Update" ) ] [ Switch ] $Company   ,
            [ Parameter ( ParameterSetName =    "MadBomb" ) ] [ Switch ] $MadBomb   ,
            [ Parameter ( ParameterSetName =     "Sparks" ) ] [ Switch ] $Sparks    ,
            [ Parameter ( ParameterSetName =       "Path" ) ] [ Switch ] $Path      ,
            [ Parameter ( ParameterSetName =    "Control" ) ] [ Switch ] $Control   ,
            [ Parameter ( ParameterSetName =  "Copyright" ) ] [ Switch ] $Copyright ,
            [ Parameter ( ParameterSetName =    "Message" ) ] [ Switch ] $Message   ,
            [ Parameter ( ParameterSetName =       "Help" ) ] [ Switch ] $Help      ,
            [ Parameter ( ParameterSetName =   "Services" ) ] [ Switch ] $Services  ,
            [ Parameter ( ParameterSetName =      "Names" ) ] [ Switch ] $Names     ,
            [ Parameter ( ParameterSetName =      "Types" ) ] [ Switch ] $Types     ,
            [ Parameter ( ParameterSetName =     "Config" ) ] [ Switch ] $Config    ,
            [ Parameter ( ParameterSetName =        "All" ) ] [ Switch ] $All       )

        $Default                 = [ PSCustomObject ]@{

            PassedArgs           = If ( ! $Args ) { "N/A" } Else { $Args }
            TermsOfService       = 0
            DisplayActive        = 1
            DisplayInactive      = 1
            DisplaySkipped       = 1
            MiscSimulate         = 0
            MiscXbox             = 1
            MiscChange           = 0
            MiscStopDisabled     = 0
            DevelDiagErrors      = 0
            DevelLog             = 0
            DevelConsole         = 0
            DevelDiagReport      = 0
            BypassBuild          = 0
            BypassEdition        = 0
            BypassLaptop         = 0
            LoggingServiceFile   = "Service.log"
            LoggingScriptFile    = "Script.log"
            BackupRegistryFile   = "Backup.reg"
            BackupTemplateFile   = "Backup.csv"
            ServiceConfig        = "Black Viper (Sparks v1.0)"
            ScriptConfig         = "DevOPS (MC/SDP v1.0)"
            Profile              = $Null

        }

        $QMark                   = Get-CurrentPID 

        $ServiceConfig           = [ PSCustomObject ]@{  
 
            Names                = ("AJRouter;ALG;AppHostSvc;AppIDSvc;Appinfo;AppMgmt;AppReadiness;AppVClient;aspnet_state;AssignedAccessManagerSvc;" + 
                                   "AudioEndpointBuilder;AudioSrv;AxInstSV;BcastDVRUserService_$QMARK;BDESVC;BFE;BITS;BluetoothUserService_$QMARK;Br" + 
                                   "owser;BTAGService;BthAvctpSvc;BthHFSrv;bthserv;c2wts;camsvc;CaptureService_$QMARK;CDPSvc;CDPUserSvc_$QMARK;CertP" + 
                                   "ropSvc;COMSysApp;CryptSvc;CscService;defragsvc;DeviceAssociationService;DeviceInstall;DevicePickerUserSvc_$QMARK" + 
                                   ";DevQueryBroker;Dhcp;diagnosticshub.standardcollector.service;diagsvc;DiagTrack;DmEnrollmentSvc;dmwappushsvc;Dns" + 
                                   "cache;DoSvc;dot3svc;DPS;DsmSVC;DsRoleSvc;DsSvc;DusmSvc;EapHost;EFS;embeddedmode;EventLog;EventSystem;Fax;fdPHost" + 
                                   ";FDResPub;fhsvc;FontCache;FontCache3.0.0.0;FrameServer;ftpsvc;GraphicsPerfSvc;hidserv;hns;HomeGroupListener;Home" + 
                                   "GroupProvider;HvHost;icssvc;IKEEXT;InstallService;iphlpsvc;IpxlatCfgSvc;irmon;KeyIso;KtmRm;LanmanServer;LanmanWo" + 
                                   "rkstation;lfsvc;LicenseManager;lltdsvc;lmhosts;LPDSVC;LxssManager;MapsBroker;MessagingService_$QMARK;MSDTC;MSiSC" + 
                                   "SI;MsKeyboardFilter;MSMQ;MSMQTriggers;NaturalAuthentication;NcaSVC;NcbService;NcdAutoSetup;Netlogon;Netman;NetMs" + 
                                   "mqActivator;NetPipeActivator;netprofm;NetSetupSvc;NetTcpActivator;NetTcpPortSharing;NlaSvc;nsi;OneSyncSvc_$QMARK" + 
                                   ";p2pimsvc;p2psvc;PcaSvc;PeerDistSvc;PerfHost;PhoneSvc;pla;PlugPlay;PNRPAutoReg;PNRPsvc;PolicyAgent;Power;PrintN" + 
                                   "otify;PrintWorkflowUserSvc_$QMARK;ProfSvc;PushToInstall;QWAVE;RasAuto;RasMan;RemoteAccess;RemoteRegistry;RetailD" + 
                                   "emo;RmSvc;RpcLocator;SamSs;SCardSvr;ScDeviceEnum;SCPolicySvc;SDRSVC;seclogon;SEMgrSvc;SENS;Sense;SensorDataServi" + 
                                   "ce;SensorService;SensrSvc;SessionEnv;SgrmBroker;SharedAccess;SharedRealitySvc;ShellHWDetection;shpamsvc;smphost;" + 
                                   "SmsRouter;SNMPTRAP;spectrum;Spooler;SSDPSRV;ssh-agent;SstpSvc;StiSvc;StorSvc;svsvc;swprv;SysMain;TabletInputServ" + 
                                   "ice;TapiSrv;TermService;Themes;TieringEngineService;TimeBroker;TokenBroker;TrkWks;TrustedInstaller;tzautoupdate;" + 
                                   "UevAgentService;UI0Detect;UmRdpService;upnphost;UserManager;UsoSvc;VaultSvc;vds;vmcompute;vmicguestinterface;vmi" + 
                                   "cheartbeat;vmickvpexchange;vmicrdv;vmicshutdown;vmictimesync;vmicvmsession;vmicvss;vmms;VSS;W32Time;W3LOGSVC;W3S" + 
                                   "VC;WaaSMedicSvc;WalletService;WarpJITSvc;WAS;wbengine;WbioSrvc;Wcmsvc;wcncsvc;WdiServiceHost;WdiSystemHost;WebCl" + 
                                   "ient;Wecsvc;WEPHOSTSVC;wercplsupport;WerSvc;WFDSConSvc;WiaRpc;WinHttpAutoProxySvc;Winmgmt;WinRM;wisvc;WlanSvc;wl" + 
                                   "idsvc;wlpasvc;wmiApSrv;WMPNetworkSvc;WMSVC;workfolderssvc;WpcMonSvc;WPDBusEnum;WpnService;WpnUserService_$QMARK;" + 
                                   "wscsvc;WSearch;wuauserv;wudfsvc;WwanSvc;xbgm;XblAuthManager;XblGameSave;XboxGipSvc;XboxNetApiSvc" ).Split( ';' )
            Values               = ("0;1;2;3;3;4;3;5;3;6;2;2;3;3;3;2;7;3;3;0;0;0;0;3;3;4;7;2;0;3;2;8;3;3;3;3;3;2;3;3;2;3;1;2;7;3;2;3;3;3;2;3;3;3;2;2" + 
                                   ";1;3;3;3;2;3;1;2;3;3;6;3;3;1;1;3;3;9;0;1;3;3;2;2;1;3;3;3;2;3;1;0;3;3;1;11;2;2;0;3;3;0;0;3;2;2;3;3;2;1;2;2;7;3;3;" + 
                                   "2;8;3;1;3;3;3;3;3;2;3;3;2;3;3;3;3;12;12;1;3;1;2;12;1;1;3;3;1;2;6;13;13;13;0;7;1;3;2;12;3;1;1;3;2;3;3;3;3;3;3;3;2" + 
                                   ";13;3;0;2;3;3;3;2;3;12;5;3;0;3;2;3;3;3;6;1;1;1;1;1;1;1;1;14;3;3;3;2;3;3;3;3;3;3;2;0;3;3;0;3;3;3;3;13;3;3;2;1;1;1" + 
                                   "5;3;3;3;1;3;1;1;3;2;2;7;7;3;3;1;3;1;1;3;1").Split(';')
            Profile              = ("2,2,2,2,2,2,1,1,2,2;2,2,2,2,1,1,1,1,1,1;3,0,3,0,3,0,3,0,3,0;2,0,2,0,2,0,2,0,2,0;0,0,2,2,2,2,1,1,2,2;0,0,1,0,1,0" + 
                                   ",1,0,1,0;0,0,2,0,2,0,2,0,2,0;4,0,4,0,4,0,4,0,4,0;0,0,2,2,1,1,1,1,1,1;3,3,3,3,3,3,1,1,3,3;4,4,4,4,1,1,1,1,1,1;0,0" + 
                                   ",0,0,0,0,0,0,0,0;1,0,1,0,1,0,1,0,1,0;2,2,2,2,1,1,1,1,2,2;0,0,3,0,3,0,3,0,3,0;3,3,3,3,2,2,2,2,3,3" ).Split( ';' )
        }

        $Ref                     = [ PSCustomObject ]@{ 
            
            Company              = "https://github.com/secure-digits-plus-llc/FightingEntropy"
            MadBomb              = "https://github.com/madbomb122/BlackViperScript"
        }

        $Return                  = [ PSCustomObject ]@{ 

            PID                  = $QMark

            Version              = [ PSCustomObject ]@{ 

                Version          = "ViperBomb v7.3.0"
                Date             = "2020-03-04"
                Script           = $Default.ScriptConfig
                Service          = $Default.ServiceConfig
                Release          = "Development"
            }

            Company              = [ PSCustomObject ]@{

                Base             = $Ref.Company
                About            = $Ref.Company + "#secure-digits-plus-fighting-entropy"
                Service          = $Ref.Company + "/blob/master/Module/Services/" + $Default.ServiceConfig
                Site             = "https://www.securedigitsplus.com"
            }

            MadBomb              = [ PSCustomObject ]@{

                Base             = $Ref.MadBomb
                About            = $Ref.MadBomb + "/blob/master/README.md"
                Donate           = "https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/"
            }

            Sparks               = [ PSCustomObject ]@{ 

                Site             = "http://www.blackviper.com"
            }

            Path                 = Get-ScriptRoot

            Control              = $Default

            Copyright            = 
            
                "Copyright (c) 2019 Zero Rights Reserved                                 " ,
                "Services Configuration by Charles 'Black Viper' Sparks                  " ,
                "------------------------------------------------------------------------" ,
                "The MIT License (MIT) + an added Condition" , 
                "$( " " * 72 )" , 
                "Copyright (c) 2017-2019 Madbomb122 " ,
                "[ Black Viper Service Script ] " ,
                "$( " " * 72 )" , 
                "Permission is hereby granted, free of charge, to any person obtaining a " ,
                "copy of this software and associated documentation files (the Software)," , 
                "to deal in the Software without restriction, including w/o limitation   " , 
                "the rights to: use/copy/modify/merge/publish/distribute/sublicense,     " , 
                "and/or sell copies of the Software, and to permit persons to whom the   " , 
                "Software is furnished to do so, subject to the following conditions:    " ,
                "$( " " * 72 )" ,
                "The above copyright notice(s), this permission notice and ANY original  " , 
                "donation link shall be included in all copies or substantial portions of" , 
                "the Software.                                                           " ,
                "$( " " * 72 )" ,
                " The software is provided 'As Is', without warranty of any kind, express" ,
                "or implied, including but not limited to warranties of merchantibility, " ,
                "or fitness for a particular purpose and noninfringement. In no event    " , 
                "shall the authors or copyright holders be liable for any claim, damages " ,
                "or other liability, whether in an action of contract, tort or otherwise," , 
                "arising from, out of or in connection with the software or the use or   " ,
                "other dealings in the software.                                         " ,
                "$( " " * 72 )" ,
                "In other words, these terms of service must be accepted in order to use," ,
                "and in no circumstance may the author(s) be subjected to any liability  " ,
                "or damage resultant to its use.                                         "

            Message              = 
            
                "This utility provides an interface to load and customize`n" ,
                "service configuration profiles, such as:`n"                 ,
                "`n"                                                         ,
                "    Default: Black Viper (Sparks v1.0)`n"                   ,
                "    Custom: If in proper format`n"                          ,
                "    Backup: Created via this utility`n"                     -join '' 

            Help                 = 
            
                "Legacy Switches - [ Pending ] List of Switches                                                            " , 
                "$( "-" * 108 )" , 
                "   " ,
                " Switch            Description of Switch                                                                  " , 
                "   " , 
                " -- Basic Switches --                                                                                     " , 
                "  -atos            Accepts ToS                                                                            " , 
                "  -auto            Implies -atos ... Runs the script to be Automated..                                    " , 
                "                   Closes on - User Input, Errors, or End of Script                                       " , 
                "   " , 
	            " -- Service Configuration Switches --                                                                     " , 
	            "  -default         Runs the script with Services to Default Configuration                                 " , 
                "  -safe            Runs the script with Services to Black Viper's Safe Configuration                      " , 
                "  -tweaked         Runs the script with Services to Black Viper's Tweaked Configuration                   " , 
                "  -lcsc File.csv   Loads Custom Service Configuration, File.csv = Name of your backup/custom file         " , 
                "   " ,
                " --Service Choice Switches--                                                                              " , 
                "  -all             Every windows services will change                                                     " , 
                "  -min             Just the services different from the default to safe/tweaked list                      " , 
                "  -sxb             Skips changes to all XBox Services                                                     " , 
                "   " ,
                " --Update Switches--                                                                                      " , 
	            "  -usc             Checks for Update to Script file before running                                        " , 
                "  -use             Checks for Update to Service file before running                                       " , 
                "  -sic             Skips Internet Check, if you can't ping GitHub.com for some reason                     " , 
                "   " ,
                " --Log Switches--                                                                                         " , 
                "  -log             Makes a log file named using default name Script.log                                   " , 
                "  -log File.log    Makes a log file named File.log                                                        " , 
                "  -baf             Log File of Services Configuration Before and After the script                         " , 
                "   " ,
                " --Backup Service Configuration--                                                                         " , 
                "  -bscc            Backup Current Service Configuration, Csv File                                         " , 
                "  -bscr            Backup Current Service Configuration, Reg File                                         " , 
                "  -bscb            Backup Current Service Configuration, Csv and Reg File                                 " , 
                "   " ,
                " --Display Switches--                                                                                     " , 
                "  -sas             Show Already Set Services                                                              " , 
                "  -snis            Show Not Installed Services                                                            " , 
                "  -sss             Show Skipped Services                                                                  " , 
                "   " ,
                " --Misc Switches--                                                                                        " , 
                "  -dry             Runs the Script and Shows what services will be changed                                " , 
                "  -css             Change State of Service                                                                " , 
                "  -sds             Stop Disabled Service                                                                  " , 
                "   " ,
                " --AT YOUR OWN RISK Switches--                                                                            " , 
                "  -secp            Skips Edition Check by Setting Edition as Pro                                          " , 
                "  -sech            Skips Edition Check by Setting Edition as Home                                         " , 
                "  -sbc             Skips Build Check                                                                      " , 
                "   " ,
                " --Dev Switches--                                                                                         " ,
                "  -devl            Makes a log file with various Diagnostic information, Nothing is Changed               " , 
                "  -diag            Shows diagnostic information, Stops -auto                                              " , 
                "  -diagf           Forced diagnostic information, Script does nothing else                                " , 
                "   " ,
                " --Help--                                                                                                 " ,
                "  -help            Shows list of switches, then exits script.. alt -h                                     " , 
                "  -copy            Shows Copyright/License Information, then exits script                                 "

            Types                = [ PSCustomObject ]@{

                Types            = @( "H" , "P" | % { "10$_`:D" } ; "S" , "T" | % { "DT:$_" } ; "LT:S" ) | % { "$_+" , "$_-" }

                Titles           = @( "Home" , "Pro" | % { "Win10 $_ | Default" } ; "Safe" , "Tweaked" | % { "Desktop | $_" } ; "Laptop | Safe" ) | % { "$_ Max" , "$_ Min" }
            }

            Services             = [ PSCustomObject ]@{ 

                Xbox             = 'XblAuthManager,XblGameSave,XboxNetApiSvc,XboxGipSvc,xbgm'.Split(',')

                NetTCP           = 'Msmq,Pipe,Tcp' | % { "Net$_`Activator" }

                DataGrid         = 'Index,Scoped,Profile,Name,StartMode,Status,DisplayName,PathName,Description'.Split(',')

                Skip             = @( ( 'BcastDVRUserService,DevicePickerUserSvc,DevicesFlowUserSvc,PimIndexMaintenanceSvc,PrintWorkflowUserSvc,UnistoreSvc,' + 
                                   'UserDataSvc,WpnUserService' -join '' ).Split(',') | % { "$_`_$QMark" } ) + @( 'AppXSVC,BrokerInfrastructure,ClipSVC,CoreMessagingRegistrar,' + 
                                   'DcomLaunch,EntAppSvc,gpsvc,LSM,MpsSvc,msiserver,NgcCtnrSvc,NgcSvc,RpcEptMapper,RpcSs,Schedule,SecurityHealthService,sppsvc,StateRepository,' + 
                                   'SystemEventsBroker,tiledatamodelsvc,WdNisSvc,WinDefend' -join '' ).Split(',') | Sort
            }

            Names                = @( 0..4 | % { "MenuConfig" , 'Home,Pro,Desktop,Desktop,Laptop'.Split(',')[$_] , 'Default,Default,Safe,Tweaked,Safe'.Split(',')[$_] -join '' } | % { "$_`Max" , "$_`Min" } ; 
                                     'Feedback,FAQ,About,Copyright,MadBombDonate,MadBombGitHub,BlackViper,SecureDigitsPlus'.Split(',')                | % { "MenuInfo$_" } ;
                                     'Search,Select,Grid,Empty'.Split(',') | % { "ServiceDialog$_" } ;                  'OS,Build,Chassis'.Split(',') | % {  "Current$_" } ; 
                                     'Active,Inactive,Skipped'.Split(',')  | % {       "Display$_" } ; 'Simulate,Xbox,Change,StopDisabled'.Split(',') | % {     "Misc$_" } ; 
                                     'DiagErrors,Log,Console,DiagReport'.Split(',') | % { "Devel$_" } ; 'Build,Edition,Laptop'.Split(',') | % { "Bypass$_" } ;
                                     @( 'Service,Script'.Split(',') | % { "Logging$_" } ; 'Registry,Template'.Split(',') | % { "Backup$_" } ) | % { "$_`Browse,$_`File".Split(',') } ;
                                     'Service,Script'.Split(',') | % { "$_`Profile" , "$_`Label"  } ; "Start,Cancel" -Split ',' )

            Config              = $ServiceConfig | % {
                
                ForEach ( $i in 0..( $_.Names.Count - 1 ) )
                { 
                    [ PSCustomObject ]@{ 
                
                        Service = $_.Names[$I]
                        Profile = $_.Profile[ $_.Values[$I]]
                    }
                }
            }

            Template = [ PSCustomObject ]@{

                Profile   = 'Skip' , 'Disabled' , 'Manual' , 'Auto' , 'Auto'
                StartMode = 'Skip' , 'Disabled' , 'Manual' , 'Auto' , 'Auto'
                State     = 'Stopped' , 'Running'
            }
        }

        $Return | % { 
        
            If ( $Version   ) { $_.Version   }
            If ( $Company   ) { $_.Company   }
            If ( $MadBomb   ) { $_.MadBomb   }
            If ( $Sparks    ) { $_.Sparks    }
            If ( $Path      ) { $_.Path      }
            If ( $Control   ) { $_.Control   }
            If ( $Copyright ) { $_.Copyright }
            If ( $Message   ) { $_.Message   }
            If ( $Help      ) { $_.Help      }
            If ( $Services  ) { $_.Services  }
            If ( $Types     ) { $_.Types     }
            If ( $Names     ) { $_.Names     }
            If ( $Config    ) { $_.Config    }
            If ( $All       ) { $_ }
        }
                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Start-ViperDiagnostics #___________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param (

            [ Parameter ( ) ] [ PSCustomObject ] $Model )

        $System               = Resolve-Windows -All
        $Viper                = Resolve-ViperBomb -All

        $Collect              = [ PSCustomObject ]@{ 

            Title             = @("Script","System"|%{"$_ Information"};"Initialization";("Display,Miscellaneous,Development,Bypass/Force,Logging,B"+
                                  "ackup").Split(',')|%{"$_ Settings"};"Version Control")|%{"( $_ )"}

            Section           = "Script,Sys,Cfg,Display,Miscellaneous,Development,Bypass,Logging,Backup,Version".Split(',')

            Info              = @("Version,Date,Script,Service,Release;";"OS,SKU,Build,Version,Chassis;";"Passed Args,Terms of Service;";"Active,In"+
                                "active,Skipped;Show {0} SVC";"Simulate Changes,Xbox Services,Change * SVC State,Stop * Disabled SVC;";"Diagnostic "+
                                "Errors,Devel Log,Enable Console,Report Diagnostic;";"Build Edition,Laptop;Bypass {0}";"Service,Script;Log {0} File";
                                "Registry,Template;Backup {0}";"Service,Script;{0} Config")

            Item              = @("Version,Date,Script,Service,Release";"OS,SKU,Build,Version,Chassis";"PassedArgs,TermsOfService";"DisplayActive,D"+
                                "isplayInactive,DisplaySkipped";"MiscSimulate,MiscXbox,MiscChange,MiscStopDisabled";"DevelDiagErrors,DevelLog,Devel"+
                                "Console,DevelDiagReport";"BypassBuild,BypassEdition,BypassLaptop";"LoggingServiceFile,LoggingScriptFile";"BackupRe"+
                                "gistryFile,BackupTemplateFile";"ServiceConfig,ScriptConfig")

            Subtable          = 0..9
        
            Script            = $Viper.Version
            
            Sys               = [ PSCustomObject ]@{
    
                OS            = $System.OS | % { "$( $_.Caption ) [$( $_.OSArchitecture )]" }
                SKU           = $System.SKU
                Build         = $System.Edition.Build
                Version       = $System.Edition.Version
                Chassis       = $System.Chassis
            }

            Cfg               = $Model | % { If ( $_ -eq $Null ) { $Viper.Control } Else { $_ } }
        }

        ForEach ( $I in 0..9 )
        {
            $X                = $Collect.Info[$I].Split(';')

            $Collect.Info[$I] = If ( $X[1] -like "{0}" ) 
            { 
                ( $X[0].Split(',') | % { $X[1] -f $_ } ) -join ',' 
            } 
            
            Else 
            { 
                $X[0] 
            }

            $Items            = $Collect.Item[$I].Split(',')

            $Values           = $Items | % { 
            
                If ( $I -eq 0 ) 
                { 
                    $Collect.Script.$_ 
                } 
                
                If ( $I -eq 1 ) 
                { 
                    $Collect.Sys.$_ 
                } 
                
                If ( $I -gt 1 ) 
                { 
                    $Collect.Cfg.$_ 
                } 
            }

            $Collect.Subtable[$I] = New-Subtable -Items $Items -Values $Values
        }

        $Splat                = @{

            Title             = "Diagnostic/Startup Panel"
            Depth             = 10
            ID                = $Collect.Title
            Table             = $Collect.Subtable
        }

        $Table                = New-Table @Splat
        
        Write-Theme -Table $Table -Prompt "Press Enter to Continue, CTRL+C to Exit"

                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Get-ServiceProfile #_______________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        
        Write-Theme -Action "Collecting [+]" "[ Service Configuration ]: Current Profile"

        $Get                          = [ PSCustomObject ]@{ 

            Config                    = Resolve-ViperBomb -Config
            Current                   = Get-CurrentServices
            Index                     = ""
            Scoped                    = @( )
            Profile                   = @( )
            Name                      = @( )
            StartMode                 = @( )
            State                     = @( )
            DisplayName               = @( )
            PathName                  = @( )
            Description               = @( )
            Track                     = [ PSCustomObject ]@{

                Current               = [ PSCustomObject ]@{

                    Inc               = ""
                    Exc               = ""
                    Ct                = ""
                }

                Config                = [ PSCustomObject ]@{ 
                    
                    Inc               = ""
                    Exc               = ""
                    Profile           = ""
                    Ct                = ""
                }
            }
        }

        $Get.Track                    | % { 
        
            $_.Current                | % { 
        
                $_.Inc                = $Get.Current     | ? { $_.Name    -in $Get.Config.Service } | % { $_.Name }
                $_.Exc                = $Get.Current     | ? { $_.Name -notin $Get.Config.Service } | % { $_.Name }
                $_.Ct                 = $_.Inc.Count + $_.Exc.Count
            }

            $_.Config                 | % { 

                $_.Inc                = $Get.Config      | ? { $_.Service    -in $Get.Current.Name   } | % { $_.Service }
                $_.Exc                = $Get.Config      | ? { $_.Service -notin $Get.Current.Name   } | % { $_.Service }
                $_.Profile            = $Get.Config      | ? { $_.Service    -in $Get.Current.Name   }
                $_.Ct                 = $_.Inc.Count + $_.Exc.Count
            }
        }

        $Get.Index                    = 0..( $Get.Current.Count - 1 )

        $Get.Index                    = $Get.Index.Count | Measure -Character | % { $_.Characters } | % {
            
            ForEach ( $I in $Get.Index ) 
            { 
                "{0:d$_}" -f $I 
            }
        }
        
        $Get                          | % { 

            $_.Scoped                 = $_.Index | % { "[~]" }
            $_.Profile                = $_.Index | % { "-,-,-,-,-,-,-,-,-,-" }
            $_.Name                   = $_.Index | % { "-" }
            $_.StartMode              = $_.Index | % { "-" }
            $_.State                  = $_.Index | % { "-" }
            $_.DisplayName            = $_.Index | % { "-" }
            $_.PathName               = $_.Index | % { "-" }
            $_.Description            = $_.Index | % { "-" }

        }

        $Get.Track.Config.Profile     = $Get.Config | ? { $_.Service -in $Get.Current.Name }

        ForEach ( $I in $Get.Index )
        {
            $Get.Name[$I]             = $Get.Current.Name[$I]
                
            If ( $Get.Name[$I]     -in $Get.Track.Current.Inc )
            {
                $Get.Scoped[$I]       = "[+]"
                $Get.Profile[$I]      = $Get.Track.Config.Profile | ? { $_.Service -eq $Get.Name[$I] } | % { $_.Profile }
                $Get.StartMode[$I]    = $Get.Current.StartMode[$I]
                $Get.State[$I]        = $Get.Current.State[$I]
                $Get.DisplayName[$I]  = $Get.Current.DisplayName[$I]
                $Get.PathName[$I]     = $Get.Current.PathName[$I]
                $Get.Description[$I]  = $Get.Current.Description[$I]
            }

            If ( ( $Get.Name[$I] -in $Get.Current.Name ) -and ( $Get.Name[$I] -in $Get.Track.Current.Exc ) )
            {
                $Get.Scoped[$I]       = "[X]"
                $Get.Profile[$I]      = "-,-,-,-,-,-,-,-,-,-"
                $Get.StartMode[$I]    = $Get.Current.StartMode[$I]
                $Get.State[$I]        = $Get.Current.State[$I]
                $Get.DisplayName[$I]  = $Get.Current.DisplayName[$I]
                $Get.PathName[$I]     = $Get.Current.PathName[$I]
                $Get.Description[$I]  = $Get.Current.Description[$I]
            }
        }

        $Return                       = $Get.Index | % { 
        
            [ PSCustomObject ]@{ 
            
                Index                 = $Get.Index[$_]
                Scoped                = $Get.Scoped[$_]
                Profile               = $Get.Profile[$_]
                Name                  = $Get.Name[$_]
                StartMode             = $Get.StartMode[$_]
                State                 = $Get.State[$_]
                DisplayName           = $Get.DisplayName[$_]
                PathName              = $Get.PathName[$_]
                Description           = $Get.Description[$_]
            }
        }

        [ PSCustomObject ]@{

            Service                   = $Return 
            Config                    = $Get.Config
            Current                   = $Get.Current
        }

        Write-Theme -Action  "Importing [+]" "[ Service Configuration ]: Target Profile"

                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Update-ServiceProfile #____________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param (

            [ Parameter ( Mandatory ) ] [ PSCustomObject ] $Object )

            $Return = @( )

            If ( $Object.Control.DisplayActive -eq 1 )
            {
                $Return += $Object.Service | ? { $_.State -eq "Running" } | % { $_.Name }
            }

            If ( $Object.Control.DisplayInactive -eq 1 )
            {
                $Return += $Object.Service | ? { $_.State -eq "Stopped" } | % { $_.Name }
            }

            If ( $Object.Control.DisplaySkipped -eq 1 )
            { 
                $Return += $Object.Service | ? { $_.Name -in $Object.Info.Services.Skip } | % { $_.Name } 
            }

            If ( $Object.Control.MiscXbox -eq 1 )
            { 
                $Return += $Object.Service | ? { $_.Name -in $Object.Info.Services.Xbox } | % { $_.Name } 
            }
        
            $Object.Service | ? { $_.Name -in $Return } | % { $_.Name }             #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Select-ServiceProfile #____________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ] Param ( 
            
            [ Parameter   ( Mandatory           ) ] [ PSCustomObject ] $Object ,
            [ ValidateSet ( 0,1,2,3,4,5,6,7,8,9 ) ] [ Int            ] $Slot   )

        If ( $Object.Control.Profile -ne $Slot )
        {
            $Object.Control.Profile                    = $Slot
        }

        ForEach ( $I in 0..( $Object.Service.Count - 1 ) )
        {
            $X                                         = $Object.Service[$I]

            [ PSCustomObject ]@{
                
                Index                                  = $X.Index
                Scoped                                 = $X.Scoped
                Profile                                = $X.Profile.Split(',')[$Slot]
                Name                                   = $X.Name
                StartMode                              = $X.StartMode
                State                                  = $X.State
                DisplayName                            = $X.DisplayName
                PathName                               = $X.PathName
                Description                            = $X.Description
            }
        }                                                                           #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Save-FileDialog #__________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding() ] Param ( 

            [ Parameter   (     Mandatory ) ] [ PSCustomObject ] $Object ,
            [ Validateset ( 0 , 1 , 2 , 3 ) ]
            [ Parameter   (     Mandatory ) ] [            Int ] $Item    )

        $Obj                                   = [ PSCustomObject ]@{ 
            
            Item                               = ( $Object.GUI     | % { $_.LoggingServiceFile , $_.LoggingScriptFile , $_.BackupRegistryFile , $_.BackupTemplateFile } )[$Item]
            Object                             = ( $Object.Control | % { $_.LoggingServiceFile , $_.LoggingScriptFile , $_.BackupRegistryFile , $_.BackupTemplateFile } )[$Item]
            Caption                            = ( ( "Service {0},Script {0},Registry {1},Template {1}" -f "Logging" , "Backup" ).Split(',') | % { "Designate $_ File" } )[$Item]
            Type                               = ( "log" , "log" , "reg" , "csv" | % { "$_ (*.$_) | *.$_" } )[$Item]
            Name                               = ( "Service.log" , "Script.log" , "Backup.reg" , "Template.csv" )[$Item]
            Dialog                             = New-Object System.Windows.Forms.SaveFileDialog
        }

        $Obj.Item                              | % {
                    
            $_.IsEnabled                       = $True
            $_.Text                            = ( Get-Date -UFormat "%Y%m%d_%H%M" ) , $Obj.Object -join '_'
        }
                    
        $Obj.Dialog                            | % {

            $_.Title                           = $Obj.Caption
            $_.InitialDirectory                = $Object.Info.Path.Parent + "\Services"
            $_.Filter                          = $Obj.Type
            $_.Filename                        = ( Get-Date -UFormat "%Y%m%d-%H_%M" ) , $Obj.Name -join '_'
        }

        $X                                     = $Obj.Dialog.ShowDialog()

        If ( $X -eq "OK" )
        {
            $Obj.Item.Text                     = $Obj.Dialog.FileName
        }

        Else
        {
            $Obj.Item                          | % {
                          
                $_.IsEnabled                   = $False
                $_.Text                        = "<Activate to designate a different file name/path>"
            }
        }

        $Obj.Dialog.Dispose()                                                       #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
    Function Initialize-ViperBomb # ____________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      

     #  _____________________________
     # (¯¯¯¯¯¯¯¯ OS Version ¯¯¯¯¯¯¯¯¯)
     #  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        [ Environment ]::OSVersion.Version.Major         | % {
        
            If ( $_ -ne 10 )
            {
                Write-Theme -Action "Exception [!]" "Only Windows 10 Client is currently supported" 12 4 15
                Read-Host "Press Enter to Exit"
                Break
            }
        }
     #  _____________________________
     # (¯¯¯ Administrative Rights ¯¯¯)
     #  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        IEX ( "([{0}Principal][{0}Identity]::GetCurrent()).IsInRole('Administrator')" -f "Security.Principal.Windows" ) | % {

            If ( $False )
            {                
                Write-Theme -Action "Access [!]" "Limited, attempting elevation" 12 4 15

                SAPS PowerShell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PassedArg" -Verb RunAs
                
                If ( $False )
                { 
                    Write-Theme -Action "Exception [!]" "Elevation has failed" 12 4 15
                    Read-Host "Press Enter to Exit"
                    Break
                }
            }

            If ( $True )
            { 
                Write-Theme -Action "Confirmed [+]" "Administrative Rights" 11 11 15 
            }
        }
     #  _____________________________
     # (¯¯¯¯¯¯¯¯ OS Version ¯¯¯¯¯¯¯¯¯)
     #  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        Write-Theme -Array ( Resolve-ViperBomb -Copyright ) -Title "Terms of Service / Copyright" -Prompt "Press Enter to Continue" | % { 

            If ( $_ -eq $True )
            {
                Write-Theme -Action "Accepted [+]" "Terms of Service" 11 11 15

                Get-ServiceProfile                        | % {
                
                    $Master                               = [ PSCustomObject ]@{ 

                        System                            = Resolve-Windows -All
                        Info                              = Resolve-ViperBomb -All
                        Config                            = $_.Config
                        Service                           = $_.Service
                        Current                           = $_.Current
                        Control                           = Resolve-ViperBomb -Control
                        Filter                            = @( )
                        Profile                           = @( )
                        Refresh                           = @( )
                        GUI                               = Convert-XAMLToWindow -XAML ( Get-Xaml -Service ) -NE ( Resolve-ViperBomb -Names ) -PassThru
                    }
                }

                $Service                                  = [ PSCustomObject ]@{ 
                
                    Profile                               = "N/A,Automatic,Automatic,Manual,Disabled".Split(',')
                    StartMode                             = "N/A,Automatic,Automatic,Manual,Disabled".Split(',')
                    Status                                = "Stopped,Running".Split(',')
                }

                $Filter                                   = {

                    Param ( $Slot )
                
                    $Master.GUI.ServiceDialogSearch       | % {
                        
                        If ( ! $_.IsEnabled )
                        {
                            $_.IsEnabled                  = $True
                        }
                    }

                    $Master.GUI.ServiceDialogEmpty        | % {
                                
                        $_.Visibility                     = "Collapsed"
                        $_.Text                           = ""
                    }

                    $Master.Filter                        = Update-ServiceProfile -Object $Master
                
                    If ( $Slot -ne $Null )
                    {
                        $Master.Profile                   = Select-ServiceProfile -Object $Master -Slot $Slot | ? { $_.Name -in $Master.Filter }

                        $Master.GUI.ServiceDialogGrid.ItemsSource = $Master.Profile 
                    }
                }

                $Master.Control.TermsOfService            = 1
            }

            Else 
            {
                Write-Theme -Action "Exception [!]" "Terms of Service was not accepted, aborting" 12 4 15
                Read-Host "Press Enter to Exit"
                Break
            }
        }
     #  ___________________________
     # (¯¯¯¯¯¯¯¯ Defaults ¯¯¯¯¯¯¯¯¯)
     #  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        $Master.GUI | % {
        
            $_.DisplayActive , $_.DisplayInactive , $_.DisplaySkipped | % { 
            
                $_.IsChecked                              = $True 
            }
            
            $_.CurrentOS.Text                             = "{0} ({1})" -f $Master.System.OS.Caption , $env:PROCESSOR_ARCHITECTURE.Replace( 'AMD' , 'x' )
            $_.CurrentBuild.Text                          = $PSVersionTable.BuildVersion
            $_.CurrentChassis.Text                        = $Master.System.Chassis

            $_.ServiceDialogEmpty.Text                    = "Select a profile from the configuration menu to begin"
            $_.ServiceDialogSearch.IsEnabled              = $False
            $_.ServiceLabel.Text                          = $_.ServiceProfile.SelectedItem.Content
            $_.ScriptLabel.Text                           = $_.ScriptProfile.SelectedItem.Content

            $_.MenuInfoFeedback.Add_Click({                 Start $Master.Info.Company.Base                                                                               })
            $_.MenuInfoFAQ.Add_Click({                      Start $Master.Info.Company.About                                                                              })
            $_.MenuInfoAbout.Add_Click({                    Show-Message -Title "About - ViperBomb Service Configuration Utility" -Message ( Resolve-ViperBomb -Message ) })
            $_.MenuInfoCopyright.Add_Click({                Show-Message -Title "Copyright" -Message ( ( Resolve-ViperBomb -Copyright ) -join "`n" )                      })
            $_.MenuInfoMadBombDonate.Add_Click({            Start $Master.Info.MadBomb.Donate                                                                             })
            $_.MenuInfoMadBombGitHub.Add_Click({            Start $Master.Info.MadBomb.Base                                                                               })
            $_.MenuInfoBlackViper.Add_Click({               Start $Master.Info.Sparks.Site                                                                                })
            $_.MenuInfoSecureDigitsPlus.Add_Click({         Start $Master.Info.Company.Site                                                                               })

            $_.MenuConfigHomeDefaultMax.Add_Click({         & $Filter 0 })
            $_.MenuConfigHomeDefaultMin.Add_Click({         & $Filter 1 })
            $_.MenuConfigProDefaultMax.Add_Click({          & $Filter 2 })
            $_.MenuConfigProDefaultMin.Add_Click({          & $Filter 3 })
            $_.MenuConfigDesktopSafeMax.Add_Click({         & $Filter 4 })
            $_.MenuConfigDesktopSafeMin.Add_Click({         & $Filter 5 })
            $_.MenuConfigDesktopTweakedMax.Add_Click({      & $Filter 6 })
            $_.MenuConfigDesktopTweakedMin.Add_Click({      & $Filter 7 })
            $_.MenuConfigLaptopSafeMax.Add_Click({          & $Filter 8 })
            $_.MenuConfigLaptopSafeMin.Add_Click({          & $Filter 9 })

            $_.DisplayActive.Add_Unchecked({                $Master.Control.DisplayActive   = 0 ; & $Filter })
            $_.DisplayActive.Add_Checked({                  $Master.Control.DisplayActive   = 1 ; & $Filter })
            $_.DisplayInactive.Add_Unchecked({              $Master.Control.DisplayInactive = 0 ; & $Filter })
            $_.DisplayInactive.Add_Checked({                $Master.Control.DisplayInactive = 1 ; & $Filter })
            $_.DisplaySkipped.Add_Unchecked({               $Master.Control.DisplaySkipped  = 0 ; & $Filter })
            $_.DisplaySkipped.Add_Checked({                 $Master.Control.DisplaySkipped  = 1 ; & $Filter })
            $_.MiscXbox.Add_Unchecked({                     $Master.Control.MiscXbox        = 0 ; & $Filter })
            $_.MiscXbox.Add_Checked({                       $Master.Control.MiscXbox        = 1 ; & $Filter })
        }

        $Master.GUI.ServiceDialogSearch.Add_TextChanged(
        {
            If ( $Master.GUI.ServiceDialogSearch.Text -ne "" )
            {
                $Master.GUI.ServiceDialogSelect.IsEnabled     = $False
                $Query                                        = $Master.GUI.ServiceDialogSelect.SelectedItem.Content
            }
            
            $Text                                             = $Master.GUI.ServiceDialogSearch.Text
            $Master.GUI.ServiceDialogGrid.ItemsSource         = $Null

            $Return                                           = @( )

            $Master.Profile.Clone()                           | ? { $_.$Query -match $Text } | % { 
                
                If ( $_.Name -in $Master.Filter )
                {
                    $Return                                  += $_ 
                }
            }
            
            If ( $Return.Count -gt 0 )
            {
                $Master.GUI.ServiceDialogGrid.Visibility      = "Visible" 
                $Master.GUI.ServiceDialogGrid.ItemsSource     = $Return
                $Master.GUI.ServiceDialogEmpty.Visibility     = "Collapsed"
                $Master.GUI.ServiceDialogGrid.Text            = ""
            }

            If ( $Return.Count -eq 0 )
            {
                $Master.GUI.ServiceDialogGrid.Visibility      = "Collapsed"
                $Master.GUI.ServiceDialogGrid.ItemsSource     = $Null
                $Master.GUI.ServiceDialogEmpty.Visibility     = "Visible"
                $Master.GUI.ServiceDialogGrid.Text            = "No results found"
            }

            If ( $Master.GUI.ServiceDialogSearch.Text -eq "" )
            {
                If ( $Master.GUI.ServiceDialogSelect.IsEnabled -eq $False )
                {
                    $Master.GUI.ServiceDialogSelect.IsEnabled = $True
                }

                $Master.GUI.ServiceDialogGrid.Visibility      = "Visible"
                $Master.GUI.ServiceDialogGrid.ItemsSource     = $Master.Profile
                $Master.GUI.ServiceDialogEmpty.Visibility     = "Collapsed"
                $Master.GUI.ServiceDialogEmpty.Text           = ""
            }
        })
            
        $Master.GUI.LoggingServiceBrowse.Add_Click(      { Save-FileDialog -Item 0 -Object $Master })
        $Master.GUI.LoggingScriptBrowse.Add_Click(       { Save-FileDialog -Item 1 -Object $Master })
        $Master.GUI.BackupRegistryBrowse.Add_Click(      { Save-FileDialog -Item 2 -Object $Master })
        $Master.GUI.BackupTemplateBrowse.Add_Click(      { Save-FileDialog -Item 3 -Object $Master })
        $Master.GUI.ServiceProfile.Add_SelectionChanged( { $Master.GUI.ServiceLabel.Text = $Master.GUI.ServiceProfile.SelectedItem.Content })
        $Master.GUI.ScriptProfile.Add_SelectionChanged(  { $Master.GUI.ScriptLabel.Text  = $Master.GUI.ScriptProfile.SelectedItem.Content  })
        $Master.GUI.Cancel.Add_Click(                    { $Master.GUI.DialogResult      = $False  })
        
        $Master.GUI | % { $_.LoggingServiceFile , $_.LoggingScriptFile , $_.BackupRegistryFile , $_.BackupTemplateFile } | % { 
            
                $_.Text = "<Activate to designate a different file name/path>" 
            }

        Show-WPFWindow -GUI $Master.GUI

        #$GUI.MiscSimulate
        #$GUI.MiscChange
        #$GUI.MiscStopDisabled
        #$GUI.DevelDiagErrors
        #$GUI.DevelLog
        #$GUI.DevelConsole
        #$GUI.DevelDiagReport
        #$GUI.BypassBuild
        #$GUI.BypassEdition
        #$GUI.BypassLaptop
        #$GUI.MiscSimulate   [ What If ] # Produce a list of services and corresponding changes
        #$GUI.MiscChange [ Change the service state ]  # If running, and non compliant, change the state
        #$GUI.MiscStopDisabled # If a disabled service is running, stop them?
        #$GUI.DevelDiagErrors
        #$GUI.DevelLog
        #$GUI.DevelConsole
        #$GUI.DevelDiagReport
        #$GUI.ConsoleOutput
        #$GUI.DiagnosticOutput
        #$GUI.Start
                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}