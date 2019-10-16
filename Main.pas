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
  Vcl.ComCtrls;

const
  ES_HOST = 'http://192.168.116.120';
  //ES_HOST = 'http://127.0.0.1';

type
  TfmMain = class(TForm)
    memMain: TMemo;
    pcElastic: TPageControl;
    tsBasics: TTabSheet;
    gbIndexExists: TGroupBox;
    ebCheckIndex: TEdit;
    btnIndexExists: TButton;
    gbCreateIndex: TGroupBox;
    ebCreateIndex: TEdit;
    btnCreateIndex: TButton;
    GroupBox2: TGroupBox;
    btnAddSyslogWithID: TButton;
    btnUpdateSyslogWithID: TButton;
    btnAddSyslogWithNoID: TButton;
    btnDelete: TButton;
    gbBulkUpdates: TGroupBox;
    btnBulkUpdateSingleIndex: TButton;
    btnBulkUpdateMultipleIndex: TButton;
    tsCustomMapping: TTabSheet;
    gbIndexThenMapping: TGroupBox;
    btnPutIndex: TButton;
    btnPutTextMapping: TButton;
    btnTextKeywordData: TButton;
    odBulk: TOpenDialog;
    btnAddFile: TButton;
    btnPutKeyWordMapping: TButton;
    cbIndexName: TComboBox;
    gbTemplate: TGroupBox;
    ebIndexMask: TEdit;
    Label1: TLabel;
    btnTemplate: TButton;
    procedure btnIndexExistsClick(Sender: TObject);
    procedure btnCreateIndexClick(Sender: TObject);
    procedure btnAddSyslogWithIDClick(Sender: TObject);
    procedure btnUpdateSyslogWithIDClick(Sender: TObject);
    procedure btnAddSyslogWithNoIDClick(Sender: TObject);
    procedure btnBulkUpdateSingleIndexClick(Sender: TObject);
    procedure btnBulkUpdateMultipleIndexClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPutIndexClick(Sender: TObject);
    procedure btnPutTextMappingClick(Sender: TObject);
    procedure btnTextKeywordDataClick(Sender: TObject);
    procedure btnAddFileClick(Sender: TObject);
    procedure btnPutKeyWordMappingClick(Sender: TObject);
    procedure btnTemplateClick(Sender: TObject);
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
  Self.Caption := String.Format('Elastic Delphi. ES Host: %s', [ES_HOST]);
  FormInit;
end;

procedure TfmMain.FormInit;
begin
  ebCheckIndex.Text := FormatDateTime('YYYY-MM-DD', Date);
  ebCreateIndex.Text := FormatDateTime('YYYY-MM-DD', Date);
  pcElastic.ActivePageIndex := 0;
  cbIndexName.ItemIndex := 0;
end;

procedure TfmMain.CreateIndex(AIndexName: String);
var
  LEndpoint: TEndpointClient;
  LIndexDetail: TStringList;
begin
  LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, AIndexName);
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
  LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, ebCheckIndex.Text);
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
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                                          ').Trim);
    LJson.Append(('    "settings" : {                                         ').Trim);
    LJson.Append(('                    "index" : {                            ').Trim);
    LJson.Append(('                                 "number_of_shards" : 5,   ').Trim); //5 is default
    LJson.Append(('                                 "number_of_replicas" : 0  ').Trim); //2 is default but we use 0 here since we have only one node.
    LJson.Append(('                               }                           ').Trim);
    LJson.Append(('                  }                                        ').Trim);
    LJson.Append(('}                                                          ').Trim);
    LEndPoint := TEndpointClient.Create('http://127.0.0.1', 9200, String.Empty, String.Empty, ebCreateIndex.Text);
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
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
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
    LJson.Append(('  "logMessage":"This is a test message with an ID!" ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '2018-07-01/message/DocID01');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Put(LJson.ToString); //Add with a PUT when we supply Document ID (the "DocID01" in the above URL).
      finally
        Screen.Cursor := crDefault;
      end;
      //200 = OK (If it allready exists)
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
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
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
    LJson.Append(('  "logMessage":"This is an updated test message with an ID!" ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '2018-07-01/message/DocID01');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Put(LJson.ToString); //Update with a PUT
      finally
        Screen.Cursor := crDefault;
      end;
      //200 = OK (If it allready exists)
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
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
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
    LJson.Append(('  "logMessage":"Opps! We have an emergency!"  ').Trim);
    LJson.Append(('}                                             ').Trim);

    LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '2018-07-02/message');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString); //To autogenerate ID we use POST insted of PUT
      finally
        Screen.Cursor := crDefault;
      end;
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
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    //Index and type information will be empty since we specify it in the resource we are posting to
    //but we still need to have that lkine present.
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{"type":"BSD","facility":"MailSystem","severity":"Critical","timeStamp":"2018-06-14T06:00:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,' + '"logMessage":"EVID:0018 Reconnaissance activity detected 111.148.118.9:40083 -> 161.200.1.9:443 TCP"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Error","timeStamp":"2018-06-14T06:05:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0043 Host: 172.10.1.14 has a vulnerability on port: 80 protocol: http"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Critical","timeStamp":"2018-06-14T06:10:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,' + '"logMessage":"EVID:0042 120.213.104.204 accessed url: http:\/\/Website001.com at UserPC5"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SystemDaemon","severity":"Emergency","timeStamp":"2018-06-14T06:15:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0024 Accepted packet 66.2.30.3:40076 -> WebServer2.acme.com:1352 TCP"}' + #13#10);
    LJson.Append('{"index":{}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"Kernel","severity":"Emergency","timeStamp":"2018-06-14T06:20:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0000 Server2: miscellaneous log message"}' + #13#10);

    //Use index and type here since it is a single index
    LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '2018-06-14/message/_bulk');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString);
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
    //Index and type information will be specified on each line since we are
    //updating multiple indexes with a single POST
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{"type":"BSD","facility":"MailSystem","severity":"Critical","timeStamp":"2018-07-14T06:00:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,' + '"logMessage":"EVID:0018 Oh what a lovely day!"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Error","timeStamp":"2018-07-14T06:05:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0043 Oh what a lovely car!"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-14", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SysLogInternal","severity":"Critical","timeStamp":"2018-07-14T06:10:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0042 111.148.118.9 accessed url: http:\/\/Website001.com at UserPC5"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-15", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"SystemDaemon","severity":"Emergency","timeStamp":"2018-07-15T06:15:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0024 Accepted packet 66.2.30.3:40076 -> WebServer2.acme.com:1352 TCP"}' + #13#10);
    LJson.Append('{"index":{"_index":"2018-06-15", "_type":"message"}}' + #13#10);
    LJson.Append('{ "type":"BSD","facility":"Kernel","severity":"Emergency","timeStamp":"2018-07-15T06:20:00.000Z","host":"192.168.8.1","process":"SysLogSimSvc","processId":2559,"logMessage":"EVID:0000 Server2: miscellaneous log message"}' + #13#10);

    //Just use _bulk endpoint since indexes and types specified for each document
    LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '_bulk');
    try
      Screen.Cursor := crHourglass;
      try
        LEndpoint.Post(LJson.ToString);
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

procedure TfmMain.btnDeleteClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
  LResponse: String;
begin
  //Will delete and flush the Lucene index underneath. This call may return
  //before that occurs.
  LEndpoint := TEndpointClient.Create('http://127.0.0.1', 9200, String.Empty,String.Empty, '2018-07-01/message/DocID01');
  try
    Screen.Cursor := crHourglass;
    try
      LResponse := LEndpoint.Delete;
    finally
      Screen.Cursor := crDefault;
    end;
    if LEndpoint.StatusCode in [200, 201] then
      memMain.Lines.Add(String.Format('Deleted %s: %s', [LEndpoint.FullURL, LResponse ]))
    else
      memMain.Lines.Add(String.Format('Failed Delete %s', [LEndpoint.StatusText ]));
  finally
    LEndpoint.Free;
  end;
end;

procedure TfmMain.btnPutIndexClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutResult: String;
begin
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                                          ').Trim);
    LJson.Append(('    "settings" : {                                         ').Trim);
    LJson.Append(('                    "index" : {                            ').Trim);
    LJson.Append(('                                 "number_of_shards" : 5,   ').Trim); //5 is default
    LJson.Append(('                                 "number_of_replicas" : 0  ').Trim); //2 is default but we use 0 here since we have only one node.
    LJson.Append(('                               }                           ').Trim);
    LJson.Append(('                  }                                        ').Trim);
    LJson.Append(('}                                                          ').Trim);
    LEndPoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty, String.Empty, cbIndexName.Text);
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

procedure TfmMain.btnPutTextMappingClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutData, LPutResult: String;
begin
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                     ').Trim);
    LJson.Append(('    "properties" : {                  ').Trim);
    LJson.Append(('        "type" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "facility" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "severity" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "timestamp" : {               ').Trim);
    LJson.Append(('            "type" : "date"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "host" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "process" : {                 ').Trim);
    LJson.Append(('            "type" : "keyword",       ').Trim);
    LJson.Append(('            "ignore_above" : 100      ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "processId" : {               ').Trim);
    LJson.Append(('            "type" : "long"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "logMessage" : {              ').Trim);
    LJson.Append(('            "type" : "text"           ').Trim);
    LJson.Append(('        }                             ').Trim);
    LJson.Append(('    }                                 ').Trim);
    LJson.Append(('}                                     ').Trim);

    LEndPoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty, String.Empty, String.Format('%s/_mapping', [cbIndexName.Text]));
    try
      Screen.Cursor := crHourglass;
      try
        LPutData := LJson.ToString;
        LPutResult := LEndpoint.Put(LPutData);
      finally
        Screen.Cursor := crDefault;
      end;

      memMain.Lines.Add(String.Format('Put %s to %s', [LPutData, LEndpoint.FullURL ]));
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

procedure TfmMain.btnPutKeyWordMappingClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutData, LPutResult: String;
begin
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                     ').Trim);
    LJson.Append(('    "properties" : {                  ').Trim);
    LJson.Append(('        "type" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "facility" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "severity" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "timestamp" : {               ').Trim);
    LJson.Append(('            "type" : "date"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "host" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "process" : {                 ').Trim);
    LJson.Append(('            "type" : "keyword",       ').Trim);
    LJson.Append(('            "ignore_above" : 100      ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "processId" : {               ').Trim);
    LJson.Append(('            "type" : "long"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "logMessage" : {              ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        }                             ').Trim);
    LJson.Append(('    }                                 ').Trim);
    LJson.Append(('}                                     ').Trim);

    LEndPoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty, String.Empty, String.Format('%s/_mapping', [cbIndexName.Text]));
    try
      Screen.Cursor := crHourglass;
      try
        LPutData := LJson.ToString;
        LPutResult := LEndpoint.Put(LPutData);
      finally
        Screen.Cursor := crDefault;
      end;

      memMain.Lines.Add(String.Format('Put %s to %s', [LPutData, LEndpoint.FullURL ]));
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

procedure TfmMain.btnTextKeywordDataClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutData, LPutResult: String;
begin
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                     ').Trim);
    LJson.Append(('    "properties" : {                  ').Trim);
    LJson.Append(('        "type" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "facility" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "severity" : {                ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "timeStamp" : {               ').Trim);
    LJson.Append(('            "type" : "date"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "host" : {                    ').Trim);
    LJson.Append(('            "type" : "keyword"        ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "process" : {                 ').Trim);
    LJson.Append(('            "type" : "keyword",       ').Trim);
    LJson.Append(('            "ignore_above" : 100      ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "processId" : {               ').Trim);
    LJson.Append(('            "type" : "long"           ').Trim);
    LJson.Append(('        },                            ').Trim);
    LJson.Append(('        "logMessage" : {              ').Trim);
    LJson.Append(('            "type" : "text",          ').Trim);
    LJson.Append(('            "fields" : {              ').Trim);
    LJson.Append(('                "keyword" : {         ').Trim);
    LJson.Append(('                    "type" : "keyword"').Trim);
    LJson.Append(('                    }                 ').Trim);
    LJson.Append(('                }                     ').Trim);
    LJson.Append(('            }                         ').Trim);
    LJson.Append(('        }                             ').Trim);
    LJson.Append(('    }                                 ').Trim);
    LJson.Append(('}                                     ').Trim);

    LEndPoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty, String.Empty, String.Format('%s/_mapping', [cbIndexName.Text]));
    try
      Screen.Cursor := crHourglass;
      try
        LPutData := LJson.ToString;
        LPutResult := LEndpoint.Put(LPutData);
      finally
        Screen.Cursor := crDefault;
      end;

      memMain.Lines.Add(String.Format('Put %s to %s', [LPutData, LEndpoint.FullURL ]));
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

procedure TfmMain.btnAddFileClick(Sender: TObject);
var
  LEndpoint: TEndpointClient;
  LJson: TStringBuilder;
  LFileContents: TStringList;
  i: Integer;
begin
  if not odBulk.Execute then
    EXIT;
  LFileContents := TStringList.Create;
  try
    LFileContents.LoadFromFile(odBulk.FileName);
    LJson := TStringBuilder.Create;
    try
      for i := 0 to (LFileContents.Count - 1) do
      begin
        LJSon.Append(String.Format('{"index":{"_index":"%s"}}', [cbIndexName.Text]) + #13#10);
        LJSon.Append(LFileContents[i] + #13#10);
      end;

      LEndpoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty,String.Empty, '_bulk');
      try
        Screen.Cursor := crHourglass;
        try
          LEndpoint.Post(LJson.ToString);
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
      LJSon.Free;
    end;
  finally
    LFileContents.Free;
  end;
end;

procedure TfmMain.btnTemplateClick(Sender: TObject);
var
  LJson: TStringBuilder;
  LEndPoint: TEndpointClient;
  LPutData, LPutResult: String;
begin
  //Standard Procedure
  //1 - Creaste a TStringBuilder And Add the Request Json To it
  //2 - Use ToString to get the Request.
  LJson := TStringBuilder.Create;
  try
    LJson.Append(('{                                         ').Trim);
    LJson.Append(('    "index_patterns": [' + String.Format('"%s"', [ebIndexMask.Text]) + '],    ').Trim);
    LJson.Append(('    "settings": {                         ').Trim);
    LJson.Append(('        "index": {                        ').Trim);
    LJson.Append(('            "number_of_shards": 1         ').Trim);
    LJson.Append(('        }                                 ').Trim);
    LJson.Append(('    },                                    ').Trim);
    LJson.Append(('    "mappings": {                         ').Trim);
    LJson.Append(('        "_source": {                      ').Trim);
    LJson.Append(('            "enabled": false              ').Trim);
    LJson.Append(('        },                                ').Trim);
    LJson.Append(('        "dynamic" : "false",              ').Trim); //true will not create field and add to mapping if document contains unknown feild
                                                                       //false will not create new field
                                                                       //strict will throw an exception and not add documents
    LJson.Append(('        "properties" : {                  ').Trim);
    LJson.Append(('            "type" : {                    ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "keyword"        ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "facility" : {                ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "keyword"        ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "severity" : {                ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "keyword"        ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "timeStamp" : {               ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "date"           ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "host" : {                    ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "keyword"        ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "process" : {                 ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "keyword",       ').Trim);
    LJson.Append(('                "ignore_above" : 100      ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "processId" : {               ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "long"           ').Trim);
    LJson.Append(('            },                            ').Trim);
    LJson.Append(('            "logMessage" : {              ').Trim);
    LJson.Append(('                "store" : true,           ').Trim);
    LJson.Append(('                "type" : "text",          ').Trim);
    LJson.Append(('                "fields" : {              ').Trim);
    LJson.Append(('                    "keyword" : {         ').Trim);
    LJson.Append(('                        "type" : "keyword"').Trim);
    LJson.Append(('                        }                 ').Trim);
    LJson.Append(('                    }                     ').Trim);
    LJson.Append(('                }                         ').Trim);
    LJson.Append(('            }                             ').Trim);
    LJson.Append(('        }                                 ').Trim);
    LJson.Append(('    },                                    ').Trim);
    LJson.Append(('    "aliases" : {}                        ').Trim);
    LJson.Append(('}                                         ').Trim);

    //Template name must be lower case
    LEndPoint := TEndpointClient.Create(ES_HOST, 9200, String.Empty, String.Empty, '_template/.logmessage');
    try
      Screen.Cursor := crHourglass;
      try
        LPutData := LJson.ToString;
        LPutResult := LEndpoint.Put(LPutData);
      finally
        Screen.Cursor := crDefault;
      end;

      memMain.Lines.Add(String.Format('Put %s to %s', [LPutData, LEndpoint.FullURL ]));
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

end.
