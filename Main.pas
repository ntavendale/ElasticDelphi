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
  Winapi.Windows, Winapi.Messages, System.IOUtils, System.SysUtils, System.Variants,
  System.Generics.Collections, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, EndpointClient,
  SyslogMessage;

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
    gbBulkUpdates: TGroupBox;
    ebFile: TEdit;
    odMain: TOpenDialog;
    btnFindFile: TButton;
    btnBulkUpdate: TButton;
    procedure btnIndexExistsClick(Sender: TObject);
    procedure btnCreateIndexClick(Sender: TObject);
    procedure btnAddSyslogWithIDClick(Sender: TObject);
    procedure btnUpdateSyslogWithIDClick(Sender: TObject);
    procedure btnAddSyslogWithNoIDClick(Sender: TObject);
    procedure btnFindFileClick(Sender: TObject);
    procedure btnBulkUpdateClick(Sender: TObject);
  private
    { Private declarations }
    procedure FormInit;
    procedure BulkLoad(AList: TSyslogMessageList);
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

procedure TfmMain.BulkLoad(AList: TSyslogMessageList);
var
  LDict: TObjectDictionary<string, TSyslogMessageList>;
  LPair: TPair<string, TSyslogMessageList>;
  LBulk: TStrings;
  LKey: String;
  i: Integer;
  LEndPoint: TEndPointClient;
begin
  LDict := TObjectDictionary<string, TSyslogMessageList>.Create([doOwnsValues]);
  try
    for i := 0 to (AList.Count - 1) do
    begin
      //Use index names as keys, messages for that date go in value list
      LKey := FormatDateTime('YYYYMMDD', AList[i].TimeStamp);
      if not LDict.ContainsKey(LKey) then
      begin
        LDict.Add(LKey, TSyslogMessageList.Create);
      end;
      LDict[LKey].Add( TSyslogMessage.Create(AList[i]) );
    end;

    LBulk := TStringList.Create;
    try
      for LPair in LDict do
      begin
        LBulk.Clear;

        for i := 0 to (LPair.Value.Count - 1) do
        begin
          LBulk.Add('{"index":{}}');
          LBulk.Add(  LPair.Value[i].AsJson );
        end;

        LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, String.Format('%s/Message/_bulk', [LPair.Key] ));
        try
          LEndpoint.Post(LBulk.Text);
          if LEndpoint.StatusCode in [200, 201] then
            memMain.Lines.Add(String.Format('Post %s', [LEndpoint.FullURL ]))
          else
            memMain.Lines.Add(String.Format('Failed Post %s', [LEndpoint.StatusText ]));
        finally
          LEndpoint.Free;
        end;
      end;
    finally
      LBulk.Free;
    end;
  finally
    LDict.Free;
  end;
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
    LSyslog.MessageContent := 'Opps! There''s an emergency!';

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

procedure TfmMain.btnFindFileClick(Sender: TObject);
begin
  if not odMain.Execute then
    EXIT;
  ebFile.Text := odMain.FileName;
end;

procedure TfmMain.btnBulkUpdateClick(Sender: TObject);
var
  LMsgList: TSyslogMessageList;
begin
  if not TFile.Exists(ebFile.Text) then
  begin
    MessageDlg(String.Format('File %s does not exist', [ebFile.Text]), mtError, [mbOK], 0);
    EXIT;
  end;

  LMsgList := TSyslogMessageList.LoadFromFile(ebFile.Text);
  try
    BulkLoad(LMsgList);
  finally
    LMsgList.Free;
  end;
end;

end.
