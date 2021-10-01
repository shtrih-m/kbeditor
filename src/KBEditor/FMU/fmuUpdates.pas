unit fmuUpdates;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, ExtCtrls,
  //
  Psock, NMHttp,
  // This
  untVInfo, Utils, Scanf, SizeableForm, LogFile;

const
  WM_SENDREQUEST = WM_USER + 1;

type
  { TfmUpdates }

  TfmUpdates = class(TSizeableForm)
    btnOK: TButton;
    NMHTTP: TNMHTTP;
    lblText: TLabel;
    lblCurVersion: TLabel;
    lblServerVersion: TLabel;
    lblUrl: TLabel;
    Label1: TLabel;
    ErrorImage: TImage;
    LabelError: TLabel;
    procedure GetFileSucceed(Cmd: CmdType);
    procedure GetFileFailed(Cmd: CmdType);
    procedure ConnectionFailed(Sender: TObject);
    procedure GetUpdateFile;
    procedure lblUrlClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FilePath: string;
    SilentMode: Boolean;
    function GetUpdateText: string;
    function GetVersionFromBody: string;
    function NewVersionAvaliable: Boolean;
    procedure Clear;
  public
    procedure CheckForUpdates(UpdateFilePath: string; Silent: Boolean);
  end;

var
  fmUpdates: TfmUpdates;

implementation

{$R *.DFM}

resourcestring
  MsgUpdateFileNotFound         = 'Update file not found on server';
  MsgUpdateFileCorrupted        = 'Update file corrupted';
  MsgChanges                    = 'Changes in new version:';
  MsgGotoURL                    = 'To download new version follow this link';
  MsgNewVersionAvailable        = 'New program version is available.';
  MsgCurrentVersion             = 'Current version: ';
  MsgAppVersion                 = 'Installed program version: ';
  MsgNoUpdatesAvailable         = 'You have last program version';
  MsgNoConnectionToServer       = 'Update server is unavailable';


{ TfmUpdates }

procedure TfmUpdates.GetFileFailed(Cmd: CmdType);
begin
  lblText.Caption := MsgUpdateFileNotFound;
end;

function TfmUpdates.GetVersionFromBody: string;
begin
  Result := Copy(NMHTTP.Body, Pos('=', NMHTTP.Body) + 1, 7);
end;

function TfmUpdates.NewVersionAvaliable: Boolean;
var
  CurVersion: TVersionInfo;
  ServerVersion: TVersionInfo;
begin
  Result := False;
  if pos('version=', NMHTTP.Body) = 0 then
  begin
    raise Exception.Create(MsgUpdateFileCorrupted);
  end;

  Sscanf(GetVersionFromBody, '%d.%d.%d.%d', [@ServerVersion.MajorVersion,
    @ServerVersion.MinorVersion, @ServerVersion.ProductRelease,
    @ServerVersion.ProductBuild]);
  CurVersion := GetFileVersionInfo;
  if CompareVersions(ServerVersion, CurVersion) = 2 then Result := True;
end;

function TfmUpdates.GetUpdateText: string;
begin
  Result := MsgNewVersionAvailable + #10#13#10#13;
  Result := Result + MsgChanges;
  Result := Result + Copy(NMHTTP.Body, Pos('=', NMHTTP.Body) + 8, Length(NMHTTP.Body)) +
  #10#13 + MsgGotoURL;
end;

procedure TfmUpdates.GetFileSucceed(Cmd: CmdType);
begin
  try
    lblCurVersion.Caption := MsgAppVersion + GetFileVersionInfoStr;
    lblCurVersion.Visible := True;
    lblServerVersion.Caption := MsgCurrentVersion + GetVersionFromBody;
    lblServerVersion.Visible := True;
    lblText.Visible := True;
    if NewVersionAvaliable then
    begin
      lblText.Caption := GetUpdateText;
      lblUrl.Visible := True;
      if SilentMode then Show;
    end else
    begin
      lblText.Caption := MsgNoUpdatesAvailable;
      lblUrl.Visible := False;
    end;
  except
    On E: Exception do
      lblText.Caption := E.Message;
  end;
end;

procedure TfmUpdates.GetUpdateFile;
var
  AppName: string;
  // http://support.shtrih-m.ru/data/SoftUpdates/KBEditor.txt
begin
  Logger.Debug('TfmUpdates.GetUpdateFile');

  AppName := Copy(Application.ExeName,
    Length(ExtractFilePath(Application.ExeName)) + 1, Length(Application.ExeName));
  AppName := GetFileName(AppName);
  try
    NMHTTP.Get('http://support.shtrih-m.ru/' + FilePath + AppName + '.txt');
    Logger.Debug('TfmUpdates.GetUpdateFile: OK');
  except
    on E: Exception do
    begin
      Logger.Error('TfmUpdates.GetUpdateFile: ' + E.Message);
    end;
  end;
end;

procedure TfmUpdates.ConnectionFailed(Sender: TObject);
begin
  lblServerVersion.Visible := False;
  lblText.Visible := False;
  lblCurVersion.Visible := False;
  ErrorImage.Visible := True;
  LabelError.Visible := True;
  LabelError.Caption := MsgNoConnectionToServer;
end;

procedure TfmUpdates.lblUrlClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(),'open', PChar(lblUrl.Caption),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfmUpdates.CheckForUpdates(UpdateFilePath: string;
  Silent: Boolean);
begin
  SilentMode := Silent;
  FilePath := UpdateFilePath;
  Clear;
  if not SilentMode then Show;
  GetUpdateFile;
end;

procedure TfmUpdates.Clear;
begin
  ErrorImage.Visible := False;
  LabelError.Visible := False;
  lblUrl.Visible := False;
  lblServerVersion.Visible := False;
  lblText.Visible := False;
  lblCurVersion.Visible := False;
end;

procedure TfmUpdates.btnOKClick(Sender: TObject);
begin
  Hide;
end;

end.
