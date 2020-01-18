#define MyJarPluginBasename "de.h-ab.ev3plugin"
#define MyJarPlugin "de.h-ab.ev3plugin_1.7.2.201908011455.jar"
#define MyGCCInstaller "arm-2009q1-203-arm-none-linux-gnueabi.exe"
#define BuildDir "D:\build"
;#define TOOLCHAIN_INCLUDED
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{860CEFBC-72B1-44B3-B725-CCC165E1347B}
AppName=c4ev3
AppVersion=1.0
;AppVerName=c4ev3 1.0
AppPublisher=Embedded Systems Lab, Hochschule Aschaffenburg
AppPublisherURL=http://c4ev3.github.io
AppSupportURL=http://c4ev3.github.io
AppUpdatesURL=http://c4ev3.github.io
DefaultDirName=C:\ev3
DisableDirPage=yes
DefaultGroupName=c4ev3
AllowNoIcons=yes
#ifdef TOOLCHAIN_INCLUDED
OutputBaseFilename=c4ev3-withGCC-setup
#else
OutputBaseFilename=c4ev3-setup
#endif
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Toolchain
#ifdef TOOLCHAIN_INCLUDED
Source: "{#BuildDir}\{#MyGCCInstaller}"; DestDir: "{app}"; AfterInstall: InstallToolchain
#endif
; API
Source: "{#BuildDir}\API\*"; DestDir: "{app}\API"; Flags: ignoreversion recursesubdirs createallsubdirs
; Uploader
Source: "{#BuildDir}\uploader\*"; DestDir: "{app}\uploader"; Flags: ignoreversion recursesubdirs createallsubdirs
; Plugin
Source: "{#BuildDir}\{#MyJarPlugin}"; DestDir: "{app}"; AfterInstall: InstallPlugin

[InstallDelete]
Type: filesandordirs; Name: "{app}\API"
Type: filesandordirs; Name: "{app}\uploader"

[Code]
var
  EclipseDirectory: String;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  setPreviousData(PreviousDataKey, 'EclipseDir', EclipseDirectory);
end;

procedure InstallToolchain;
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{app}\{#MyGCCInstaller}'),'', '', SW_SHOWNORMAL,
              ewWaitUntilTerminated, ResultCode)
  then
      MsgBox('Failed to install toolchain!' + #13#10 +
             SysErrorMessage(ResultCode), mbError, MB_OK);
end;

procedure InstallPlugin;
var
  directory: String;
  chosen: Boolean;
  error: String;
begin
  EclipseDirectory := '';
  error := '';
  directory := ExpandConstant('{pf32}\Eclipse');
  repeat
    chosen := BrowseForFolder(error + 'Please choose your Eclipse Installation directory:',
                    directory,
                    false);
    error := 'Couldn''t detect Eclipse. ' #13;
  until not chosen or DirExists(directory + '\dropins');
  
  if not chosen
  then
       MsgBox('No valid Eclipse directory chosen. Plugin won''t be installed!'
             , mbInformation, MB_OK)
  else
      EclipseDirectory := directory;

      DelTree(directory + ExpandConstant('\dropins\{#MyJarPluginBasename}*.jar'), False, True, True);

      FileCopy(ExpandConstant('{app}\{#MyJarPlugin}'),
               directory + ExpandConstant('\dropins\{#MyJarPlugin}'), false);
end;

procedure UninstallPlugin;
begin
    DeleteFile(EclipseDirectory + ExpandConstant('\dropins\{#MyJarPlugin}'));
end;

function InitializeUninstall: Boolean;
begin
  Result := True;
  EclipseDirectory := GetPreviousData('EclipseDir', '');
  if EclipseDirectory <> '' then
    UninstallPlugin();
end;


[Icons]
Name: "{group}\{cm:UninstallProgram,c4ev3}"; Filename: "{uninstallexe}"
