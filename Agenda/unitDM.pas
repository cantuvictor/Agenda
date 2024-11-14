unit unitDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Dialogs;

type
  TDM = class(TDataModule)
    Conexao: TFDConnection;
    tbContatos: TFDTable;
    dsContatos: TDataSource;
    tbContatosid: TFDAutoIncField;
    tbContatosnome: TStringField;
    tbContatoscelular: TStringField;
    tbContatosbloqueado: TBooleanField;
    tbContatosdata: TDateTimeField;
    tbContatosobservacoes: TMemoField;
    procedure tbContatosAfterInsert(DataSet: TDataSet);
    procedure tbContatoscelularGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure tbContatoscelularSetText(Sender: TField; const Text: string);
    procedure tbContatosBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.tbContatosAfterInsert(DataSet: TDataSet);
begin
  tbContatosData.Value := Now();
end;

procedure TDM.tbContatosBeforeDelete(DataSet: TDataSet);
var
  Result: Integer;
begin
  // Exibe uma caixa de di�logo de confirma��o antes de excluir
  Result := MessageDlg('Voc� tem certeza que deseja excluir este registro?', mtConfirmation, [mbYes, mbNo], 0);

  // Se o usu�rio escolher "N�o", cancela a exclus�o
  if Result = 7 then  // 7 � o valor para "mrNo"
    DataSet.Cancel;
end;

procedure TDM.tbContatoscelularGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
Text := Sender.AsString;
  if Length(Text) = 11 then
    Text := Format('(%s) %s-%s', [Copy(Text, 1, 2), Copy(Text, 3, 5), Copy(Text, 8, 4)]);
end;

procedure TDM.tbContatoscelularSetText(Sender: TField; const Text: string);
var
  rawText: string;
begin

  rawText := StringReplace(StringReplace(StringReplace(Text, '(', '', []), ') ', '', []), '-', '', []);
  if Length(rawText) > 11 then
  begin

    ShowMessage('O n�mero de celular n�o pode ter mais que 11 d�gitos!');
    Exit;
  end;

  Sender.AsString := rawText;
end;

end.
