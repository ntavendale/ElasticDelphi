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
    Width = 273
    Height = 105
    Caption = 'Index Exists'
    TabOrder = 0
    object lbResult: TLabel
      Left = 3
      Top = 84
      Width = 51
      Height = 18
      Caption = 'lbResult'
    end
    object ebCheckIndex: TEdit
      Left = 3
      Top = 24
      Width = 254
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
end
