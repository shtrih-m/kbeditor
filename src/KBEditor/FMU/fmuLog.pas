unit fmuLog;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TB2Dock, TB2ToolWindow,
  // This
  SizeableForm;

type
  TfmLog = class(TSizeableForm)
    TBToolWindow1: TTBToolWindow;
    LogMemo: TMemo;
  end;

var
  fmLog: TfmLog;

implementation

{$R *.DFM}

end.
