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
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, EndpointClient;

const
  ENDPOINT = 'http://127.0.0.1';
  PORT = 9200;
type
  TfmMain = class(TForm)
    gbIndexExists: TGroupBox;
    ebCheckIndex: TEdit;
    btnIndexExists: TButton;
    lbResult: TLabel;
    GroupBox1: TGroupBox;
    lbCreateResult: TLabel;
    ebCreateIndex: TEdit;
    btnCreateIndex: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ebCreateShards: TEdit;
    ebCreateReplicas: TEdit;
    Label3: TLabel;
    procedure btnIndexExistsClick(Sender: TObject);
    procedure btnCreateIndexClick(Sender: TObject);
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
  ebCreateIndex.Text := FormatDateTime('YYYYMMDD', Date);
  ebCreateShards.Text := '5';
  ebCreateReplicas.Text := '1';
  lbResult.Caption := String.Empty;
  lbCreateResult.Caption := String.Empty;
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

procedure TfmMain.btnCreateIndexClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
  LSettings, LIndexDetail: TJsonObject;
begin
  LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, ebCreateIndex.Text);
  try
    LIndexDetail := TJsonObject.Create;
    try
      LSettings := TJsonObject.Create;
      LSettings.AddPair('number_of_shards', TJsonNumber.Create(StrToIntDef(ebCreateShards.Text, 5)));
      LSettings.AddPair('number_of_replicas', TJsonNumber.Create(StrToIntDef(ebCreateReplicas.Text, 1)));
      LIndexDetail.AddPair('settings', LSettings);

      LEndpoint.Put(LIndexDetail.ToJSON);
      if 200 = LEndpoint.StatusCode then
        lbCreateResult.Caption := String.Format('%s created!', [LEndpoint.FullURL])
      else
        lbCreateResult.Caption := String.Format('%s creation failed!', [LEndpoint.FullURL])
    finally
      LIndexDetail.Free;
    end;

  finally
    LEndpoint.Free;
  end;
end;

end.
