object fmMain: TfmMain
  Left = 448
  Top = 168
  Caption = 'Elastic Delphi'
  ClientHeight = 479
  ClientWidth = 733
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
    Height = 97
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
      Left = 0
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Check'
      TabOrder = 1
      OnClick = btnIndexExistsClick
    end
  end
  object gbCreateIndex: TGroupBox
    Left = 319
    Top = 0
    Width = 322
    Height = 97
    Caption = 'Create Index'
    TabOrder = 1
    object ebCreateIndex: TEdit
      Left = 3
      Top = 24
      Width = 286
      Height = 26
      TabOrder = 0
    end
    object btnCreateIndex: TButton
      Left = 0
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Create'
      TabOrder = 1
      OnClick = btnCreateIndexClick
    end
  end
  object memMain: TMemo
    Left = 0
    Top = 264
    Width = 733
    Height = 215
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
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
    Height = 138
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
    object btnDelete: TButton
      Left = 16
      Top = 96
      Width = 105
      Height = 25
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object gbBulkUpdates: TGroupBox
    Left = 319
    Top = 111
    Width = 322
    Height = 105
    Caption = 'Bulk Update API'
    TabOrder = 4
    object btnBulkUpdateSingleIndex: TButton
      Left = 16
      Top = 32
      Width = 97
      Height = 25
      Caption = 'Single Index'
      TabOrder = 0
      OnClick = btnBulkUpdateSingleIndexClick
    end
    object btnBulkUpdateMultipleIndex: TButton
      Left = 128
      Top = 31
      Width = 97
      Height = 25
      Caption = 'Multiple Index'
      TabOrder = 1
      OnClick = btnBulkUpdateMultipleIndexClick
    end
  end
end
