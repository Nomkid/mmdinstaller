#include <idp.iss>

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
;Source: "{#binDir}\MMD32\*"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion recursesubdirs
;Source: "{#binDir}\MMD64\*"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion recursesubdirs

; 7-Zip for unzipping
Source: "{#libDir}\7za32.exe"; DestDir: "{tmp}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#libDir}\7za64.exe"; DestDir: "{tmp}"; Check: Is64BitInstallMode; Flags: ignoreversion

; Prerequisites
Source: "{#libDir}\MMD32\*"; DestDir: "{tmp}"; Check: not Is64BitInstallMode; Flags: ignoreversion deleteafterinstall recursesubdirs
Source: "{#libDir}\MMD64\*"; DestDir: "{tmp}"; Check: Is64BitInstallMode; Flags: ignoreversion deleteafterinstall recursesubdirs

; DirectX runtime from external server
Source: "{tmp}\dxruntime.zip"; DestDir: "{tmp}"; ExternalSize: 100665519; Flags: external

; LearnMMD tutorials
Source: "{#tutorialDir}\*"; DestDir: "{commondocs}\MMD Instructions - LearnMMD"; Flags: ignoreversion recursesubdirs; Tasks: tutorials

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

; x86 prerequisites
Filename: "{tmp}\vcredist_x86.EXE"; Parameters: "/Q"; Check: (not vc2005Installed) and (not Is64BitInstallMode); Flags: runminimized; StatusMsg: "Installing Visual C++ 2005 Redist..."
Filename: "{tmp}\vcredist_x86_vc2008.exe"; Parameters: "/Q"; Check: (not vc2008x86Installed) and (not Is64BitInstallMode); Flags: runminimized; StatusMsg: "Installing Visual C++ 2008 Redist..."

; x64 prerequisites
Filename: "{tmp}\vcredist_x64_vc2008.exe"; Parameters: "/Q"; Check: (not vc2008x64Installed) and Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2008 Redist..."
Filename: "{tmp}\vcredist_x64_vc2010.exe"; Parameters: "/Q"; Check: (not vc2010Installed) and Is64BitInstallMode; Flags: runminimized; StatusMsg: "Installing Visual C++ 2010 Redist..."

; DirectX runtime
Filename: "{tmp}\directx\DXSETUP.EXE"; Parameters: "/silent"; Flags: ; BeforeInstall: BeforeDXInstall; StatusMsg: "Installing DirectX June 2010 Runtime..."

[Code]
procedure InitializeWizard();
begin
  idpAddFileSize('http://https://github.com/Nomkid/mmdinstaller/releases/download/v1.0.0/dxruntime.zip', ExpandConstant('{tmp}\dxruntime.zip'), 100665519);

  idpDownloadAfter(wpReady);
end;

procedure DoUnzip(source: String; targetdir: String);
var 
    unzipTool: String;
    ReturnCode: Integer;
begin
  source := ExpandConstant(source);

  if FileExists(ExpandConstant('{tmp}\7za32.exe'))
  then unzipTool := ExpandConstant('{tmp}\7za32.exe')
  else unzipTool := ExpandConstant('{tmp}\7za64.exe');

  if not FileExists(unzipTool)
  then MsgBox('UnzipTool not found: ' + unzipTool, mbError, MB_OK)
  else if not FileExists(source)
  then MsgBox('File was not found while trying to unzip: ' + source, mbError, MB_OK)
  else begin
     if Exec(unzipTool, ' x "' + source + '" -o"' + targetdir + '" -y',
         '', SW_HIDE, ewWaitUntilTerminated, ReturnCode) = false
     then begin
       MsgBox('Unzip failed:' + source, mbError, MB_OK)
     end;
  end;
end;

procedure BeforeDXInstall;
begin
  DoUnzip(ExpandConstant('{tmp}\dxruntime.zip'), ExpandConstant('{tmp}'));
end;

function vc2005Installed: boolean;
begin
  result := RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{710f4c1c-cc18-4c49-8cbf-51240c89a1a2}');
end;

function vc2008x86Installed: boolean;
begin
  result := RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F}');
end;

function vc2008x64Installed: boolean;
begin
  result := RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}');
end;

function vc2010Installed: boolean;
begin
  result := RegKeyExists(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D8E6291-B0D5-35EC-8441-6616F567A0F7}');
end;