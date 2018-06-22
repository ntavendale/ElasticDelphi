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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  EndpointClient, SyslogMessage;

const
  ENDPOINT = 'http://127.0.0.1';
  PORT = 9200;
type
  TfmMain = class(TForm)
    gbIndexExists: TGroupBox;
    ebCheckIndex: TEdit;
    btnIndexExists: TButton;
    GroupBox1: TGroupBox;
    ebCreateIndex: TEdit;
    btnCreateIndex: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ebCreateShards: TEdit;
    ebCreateReplicas: TEdit;
    Label3: TLabel;
    memMain: TMemo;
    GroupBox2: TGroupBox;
    btnAddSyslogWithID: TButton;
    btnUpdateSyslogWithID: TButton;
    btnAddSyslogWithNoID: TButton;
    procedure btnIndexExistsClick(Sender: TObject);
    procedure btnCreateIndexClick(Sender: TObject);
    procedure btnAddSyslogWithIDClick(Sender: TObject);
    procedure btnUpdateSyslogWithIDClick(Sender: TObject);
    procedure btnAddSyslogWithNoIDClick(Sender: TObject);
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
end;

procedure TfmMain.btnIndexExistsClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
begin
  LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, ebCheckIndex.Text);
  try
    if 200 = LEndpoint.Head then
      memMain.Lines.Add(String.Format('%s exists!', [LEndpoint.FullURL]))
    else
    memMain.Lines.Add(String.Format('%s does not exist!', [LEndpoint.FullURL]))
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
      memMain.Lines.Add(String.Format('Put %s to %s', [LIndexDetail.ToJSON, LEndpoint.FullURL ]));
      if 200 = LEndpoint.StatusCode then
        memMain.Lines.Add(String.Format('%s created!', [LEndpoint.FullURL]))
      else
        memMain.Lines.Add(String.Format('%s creation failed!', [LEndpoint.FullURL]))
    finally
      LIndexDetail.Free;
    end;

  finally
    LEndpoint.Free;
  end;
end;

procedure TfmMain.btnAddSyslogWithIDClick(Sender: TObject);
var
  LSyslog: TSyslogMessage;
  LEndpoint: TEndpointClient;
begin
  LSyslog := TSyslogMessage.Create;
  try
    LSyslog.DocumentID := 'DocID01';
    LSyslog.MessageType := 'BSD';
    LSyslog.Facility := 'UserLevel';
    LSyslog.Severity := 'Debug';
    LSyslog.TimeStamp := Now;
    LSyslog.Host := 'localhost';
    LSyslog.Process := 'MyProcess';
    LSyslog.ProcessID := 99;
    LSyslog.MessageContent := 'This is a test message with an ID!';

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, String.Format('%s/message/%s', [FormatDateTime('YYYYMMDD', LSyslog.TimeStamp), LSyslog.DocumentID]));
    try
      LEndpoint.Put(LSyslog.AsJson);
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('Put %s: %s', [LEndpoint.FullURL, LSyslog.AsJson ]))
      else
        memMain.Lines.Add(String.Format('Failed Put %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;

  finally
    LSyslog.Free;
  end;
end;

procedure TfmMain.btnUpdateSyslogWithIDClick(Sender: TObject);
var
  LSyslog: TSyslogMessage;
  LEndpoint: TEndpointClient;
begin
  LSyslog := TSyslogMessage.Create;
  try
    LSyslog.DocumentID := 'DocID01';
    LSyslog.MessageType := 'BSD';
    LSyslog.Facility := 'UserLevel';
    LSyslog.Severity := 'Debug';
    LSyslog.TimeStamp := Now;
    LSyslog.Host := 'localhost';
    LSyslog.Process := 'MyProcess';
    LSyslog.ProcessID := 100;
    LSyslog.MessageContent := 'This is an updated test message with an ID!';

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, String.Format('%s/message/%s', [FormatDateTime('YYYYMMDD', LSyslog.TimeStamp), LSyslog.DocumentID]));
    try
      LEndpoint.Put(LSyslog.AsJson);
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('Put %s: %s', [LEndpoint.FullURL, LSyslog.AsJson ]))
      else
        memMain.Lines.Add(String.Format('Failed Put %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;

  finally
    LSyslog.Free;
  end;
end;

procedure TfmMain.btnAddSyslogWithNoIDClick(Sender: TObject);
var
  LSyslog: TSyslogMessage;
  LEndpoint: TEndpointClient;
begin
  LSyslog := TSyslogMessage.Create;
  try
    LSyslog.MessageType := 'BSD';
    LSyslog.Facility := 'SystemDaemon';
    LSyslog.Severity := 'Emergency';
    LSyslog.TimeStamp := Now;
    LSyslog.Host := 'localhost';
    LSyslog.Process := 'MyProcess';
    LSyslog.ProcessID := 100;
    LSyslog.MessageContent := 'Opps! There''s an emergency!';;

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, String.Format('%s/message', [FormatDateTime('YYYYMMDD', LSyslog.TimeStamp)]));
    try
      LEndpoint.Post(LSyslog.AsJson); //To autogenerate ID we use POST insted of PUT
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('POST %s: %s', [LEndpoint.FullURL, LSyslog.AsJson ]))
      else
        memMain.Lines.Add(String.Format('Failed POST %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;

  finally
    LSyslog.Free;
  end;
end;

end.
