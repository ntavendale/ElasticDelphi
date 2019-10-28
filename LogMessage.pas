unit LogMessage;

interface

uses
  System.Sysutils, System.Classes, System.DateUtils, System.JSON, WinApi.Windows;

type
  TLogMessage = record
    MessageType:String;
    Facility:String;
    Severity:String;
    TimeStamp:String;
    Host:String;
    Process:String;
    ProcessID: DWORD;
    Logmessage: String;
    class function Create: TLogMessage; overload; static;
    class function Create(AJson: String): TLogMessage; overload; static;
  end;


implementation

class function TLogMessage.Create: TLogMessage;
begin
  Result.MessageType := String.Empty;
  Result.Facility := String.Empty;
  Result.Severity := String.Empty;
  Result.TimeStamp := String.Empty;
  Result.Host := String.Empty;
  Result.Process := String.Empty;
  Result.ProcessID := 0;
  Result.LogMessage := String.Empty;
end;

class function TLogMessage.Create(AJson: String): TLogMessage;
begin
  var LJson := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    if nil <> LJson.Values['type'] then
      Result.MessageType := LJson.Values['type'].Value;
    if nil <> LJson.Values['facility'] then
      Result.Facility := LJson.Values['facility'].Value;
    if nil <> LJson.Values['severity'] then
      Result.Severity := LJson.Values['severity'].Value;
    if nil <> LJson.Values['timeStamp'] then
      Result.TimeStamp := LJson.Values['timeStamp'].Value;
    if nil <> LJson.Values['host'] then
      Result.Host := LJson.Values['host'].Value;
    if nil <> LJson.Values['process'] then
      Result.Process := LJson.Values['process'].Value;
    if nil <> LJson.Values['logMessage'] then
      Result.LogMessage := LJson.Values['logMessage'].Value;
  finally
    LJson.Free;
  end;
end;

end.
