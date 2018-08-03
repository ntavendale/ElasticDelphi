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
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, EndpointClient;

const
  ENDPOINT = 'http://127.0.0.1';
  PORT = 9200;
type
  TfmMain = class(TForm)
    gbIndexExists: TGroupBox;
    ebCheckIndex: TEdit;
    btnIndexExists: TButton;
    gbCreateIndex: TGroupBox;
    ebCreateIndex: TEdit;
    btnCreateIndex: TButton;
    memMain: TMemo;
    GroupBox2: TGroupBox;
    btnAddSyslogWithID: TButton;
    btnUpdateSyslogWithID: TButton;
    btnAddSyslogWithNoID: TButton;
    gbBulkUpdates: TGroupBox;
    btnBulkUpdateSingleIndex: TButton;
    btnBulkUpdateMultipleIndex: TButton;
    procedure btnIndexExistsClick(Sender: TObject);
    procedure btnCreateIndexClick(Sender: TObject);
    procedure btnAddSyslogWithIDClick(Sender: TObject);
    procedure btnUpdateSyslogWithIDClick(Sender: TObject);
    procedure btnAddSyslogWithNoIDClick(Sender: TObject);
    procedure btnBulkUpdateSingleIndexClick(Sender: TObject);
    procedure btnBulkUpdateMultipleIndexClick(Sender: TObject);
  private
    { Private declarations }
    procedure FormInit;
    procedure CreateIndex(AIndexName: String);
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
  ebCheckIndex.Text := FormatDateTime('YYYY-MM-DD', Date);
  ebCreateIndex.Text := FormatDateTime('YYYY-MM-DD', Date);
end;

procedure TfmMain.CreateIndex(AIndexName: String);
var
  LEndpoint: TEndpointClient;
  LIndexDetail: TStringList;
begin
  LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, AIndexName);
  try
    LIndexDetail := TStringList.Create;
    try
      LIndexDetail.Add(('{                                                          ').Trim);
      LIndexDetail.Add(('    "settings" : {                                         ').Trim);
      LIndexDetail.Add(('                    "index" : {                            ').Trim);
      LIndexDetail.Add(('                                 "number_of_shards" : 5,   ').Trim);
      LIndexDetail.Add(('                                 "number_of_replicas" : 2  ').Trim);
      LIndexDetail.Add(('                               }                           ').Trim);
      LIndexDetail.Add(('                  }                                        ').Trim);
      LIndexDetail.Add(('}                                                          ').Trim);

      LEndpoint.Put(LIndexDetail.Text);
      memMain.Lines.Add(String.Format('Put %s', [LEndpoint.FullURL ]));
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

procedure TfmMain.btnIndexExistsClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
  LResult: Integer;
begin
  LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, ebCheckIndex.Text);
  try
    Screen.Cursor := crHourglass;
    try
      LResult := LEndpoint.Head;
      //If we get a 200 then the index exists!
      if 200 = LResult then
        memMain.Lines.Add(String.Format('%s exists! (%d)', [LEndpoint.FullURL, LResult]))
      else
        //Get a 404 and it's not there.
        memMain.Lines.Add(String.Format('%s does not exist! (%d)', [LEndpoint.FullURL, LResult]))
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    LEndpoint.Free;
  end;
end;

procedure TfmMain.btnCreateIndexClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutResult: String;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                                          ').Trim);
    LJson.Append(('    "settings" : {                                         ').Trim);
    LJson.Append(('                    "index" : {                            ').Trim);
    LJson.Append(('                                 "number_of_shards" : 5,   ').Trim);
    LJson.Append(('                                 "number_of_replicas" : 2  ').Trim);
    LJson.Append(('                               }                           ').Trim);
    LJson.Append(('                  }                                        ').Trim);
    LJson.Append(('}                                                          ').Trim);
    LEndPoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, ebCreateIndex.Text);
    try
      Screen.Cursor := crHourglass;
      try
        LPutResult := LEndpoint.Put(LJson.ToString);
      finally
        Screen.Cursor := crDefault;
      end;

      memMain.Lines.Add(String.Format('Put %s to %s', [LJson.ToString, LEndpoint.FullURL ]));
      if 200 = LEndpoint.StatusCode then
        memMain.Lines.Add(String.Format('%s created!', [LEndpoint.FullURL]))
      else
      begin
        memMain.Lines.Add(String.Format('%s creation failed!', [LEndpoint.FullURL]));
        memMain.Lines.Add(LPutResult);
      end;
    finally
      LEndpoint.Free;
    end;

  finally
    LJson.Free;
  end;
end;

procedure TfmMain.btnAddSyslogWithIDClick(Sender: TObject);
var
  LJSon: TStringBuilder;
  LEndpoint: TEndpointClient;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                             ').Trim);
    LJson.Append(('  "type":"BSD",                               ').Trim);
    LJson.Append(('  "facility":"UserLevel",                     ').Trim);
    LJson.Append(('  "severity":"Debug",                         ').Trim);
    LJson.Append(('  "timeStamp":"2018-07-01T18:24:02.662Z",     ').Trim);
    LJson.Append(('  "host":"localhost",                         ').Trim);
    LJson.Append(('  "process":"MyProcess",                      ').Trim);
    LJson.Append(('  "processId":99,                             ').Trim);
    LJson.Append(('  "text":"This is a test message with an ID!" ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, '2018-07-01/message/DocID01');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Put(LJson.ToString); //Add with a PUT when we supply Document ID (the DocID01 above).
      finally
        Screen.Cursor := crDefault;
      end;
      //200 = OK
      //201 = Created
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('Put %s: %s', [LEndpoint.FullURL, LJson.ToString ]))
      else
        memMain.Lines.Add(String.Format('Failed Put %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;

  finally
    LJson.Free;
  end;
end;

procedure TfmMain.btnUpdateSyslogWithIDClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndpoint: TEndpointClient;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                             ').Trim);
    LJson.Append(('  "type":"BSD",                               ').Trim);
    LJson.Append(('  "facility":"UserLevel",                     ').Trim);
    LJson.Append(('  "severity":"Debug",                         ').Trim);
    LJson.Append(('  "timeStamp":"2018-07-01T18:24:02.662Z",     ').Trim);
    LJson.Append(('  "host":"localhost",                         ').Trim);
    LJson.Append(('  "process":"MyProcess",                      ').Trim);
    LJson.Append(('  "processId":99,                             ').Trim);
    LJson.Append(('  "text":"This is an updated test message with an ID!" ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, '2018-07-01/message/DocID01');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Put(LJson.ToString); //Update with a PUT
      finally
        Screen.Cursor := crDefault;
      end;
      //200 = OK
      //201 = Created
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('Put %s: %s', [LEndpoint.FullURL, LJson.ToString ]))
      else
        memMain.Lines.Add(String.Format('Failed Put %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;
  finally
    LJson.Free;
  end;
end;

procedure TfmMain.btnAddSyslogWithNoIDClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndpoint: TEndpointClient;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                             ').Trim);
    LJson.Append(('  "type":"BSD",                               ').Trim);
    LJson.Append(('  "facility":"SystemDaemon",                   ').Trim);
    LJson.Append(('  "severity":"Emergency",                     ').Trim);
    LJson.Append(('  "timeStamp":"2018-07-02T18:24:02.662Z",     ').Trim);
    LJson.Append(('  "host":"localhost",                         ').Trim);
    LJson.Append(('  "process":"MyProcess",                      ').Trim);
    LJson.Append(('  "processId":99,                             ').Trim);
    LJson.Append(('  "text":"Opps! We have an emergency!"       ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, '2018-07-02/message');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString); //To autogenerate ID we use POST insted of PUT
      finally
        Screen.Cursor := crDefault;
      end;
      //200 = OK
      //201 = Created
      if LEndpoint.StatusCode in [200, 201] then
        memMain.Lines.Add(String.Format('POST %s: %s', [LEndpoint.FullURL, LJson.ToString ]))
      else
        memMain.Lines.Add(String.Format('Failed POST %s', [LEndpoint.StatusText ]));
    finally
      LEndpoint.Free;
    end;

  finally
    LJson.Free;
  end;
end;

procedure TfmMain.btnBulkUpdateSingleIndexClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndpoint: TEndpointClient;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{"type":"BSD","facility":"MailSystem","severity":"Critical","timeStamp":"2018-06-14T06:00:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,' + '"text":"EVID:0018 Reconnaissance activity detected 111.148.118.9:40083 -> 161.200.1.9:443 TCP"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Error","timeStamp":"2018-06-14T06:05:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0043 Host: 172.10.1.14 has a vulnerability on port: 80 protocol: http"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Critical","timeStamp":"2018-06-14T06:10:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0042 120.213.104.204 accessed url: http:\\/\\/Website001.com at UserPC5"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SystemDaemon","severity":"Emergency","timeStamp":"2018-06-14T06:15:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0024 Accepted packet 66.2.30.3:40076 -> WebServer2.acme.com:1352 TCP"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"Kernel","severity":"Emergency","timeStamp":"2018-06-14T06:20:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0000 Server2: miscellaneous log message"}' + #13#10);

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, '20180614/message/_bulk');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString); //To autogenerate ID we use POST insted of PUT
        if LEndpoint.StatusCode in [200, 201] then
          memMain.Lines.Add(String.Format('POST %s: %s', [LEndpoint.FullURL, LJson.ToString ]))
        else
          memMain.Lines.Add(String.Format('Failed POST %s', [LEndpoint.StatusText ]));
      finally
        Screen.Cursor := crDefault;
      end;
    finally
      LEndpoint.Free;
    end;

  finally
    LJson.Free;
  end;
end;

procedure TfmMain.btnBulkUpdateMultipleIndexClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndpoint: TEndpointClient;
begin
  LJson := TStringBuilder.Create;
  try
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{"type":"BSD","facility":"MailSystem","severity":"Critical","timeStamp":"2018-07-14T06:00:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,' + '"text":"EVID:0018 Reconnaissance activity detected 111.148.118.9:40083 -> 161.200.1.9:443 TCP"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Error","timeStamp":"2018-07-14T06:05:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0043 Host: 172.10.1.14 has a vulnerability on port: 80 protocol: http"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Critical","timeStamp":"2018-07-14T06:10:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0042 120.213.104.204 accessed url: http:\\/\\/Website001.com at UserPC5"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-15", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SystemDaemon","severity":"Emergency","timeStamp":"2018-07-15T06:15:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0024 Accepted packet 66.2.30.3:40076 -> WebServer2.acme.com:1352 TCP"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-15", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"Kernel","severity":"Emergency","timeStamp":"2018-07-15T06:20:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"text":"EVID:0000 Server2: miscellaneous log message"}' + #13#10);

    LEndpoint := TEndpointClient.Create(ENDPOINT, PORT, String.Empty,String.Empty, '20180614/message/_bulk');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString); //To autogenerate ID we use POST insted of PUT
        if LEndpoint.StatusCode in [200, 201] then
          memMain.Lines.Add(String.Format('POST %s: %s', [LEndpoint.FullURL, LJson.ToString ]))
        else
          memMain.Lines.Add(String.Format('Failed POST %s', [LEndpoint.StatusText ]));
      finally
        Screen.Cursor := crDefault;
      end;
    finally
      LEndpoint.Free;
    end;

  finally
    LJson.Free;
  end;
end;

end.
