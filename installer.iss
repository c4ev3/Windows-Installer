; Leave these in as they are overridden from Makefile
#define JAR_PLUGIN_BASENAME     "de.h-ab.ev3plugin"
#define JAR_PLUGIN              "de.h-ab.ev3plugin_1.7.2.201908011455.jar"
;#define GCC_INSTALLER          "arm-2009q1-203-arm-none-linux-gnueabi.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{860CEFBC-72B1-44B3-B725-CCC165E1347B}
AppName=c4ev3
AppVersion=v2020.01.0
;AppVerName=c4ev3 1.0
AppPublisher=Embedded Systems Lab, Hochschule Aschaffenburg
AppPublisherURL=http://c4ev3.github.io
AppSupportURL=http://c4ev3.github.io
AppUpdatesURL=http://c4ev3.github.io
DefaultDirName=C:\ev3
DisableDirPage=yes
DefaultGroupName=c4ev3
AllowNoIcons=yes
Compression=lzma
SolidCompression=yes
#ifdef GCC_INSTALLER
OutputBaseFilename=c4ev3-withGCC-setup
#else
OutputBaseFilename=c4ev3-setup
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Toolchain
#ifdef GCC_INSTALLER
Source: "{#GCC_INSTALLER}"; DestDir: "{app}"; AfterInstall: InstallToolchain
#endif
; API
Source: "artifacts\API\*"; DestDir: "{app}\API"; Flags: ignoreversion recursesubdirs createallsubdirs
; Uploader
Source: "artifacts\ev3duder\*"; DestDir: "{app}\uploader"; Flags: ignoreversion recursesubdirs createallsubdirs
; Plugin
Source: "artifacts\{#JAR_PLUGIN}"; DestDir: "{app}"; AfterInstall: InstallPlugin

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

#ifdef GCC_INSTALLER
procedure InstallToolchain;
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{app}\{#GCC_INSTALLER}'),'', '', SW_SHOWNORMAL,
              ewWaitUntilTerminated, ResultCode)
  then
      MsgBox('Failed to install toolchain!' + #13#10 +
             SysErrorMessage(ResultCode), mbError, MB_OK);
end;
#endif

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

      DelTree(directory + ExpandConstant('\dropins\{#JAR_PLUGIN_BASENAME}*.jar'), False, True, True);

      FileCopy(ExpandConstant('{app}\{#JAR_PLUGIN}'),
               directory + ExpandConstant('\dropins\{#JAR_PLUGIN}'), false);
end;

procedure UninstallPlugin;
begin
    DeleteFile(EclipseDirectory + ExpandConstant('\dropins\{#JAR_PLUGIN}'));
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
