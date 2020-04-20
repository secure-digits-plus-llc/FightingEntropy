        
        # [Console] Variables
        # Properties / BackgroundColor BufferHeight BufferWidth CapsLock CursorLeft CursorSize CursorTop CursorVisible Error 
        # ForegroundColor In InputEncoding IsErrorRedirected IsInputRedirected IsOutoutRedirected KeyAvailable LargestWindowHeight LargestWindowWidth 
        # NumberLock Out OutputEncoding Title TreatControlCAsInput WindowHeight WindowLeft WindowTop WindowWidth / Beep Clear Equals 
        # MoveBufferArea OpenStandardError OpenStandardInput OpenStandardOutput Read ReadKey ReadLine ReferenceEquals ResetColor 
        # SetBufferSize SetCursorPosition SetError SetIn SetOut SetWindowPosition SetWindowSize Write WriteLine CancelKeyPress

        (("Back{0} {1}Height {1}Width CapsLock {2}Left {2}Size {2}Top {2}Visible Error Fore{0} In In{3} "+
        "IsError{4} IsInput{4} IsOutput{4} KeyAvailable Largest{5}Height Largest{5}Width NumberLock Ou"+
        "t Out{3} Title TreatControlCAsInput {5}Height {5}Left {5}Top {5}Width"  ) -f ("groundColor Bu"+
        "ffer Cursor putEncoding Redirected Window" ).Split(" ") ).Split(" ").GetHashCode() | % { 
            
            [ PSCustomObject ]@{ 

                Name   = $_ 
                Value  = "[Console]::$_"
            }
        }

        "System Collections.Generic IO Linq Threading.Tasks Security.AccessControl Security.Principal Management.Automation DirectoryServices" -Replace " "," System." -Split " " | % { 

            IEX "Using Namespace $_" 
        }

        [PSCustomObject][Environment]::GetEnvironmentVariables().GetEnumerator() | Sort Name
        [PSCustomObject][Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()

        @{  
            Name             = "Window"
            Namespace        = "Console"
            MemberDefinition = "{0}{1}" -f ( 0..1 | % { 
                            
                "[DllImport(`"{0}32.dll`")] public static extern {1};" -f
                ("kernel","user")[$_] ,
                ("IntPtr GetConsoleWindow()","bool ShowWindow(IntPtr hWnd, Int32 nCmdShow)")[$_] 
                
            })

        } | % { Add-Type @_ }
        
