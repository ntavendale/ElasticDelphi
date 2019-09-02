object fmMain: TfmMain
  Left = 385
  Top = 185
  Caption = 'Elastic Delphi'
  ClientHeight = 456
  ClientWidth = 789
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
  object memMain: TMemo
    Left = 0
    Top = 354
    Width = 789
    Height = 102
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 264
    ExplicitWidth = 733
  end
  object pcElastic: TPageControl
    Left = 0
    Top = 0
    Width = 789
    Height = 354
    ActivePage = tsCustomMapping
    Align = alClient
    TabOrder = 1
    object tsBasics: TTabSheet
      Caption = 'Basics'
      ExplicitTop = 0
      ExplicitWidth = 285
      ExplicitHeight = 189
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
      object GroupBox2: TGroupBox
        Left = 8
        Top = 111
        Width = 305
        Height = 138
        Caption = 'Add SysLog'
        TabOrder = 2
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
          Left = 160
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
        Left = 322
        Top = 111
        Width = 322
        Height = 138
        Caption = 'Bulk Update API'
        TabOrder = 3
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
    object tsCustomMapping: TTabSheet
      Caption = 'Custom Mapping'
      ImageIndex = 1
      object gbIndexThenMapping: TGroupBox
        Left = 3
        Top = 3
        Width = 286
        Height = 174
        Caption = 'Separate Index and Mapping'
        TabOrder = 0
        object btnPutIndex: TButton
          Left = 16
          Top = 32
          Width = 97
          Height = 25
          Caption = 'Put Index'
          TabOrder = 0
          OnClick = btnPutIndexClick
        end
        object ebIndexName: TEdit
          Left = 128
          Top = 32
          Width = 137
          Height = 26
          TabOrder = 1
          Text = 'messages'
        end
        object btnPutMapping: TButton
          Left = 16
          Top = 88
          Width = 97
          Height = 25
          Caption = 'Put Mapping'
          TabOrder = 2
          OnClick = btnPutMappingClick
        end
        object ebMappingName: TEdit
          Left = 128
          Top = 87
          Width = 137
          Height = 26
          TabOrder = 3
          Text = 'bsd'
        end
      end
    end
  end
end
