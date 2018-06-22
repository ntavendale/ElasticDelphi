{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2018 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{             Non Commerical Use Permitted              }                
{*******************************************************}
unit EndPointClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSL, IdSSLOpenSSL,
  IdSSLOpenSSLHeaders, IdIOHandler,  IdIOHandlerSocket, IdIOHandlerStack;

type
  TEndpointClient = class
    protected
      { Protected declarations }
      FEndpointURL: String;
      FHttp: TIdHTTP;
      FResponseCode: Integer;
      FResponseText: String;
      FFullURL: String;
      FHandler: TIdSSLIOHandlerSocketOpenSSL;
    public
      { Public declarations }
      constructor Create(AEndpointURL: String; APort: WORD; AUserName, APAssword: String; AResource: String); virtual;
      destructor Destroy; override;
      function Head: Integer; overload;
      function Head(AResource: String): Integer; overload;
      function Get: String; overload;
      function Get(AResource: String): String; overload;
      procedure Put(AContents: String); overload;
      procedure Put(AResource: String; AContents: String); overload;
      procedure Post(AContents: String); overload;
      procedure Post(AResource: String; AContents: String); overload;
      function Delete: String; overload;
      function Delete(AResource: String): String; overload;
      property ResponseCode: Integer read FResponseCode;
      property ResponseText: String read FResponseText;
      property StatusCode: Integer read FResponseCode;
      property StatusText: String read FResponseText;
      property FullURL: String read FFullURl;
  end;

implementation

constructor TEndpointClient.Create(AEndpointURL: String; APort: WORD; AUserName, APassword: String; AResource: String);
begin
  FHandler := nil;
  FHttp := TIdHTTP.Create(nil);
  if not String.IsNullorWhiteSpace(AUserName) then
  begin
    FHttp.Request.Username := AUserName;
    FHttp.Request.Password := APassword;
    FHttp.Request.BasicAuthentication:= TRUE;
    FHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    FHttp.IOHandler := FHandler;
    FHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    FHandler.SSLOptions.Method := sslvTLSv1_2;
  end;
  FEndpointURL := String.Format('%s:%d', [AEndpointURL, APort]);
  FFullURL := String.Format('%s/%s', [FEndpointURL, AResource]);
end;

destructor TEndpointClient.Destroy;
begin
  FHttp.Free;
  if Assigned(FHandler) then
    FHandler.Free;
  inherited Destroy;
end;

function TEndpointClient.Head: Integer;
begin
  FResponseText := String.Empty;
  try
    FHttp.Head(FFullURL);
  except
  end;
  FResponseCode := FHttp.ResponseCode;
  Result := FResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Head(AResource: String): Integer;
begin
  FResponseText := String.Empty;
  try
    FHttp.Head(String.Format('%s/%s', [FEndpointURL, AResource]));
  except
  end;
  FResponseCode := FHttp.ResponseCode;
  Result := FResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Get: String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Get(FFullURL);
  except
    on E:Exception do
    begin
      Result := String.Format('%s', [E.Message]);
    end;
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Get(AResource: String): String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Get(String.Format('%s/%s', [FEndpointURL, AResource]));
  except
    on E:Exception do
    begin
      Result := String.Format('%s', [E.Message]);
    end;
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := 'application/json';
      FHttp.Put(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except

  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AResource: String; AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := 'application/json';
      FHttp.Put(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Post(AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Post(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Post(AResource: String; AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Post(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Delete: String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Delete(FFullURL);
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Delete(AResource: String): String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Delete(String.Format('%s/%s', [FEndpointURL, AResource]));
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

end.
