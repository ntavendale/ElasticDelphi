{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2018 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{             Non Commerical Use Permitted              }
{*******************************************************}
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EndpointClient;

const
  ENDPOINT = 'http://127.0.0.1';
  PORT = 9200;
type
  TfmMain = class(TForm)
    gbIndexExists: TGroupBox;
    ebCheckIndex: TEdit;
    btnIndexExists: TButton;
    lbResult: TLabel;
    procedure btnIndexExistsClick(Sender: TObject);
  private
    { Private declarations }
    procedure FormInit;
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

constructor TfmMain.Create(Aowner: TComponent);
begin
  inherited Create(AOwner);
  FormInit;
end;

procedure TfmMain.FormInit;
begin
  ebCheckIndex.Text := FormatDateTime('YYYYMMDD', Date);
  lbResult.Caption := String.Empty;
end;

procedure TfmMain.btnIndexExistsClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
begin
  LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, ebCheckIndex.Text);
  try
    if 200 = LEndpoint.Head then
      lbResult.Caption := String.Format('%s exists!', [LEndpoint.FullURL])
    else
      lbResult.Caption := String.Format('%s does not exist!', [LEndpoint.FullURL])
  finally
    LEndpoint.Free;
  end;
end;

end.
