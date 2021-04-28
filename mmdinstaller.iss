#define libDir "Z:\lib"
#define binDir "Z:\bin"
#define tutorialDir "Z:\tutorial"

#define MyAppName "MikuMikuDance"
#define MyAppVersion "1.0.0"
#define MyAppURL "https://www.nomkid.github.io/mmdinstaller"
#define MyAppExeName "MikuMikuDance.exe"

[Setup]
AppId={{7ADA7F1D-1F8E-44B9-A98A-8B5F68231ADD}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
ArchitecturesInstallIn64BitMode=x64 ia64
DefaultDirName={pf}\MikuMikuDance
DisableProgramGroupPage=yes
OutputBaseFilename=MMDInstaller
Compression=lzma
SolidCompression=yes
AlwaysRestart=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "tutorials"; Description: "Add LearnMMD tutorials to my Documents folder"; Flags: unchecked
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "{#binDir}\MMD32\*"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion recursesubdirs
Source: "{#binDir}\MMD64\*"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion recursesubdirs

; x86 prerequisites
Source: "{#libDir}\MMD32\vcredist_x86.EXE"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall
Source: "{#libDir}\MMD32\vcredist_x86_vc2008.exe"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall

; x64 prerequisites
Source: "{#libDir}\MMD64\vcredist_x64_vc2008.exe"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall
Source: "{#libDir}\MMD64\vcredist_x64_vc2010.exe"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall

; DirectX runtime
Source: "{#libDir}\directx\*"; DestDir: "{tmp}\directx"; Flags: ignoreversion recursesubdirs deleteafterinstall

; LearnMMD tutorials
Source: "{#tutorialDir}\*"; DestDir: "{commondocs}\MMD Instructions - LearnMMD"; Flags: ignoreversion recursesubdirs; Tasks: tutorials

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

; x86 prerequisites
Filename: "{tmp}\vcredist_x86.EXE"; Parameters: "/Q"; Check: not Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2005 Redist..."
Filename: "{tmp}\vcredist_x86_vc2008.exe"; Parameters: "/Q"; Check: not Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2008 Redist..."

; x64 prerequisites
Filename: "{tmp}\vcredist_x64_vc2008.exe"; Parameters: "/Q"; Check: Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2008 Redist..."
Filename: "{tmp}\vcredist_x64_vc2010.exe"; Parameters: "/Q"; Check: Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2010 Redist..."

; DirectX runtime
Filename: "{tmp}\directx\DXSETUP.EXE"; Parameters: "/silent"; Flags: ; StatusMsg: "Installing DirectX June 2010 Runtime..."