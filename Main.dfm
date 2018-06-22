object fmMain: TfmMain
  Left = 800
  Top = 416
  Caption = 'Elastic Delphi'
  ClientHeight = 479
  ClientWidth = 836
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 18
  object gbIndexExists: TGroupBox
    Left = 8
    Top = 0
    Width = 305
    Height = 105
    Caption = 'Index Exists'
    TabOrder = 0
    object ebCheckIndex: TEdit
      Left = 3
      Top = 24
      Width = 294
      Height = 26
      TabOrder = 0
    end
    object btnIndexExists: TButton
      Left = 3
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Check'
      TabOrder = 1
      OnClick = btnIndexExistsClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 319
    Top = 0
    Width = 509
    Height = 105
    Caption = 'Create Index'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 37
      Height = 18
      Caption = 'Name'
    end
    object Label2: TLabel
      Left = 312
      Top = 24
      Width = 41
      Height = 18
      Caption = 'Shards'
    end
    object Label3: TLabel
      Left = 384
      Top = 24
      Width = 51
      Height = 18
      Caption = 'Replicas'
    end
    object ebCreateIndex: TEdit
      Left = 8
      Top = 42
      Width = 286
      Height = 26
      TabOrder = 0
    end
    object btnCreateIndex: TButton
      Left = 3
      Top = 74
      Width = 75
      Height = 25
      Caption = 'Create'
      TabOrder = 1
      OnClick = btnCreateIndexClick
    end
    object ebCreateShards: TEdit
      Left = 312
      Top = 42
      Width = 57
      Height = 26
      TabOrder = 2
    end
    object ebCreateReplicas: TEdit
      Left = 384
      Top = 42
      Width = 73
      Height = 26
      TabOrder = 3
    end
  end
  object memMain: TMemo
    Left = 0
    Top = 304
    Width = 836
    Height = 175
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 111
    Width = 305
    Height = 105
    Caption = 'Add SysLog'
    TabOrder = 3
    object btnAddSyslogWithID: TButton
      Left = 16
      Top = 32
      Width = 105
      Height = 25
      Caption = 'Add With ID'
      TabOrder = 0
      OnClick = btnAddSyslogWithIDClick
    end
    object btnUpdateSyslogWithID: TButton
      Left = 16
      Top = 63
      Width = 105
      Height = 25
      Caption = 'Update With ID'
      TabOrder = 1
      OnClick = btnUpdateSyslogWithIDClick
    end
    object btnAddSyslogWithNoID: TButton
      Left = 184
      Top = 32
      Width = 105
      Height = 25
      Caption = 'Add With No ID'
      TabOrder = 2
      OnClick = btnAddSyslogWithNoIDClick
    end
  end
end
