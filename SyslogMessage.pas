unit SyslogMessage;

interface

uses
  System.SysUtils, System.Classes, System.Json, System.Generics.Collections,
  System.DateUtils;

type
  TSyslogMessage = class
  protected
    FDocumentID: String;
    FMessageType: String;
    FFacility: String;
    FSeverity: String;
    FTimeStamp: TDateTime;
    FHost: String;
    FProcess: String;
    FProcessID: Integer;
    FMessageContent: String;
    function ToJSONString: String;
    procedure FromJSONString(AVAlue: String);
  public
    constructor Create(ASyslogMessage: TSyslogMessage = nil);
    function ToJSONObject: TJSONObject;
    procedure FromJSONObject(AValue: TJSONObject);
    property DocumentID: String read FDocumentID write FDocumentID;
    property MessageType: String read FMessageType write FMessageType;
    property Facility: String read FFacility write FFacility;
    property Severity: String read FSeverity write FSeverity;
    property TimeStamp: TDateTime read FTimeStamp write FTimeStamp ;
    property Host: String read FHost write FHost;
    property Process: String read FProcess write FProcess;
    property ProcessID: Integer read FProcessID write FProcessID;
    property MessageContent: String read FMessageContent write FMessageContent;
    property AsJson: String read ToJSONString write FromJSONString;
    class function FromJson(AJsonString: String): TSyslogMessage;
  end;

  TSyslogMessageList = class
  protected
    FList: TObjectList<TSyslogMessage>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TSyslogMessage;
    procedure SetListItem(AIndex: Integer; AValue: TSyslogMessage);
  public
    constructor Create(ASyslogMessageList: TSyslogMessageList = nil);
    destructor Destroy; override;
    procedure Add(AMessage: TSyslogMessage);
    procedure Delete(AIndex: Integer);
    property Count: Integer read GetCount;
    property ListItem[AIndex: Integer]: TSyslogMessage read GetListItem write SetListItem; default;
    class function LoadFromFile(AFileName: String): TSyslogMessageList;
  end;


implementation

{$REGION 'TSyslogMessage'}
constructor TSyslogMessage.Create(ASyslogMessage: TSyslogMessage = nil);
begin
  FDocumentID := String.Empty;
  FMessageType := String.Empty;
  FFacility := String.Empty;
  FSeverity := String.Empty;
  FTimeStamp := Now;
  FHost := String.Empty;
  FProcess := String.Empty;
  FProcessID := 0;
  FMessageContent := String.Empty;
  if nil <> ASyslogMessage then
  begin
    FMessageType := ASyslogMessage.MessageType;
    FFacility := ASyslogMessage.Facility;
    FSeverity := ASyslogMessage.Severity;
    FTimeStamp := ASyslogMessage.TimeStamp;
    FHost := ASyslogMessage.Host;
    FProcess := ASyslogMessage.Process;
    FProcessID := ASyslogMessage.ProcessID;
    FMessageContent := ASyslogMessage.MessageContent;
  end;
end;

function TSyslogMessage.ToJSONString: String;
var
  LJson: TJSONObject;
begin
  LJson := ToJSONObject;
  try
    Result := LJson.ToJSON;
  finally
    LJson.Free;
  end;
end;

procedure TSyslogMessage.FromJSONString(AVAlue: String);
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LJson)
  finally
    LJson.Free;
  end;
end;

function TSyslogMessage.ToJSONObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('type', FMessageType);
  Result.AddPair('facility', FFacility);
  Result.AddPair('severity', FSeverity);
  Result.AddPair('timeStamp', DateToISO8601(FTimeStamp));
  Result.AddPair('host', FHost);
  Result.AddPair('process', FProcess);
  Result.AddPair('processId', TJSONNumber.Create(FProcessID));
  Result.AddPair('text', FMessageContent);
end;

procedure TSyslogMessage.FromJSONObject(AValue: TJSONObject);
begin
  if nil <> AValue.Values['_id'] then
    FDocumentID := AValue.Values['_id'].Value;
  if nil <> AValue.Values['type'] then
    FMessageType := AValue.Values['type'].Value;
  if nil <> AValue.Values['facility'] then
    FFacility := AValue.Values['facility'].Value;
  if nil <> AValue.Values['severity'] then
    FSeverity := AValue.Values['severity'].Value;
  if nil <> AValue.Values['timeStamp'] then
  begin
    try
      FTimeStamp := TTimeZone.Local.ToLocalTime( ISO8601ToDate(AValue.Values['timeStamp'].Value) );
    except
      //
    end;
  end;
  if nil <> AValue.Values['host'] then
    FHost := AValue.Values['host'].Value;
  if nil <> AValue.Values['process'] then
    FProcess := AValue.Values['process'].Value;
  if nil <> AValue.Values['processId'] then
    FProcessID := StrToIntDef(AValue.Values['processId'].Value, 0);
  if nil <> AValue.Values['text'] then
    FMessageContent := AValue.Values['text'].Value;
end;

class function TSyslogMessage.FromJson(AJsonString: String): TSyslogMessage;
begin
  Result := TSyslogMessage.Create;
  Result.AsJson := AJsonString;
end;
{$ENDREGION}

{$REGION 'TSyslogMessageList'}
constructor TSyslogMessageLIst.Create(ASyslogMessageList: TSyslogMessageList = nil);
var
  i: Integer;
begin
  FList := TobjectList<TSyslogMessage>.Create(TRUE);
  for i := 0 to (ASyslogMessageList.Count - 1) do
    FList.Add( TSyslogMessage.Create(ASyslogMessageList[i]) );
end;

destructor TSyslogMessageList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TSyslogMessageList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSyslogMessageList.GetListItem(AIndex: Integer): TSyslogMessage;
begin
  Result := FList[AIndex];
end;

procedure TSyslogMessageList.SetListItem(AIndex: Integer; AValue: TSyslogMessage);
begin
  FList[AIndex] := AValue;
end;

procedure TSyslogMessageList.Add(AMessage: TSyslogMessage);
begin
  FList.Add(AMessage);
end;

procedure TSyslogMessageList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

class function TSyslogMessageList.LoadFromFile(AFileName: String): TSyslogMessageList;
var
  LFileStrings: TStringList;
  i: Integer;
  LMsg: TSyslogMessage;
begin
  Result := TSyslogMessageList.Create;
  LFileStrings := TStringList.Create;
  try
    LFileStrings.LoadFromFile(AFileName);
    for i := 0 to LFileStrings.Count - 1 do
    begin
      LMsg := TSyslogMessage.Create;
      LMsg.AsJson := LFileStrings[i];
      Result.Add(LMsg);
    end;
  finally
    LFileStrings.Free;
  end;
end;
{$ENDREGION}

end.
