unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ApiEuAtendo,
  Vcl.ExtCtrls, EncdDecd, JPEG, Vcl.Imaging.pngimage,
  IdHTTP, IdMultipartFormData, IdSSL, IdSSLOpenSSL, IdCoderMIME,
  System.RegularExpressions,
  // Usado para baixar arquivos diretamente para o disco
  System.Net.HttpClientComponent, System.Net.HttpClient, System.NetEncoding,
  // Usado para enviar menu e lista
  System.JSON, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TForm9 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    edtNome: TEdit;
    edtSenha: TEdit;
    edtNumeroContato: TEdit;
    ApiEuAtendo1: TApiEuAtendo;
    FileOpenDialog1: TFileOpenDialog;
    Button13: TButton;
    edtNomeContato: TEdit;
    Label10: TLabel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    Button11: TButton;
    Button4: TButton;
    Button8: TButton;
    Button15: TButton;
    Button16: TButton;
    Button20: TButton;
    TabSheet3: TTabSheet;
    Button3: TButton;
    Button5: TButton;
    Button10: TButton;
    Button18: TButton;
    btEnviaLista: TButton;
    Button23: TButton;
    TabSheet4: TTabSheet;
    Button6: TButton;
    Button12: TButton;
    Button17: TButton;
    Button2: TButton;
    TabSheet5: TTabSheet;
    Button7: TButton;
    Button14: TButton;
    Button19: TButton;
    Label8: TLabel;
    edtIDMensagem: TEdit;
    Label9: TLabel;
    edtIdGrupo: TEdit;
    TabSheet6: TTabSheet;
    btEnviaURL: TButton;
    Button9: TButton;
    Button21: TButton;
    Button22: TButton;
    btFakeCall: TButton;
    TabSheet7: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    edtApiGlobal: TEdit;
    edtUrl: TEdit;
    cbVersao: TComboBox;
    Label5: TLabel;
    memoMensagemEnviar: TMemo;
    Shape1: TShape;
    Label3: TLabel;
    Label12: TLabel;
    edtStatus: TEdit;
    edtQtdContatos: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ApiEuAtendo1ObterQrCode(Sender: TObject;
      const Base64QRCode: string);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ApiEuAtendo1ObterFotoPerfil(Sender: TObject;
      const FotoPerfilResponse: TFotoPerfilResponse);
    procedure ApiEuAtendo1ObterGrupos(Sender: TObject; const Grupos: TGrupos);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApiEuAtendo1StatusInstancia(Sender: TObject;
      const InstanceStatus: TInstanceStatus);
    procedure ApiEuAtendo1CriarInstancia(Sender: TObject;
      const InstanceResponse: TInstanceResponse);
    procedure ApiEuAtendo1ObterInstancias(Sender: TObject;
      const Instancias: TInstances);
    procedure Button8Click(Sender: TObject);
    procedure edtNomeExit(Sender: TObject);
    procedure edtSenhaExit(Sender: TObject);
    procedure edtApiGlobalExit(Sender: TObject);
    procedure edtUrlExit(Sender: TObject);
    procedure btEnviaListaClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ApiEuAtendo1ObterContatos(Sender: TObject;
      const Contatos: TContatos);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure edtStatusChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure cbVersaoChange(Sender: TObject);
    procedure btEnviaURLClick(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure btFakeCallClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    procedure LoadBase64ToImage(const Base64: string; Image: TImage);
    procedure ApplyBestFit(Grid: TDBGrid);
    function SaveImageFromURLToDisk(const ImageURL, NumeroContato
      : string): string;
    function FileToBase64(const FileName: string): string;
    function CleanInvalidBase64Chars(const Base64Str: string): string;
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.LoadBase64ToImage(const Base64: string; Image: TImage);
var
  CleanedBase64: string;
  Input: TStringStream;
  Output: TMemoryStream;
  Img: TPNGImage;
begin
  CleanedBase64 := Base64.Replace('data:image/png;base64,', '', [rfIgnoreCase]);

  Input := TStringStream.Create(CleanedBase64, TEncoding.ASCII);
  try
    Output := TMemoryStream.Create;
    try
      TNetEncoding.Base64.Decode(Input, Output);
      Output.Position := 0;

      Img := TPNGImage.Create;
      try
        Img.LoadFromStream(Output);
        Image.Picture.Assign(Img);
      finally
        Img.Free;
      end;

    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

procedure TForm9.ApiEuAtendo1CriarInstancia(Sender: TObject;
  const InstanceResponse: TInstanceResponse);
begin
  edtNome.Text := InstanceResponse.InstanceName;
  edtStatus.Text := InstanceResponse.Status;
  edtSenha.Text := InstanceResponse.ApiKey;

  ApiEuAtendo1.ChaveApi := InstanceResponse.ApiKey;
  ApiEuAtendo1.NomeInstancia := InstanceResponse.InstanceName;
end;

procedure TForm9.ApiEuAtendo1ObterContatos(Sender: TObject;
  const Contatos: TContatos);
var
  I: Integer;
begin
  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('Fone', ftString, 50);
  ClientDataSet1.FieldDefs.Add('Nome', ftString, 100);
  ClientDataSet1.FieldDefs.Add('Foto', ftString, 255);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  for I := 0 to Length(Contatos) - 1 do
  begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('Fone').AsString := Contatos[I].fone;
    ClientDataSet1.FieldByName('Nome').AsString := Contatos[I].Nome;
    ClientDataSet1.FieldByName('Foto').AsString := Contatos[I].foto;
    ClientDataSet1.Post;
  end;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.ApiEuAtendo1ObterFotoPerfil(Sender: TObject;
  const FotoPerfilResponse: TFotoPerfilResponse);
begin
  if FotoPerfilResponse.Filepath <> '' then
    Image1.Picture.LoadFromFile(FotoPerfilResponse.Filepath);
end;

procedure TForm9.ApiEuAtendo1ObterGrupos(Sender: TObject;
  const Grupos: TGrupos);
var
  I: Integer;
begin
  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('ID', ftString, 50);
  ClientDataSet1.FieldDefs.Add('Owner', ftString, 100);
  ClientDataSet1.FieldDefs.Add('Desc', ftString, 255);
  ClientDataSet1.FieldDefs.Add('Subject', ftString, 255);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  for I := 0 to Length(Grupos) - 1 do
  begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('ID').AsString := Grupos[I].ID;
    ClientDataSet1.FieldByName('Owner').AsString := Grupos[I].Owner;
    ClientDataSet1.FieldByName('Desc').AsString := Grupos[I].Desc;
    ClientDataSet1.FieldByName('Subject').AsString := Grupos[I].Subject;
    ClientDataSet1.Post;
  end;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.ApiEuAtendo1ObterInstancias(Sender: TObject;
  const Instancias: TInstances);
var
  I: Integer;
begin
  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('InstanceName', ftString, 75);
  ClientDataSet1.FieldDefs.Add('ApiKey', ftString, 75);
  ClientDataSet1.FieldDefs.Add('Owner', ftString, 75);
  ClientDataSet1.FieldDefs.Add('PhoneNumber', ftString, 25);
  ClientDataSet1.FieldDefs.Add('Contatos', ftString, 5);
  ClientDataSet1.FieldDefs.Add('mensagens', ftString, 5);
  ClientDataSet1.FieldDefs.Add('Conversas', ftString, 5);

  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  for I := 0 to Length(Instancias) - 1 do
  begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('InstanceName').AsString :=
      Instancias[I].InstanceName;
    ClientDataSet1.FieldByName('ApiKey').AsString := Instancias[I].ApiKey;

    if ApiEuAtendo1.Version = TVersionOption.V1 then
    begin
      ClientDataSet1.FieldByName('Owner').AsString := Instancias[I].Owner;
      ClientDataSet1.FieldByName('PhoneNumber').AsString := Instancias[I].PhoneNumber;
      // N�o existe no V1
    end
    else if ApiEuAtendo1.Version = TVersionOption.V2 then
    begin
      ClientDataSet1.FieldByName('Owner').AsString       := Instancias[I].Owner;
      ClientDataSet1.FieldByName('PhoneNumber').AsString := Instancias[I].PhoneNumber;
      ClientDataSet1.FieldByName('Contatos').AsString    := Instancias[I].Count.ContactCount.ToString;
      ClientDataSet1.FieldByName('mensagens').AsString   := Instancias[I].Count.MessageCount.ToString;
      ClientDataSet1.FieldByName('Conversas').AsString   := Instancias[I].Count.ChatCount.ToString;
    end;

    ClientDataSet1.Post;
  end;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.ApiEuAtendo1ObterQrCode(Sender: TObject;
  const Base64QRCode: string);
begin
  LoadBase64ToImage(Base64QRCode, Image1);
end;

procedure TForm9.ApiEuAtendo1StatusInstancia(Sender: TObject;
  const InstanceStatus: TInstanceStatus);
begin
  edtNome.Text := InstanceStatus.InstanceName;
  edtStatus.Text := InstanceStatus.State;
end;

procedure TForm9.Button1Click(Sender: TObject);
var
  ErrorMsg: string;
begin
  try
    ApiEuAtendo1.NomeInstancia := edtNome.Text;
    ApiEuAtendo1.ChaveApi := edtSenha.Text;

    if not ApiEuAtendo1.CriarInstancia(ErrorMsg) then
    begin
      ShowMessage('Erro ao criar a inst�ncia: ' + ErrorMsg);
    end
    else
    begin
      ShowMessage('Inst�ncia criada com sucesso.');
      ApiEuAtendo1.StatusInstancia;
      ApiEuAtendo1.ObterQrCode;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro inesperado: ' + E.Message);
    end;
  end;
end;

procedure TForm9.Button10Click(Sender: TObject);
begin
  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('Status', ftString, 255);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('Status').AsString := ApiEuAtendo1.StatusDaMensagem
    (edtIDMensagem.Text, edtNumeroContato.Text);
  ClientDataSet1.Post;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.Button11Click(Sender: TObject);
begin
  ApiEuAtendo1.DeslogarInstancia;

  if ApiEuAtendo1.DeletarInstancia(edtNome.Text) then
    ShowMessage('Inst�ncia exclu�da com sucesso');
end;

procedure TForm9.Button12Click(Sender: TObject);
begin
  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('Mensagem', ftString, 255);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('Mensagem').AsString := 'Obtendo contatos...';
  ClientDataSet1.Post;

  ApplyBestFit(DBGrid1);

  ApiEuAtendo1.ObterContatos;
end;

procedure TForm9.Button13Click(Sender: TObject);
var
  Numeros, ErroMsg: string;
  ResponseArray: TJSONArray;
  ResponseItem: TJSONObject;
  I: Integer;
begin
  Numeros := edtNumeroContato.Text;

  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('Number', ftString, 50);
  ClientDataSet1.FieldDefs.Add('JID', ftString, 100);
  ClientDataSet1.FieldDefs.Add('Exists', ftString, 10);
  ClientDataSet1.FieldDefs.Add('Name', ftString, 100);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  try
    ResponseArray := ApiEuAtendo1.ExistWhats(Numeros, ErroMsg);

    if Assigned(ResponseArray) then
    begin
      for I := 0 to ResponseArray.Count - 1 do
      begin
        ResponseItem := ResponseArray.Items[I] as TJSONObject;

        ClientDataSet1.Append;
        ClientDataSet1.FieldByName('Number').AsString :=
          ResponseItem.GetValue<string>('number');
        ClientDataSet1.FieldByName('JID').AsString :=
          ResponseItem.GetValue<string>('jid');
        ClientDataSet1.FieldByName('Exists').AsString :=
          BoolToStr(ResponseItem.GetValue<Boolean>('exists'), True);

        if ResponseItem.TryGetValue<string>('name', ErroMsg) then
          ClientDataSet1.FieldByName('Name').AsString := ErroMsg
        else
          ClientDataSet1.FieldByName('Name').AsString := 'N�o dispon�vel';

        edtNomeContato.Text := ClientDataSet1.FieldByName('Name').AsString;
        ClientDataSet1.Post;
      end;
    end
    else if ErroMsg <> '' then
    begin
      ClientDataSet1.Append;
      ClientDataSet1.FieldByName('Number').AsString := 'Erro';
      ClientDataSet1.FieldByName('Name').AsString := ErroMsg;
      ClientDataSet1.Post;
    end
    else
    begin
      ClientDataSet1.Append;
      ClientDataSet1.FieldByName('Number').AsString :=
        'Nenhum n�mero existe no WhatsApp';
      ClientDataSet1.Post;
    end;
  except
    on E: Exception do
    begin
      ClientDataSet1.Append;
      ClientDataSet1.FieldByName('Number').AsString := 'Erro';
      ClientDataSet1.FieldByName('Name').AsString := E.Message;
      ClientDataSet1.Post;
    end;
  end;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.Button14Click(Sender: TObject);
var
  GroupJid, ErroMsg: string;
  Membros: TGrupoMembros;
  I: Integer;
begin
  GroupJid := edtIdGrupo.Text;

  if ClientDataSet1.Active then
  begin
    ClientDataSet1.Close;
    ClientDataSet1.FieldDefs.Clear;
    ClientDataSet1.Fields.Clear;
  end;

  ClientDataSet1.FieldDefs.Add('ID', ftString, 100);
  ClientDataSet1.FieldDefs.Add('Admin', ftString, 10);
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.EmptyDataSet;

  try
    Membros := ApiEuAtendo1.ObterMembrosGrupo(GroupJid, ErroMsg);
    if Length(Membros) > 0 then
    begin
      for I := 0 to Length(Membros) - 1 do
      begin
        ClientDataSet1.Append;
        ClientDataSet1.FieldByName('ID').AsString := Membros[I].ID;
        ClientDataSet1.FieldByName('Admin').AsString :=
          BoolToStr(Membros[I].Admin, True);
        ClientDataSet1.Post;
      end;
    end
    else if ErroMsg <> '' then
      ShowMessage('Erro ao obter membros do grupo: ' + ErroMsg)
    else
      ShowMessage('Nenhum membro encontrado para o grupo ' + GroupJid);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao obter membros do grupo: ' + E.Message);
    end;
  end;

  ApplyBestFit(DBGrid1);
end;

procedure TForm9.Button15Click(Sender: TObject);
begin
  ApiEuAtendo1.ReiniciarInstancia;
end;

procedure TForm9.Button16Click(Sender: TObject);
begin
  ApiEuAtendo1.DeslogarInstancia;
  ApiEuAtendo1.StatusInstancia;
end;

procedure TForm9.Button17Click(Sender: TObject);
var
  contato: TContato;
  erro: String;
begin
  contato := ApiEuAtendo1.ObterDadosContato(edtNumeroContato.Text, erro);

  if contato.Nome <> '' then
    edtNomeContato.Text := contato.Nome;
end;

procedure TForm9.Button18Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
  begin
    ApiEuAtendo1.EnviarMensagemDeBase64(edtNumeroContato.Text,
      'Segue seu boleto', FileToBase64(FileOpenDialog1.FileName), 'document',
      'orcamento.pdf');
  end;
end;

procedure TForm9.Button19Click(Sender: TObject);
var
  erro: String;
begin
  if edtIdGrupo.Text <> '' then
    ApiEuAtendo1.SendMessageGhostMentionToGroup(edtIdGrupo.Text,
      memoMensagemEnviar.Lines.Text, erro);

  if erro <> '' then
    ShowMessage(erro);
end;

function TForm9.FileToBase64(const FileName: string): string;
var
  InputStream: TFileStream;
  Bytes: TBytes;
  Base64: String;
begin
  Result := '';
  if not FileExists(FileName) then
    exit;

  InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Bytes, InputStream.Size);
    InputStream.Read(Bytes[0], InputStream.Size);
    Base64 := TNetEncoding.Base64.EncodeBytesToString(Bytes);
    Base64 := CleanInvalidBase64Chars(Base64);
    Result := Base64;
  finally
    InputStream.Free;
  end;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin

  PageControl1.ActivePageIndex := 0;
  ApiEuAtendo1.ChaveApi        := edtSenha.Text;
  ApiEuAtendo1.NomeInstancia   := edtNome.Text;
  ApiEuAtendo1.EvolutionApiURL := edtUrl.Text;
  ApiEuAtendo1.GlobalAPI       := edtApiGlobal.Text;

  Button17.Enabled := False;
  Button6.Enabled := False;
  Button3.Enabled := False;
  Button5.Enabled := False;
  Button18.Enabled := False;
  Button10.Enabled := False;
  Button13.Enabled := False;
  Button12.Enabled := False;
  Button7.Enabled := False;
  Button14.Enabled := False;
  Button19.Enabled := False;
end;

function TForm9.CleanInvalidBase64Chars(const Base64Str: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Base64Str) do
  begin
    if Base64Str[I] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '+', '/', '='] then
      Result := Result + Base64Str[I];
  end;
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
  ApiEuAtendo1.ObterQrCode;
end;

procedure TForm9.Button3Click(Sender: TObject);
begin
  edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeTexto
    (edtNumeroContato.Text, memoMensagemEnviar.Lines.Text);
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
  edtNomeExit(nil);
  edtSenhaExit(nil);

  ApiEuAtendo1.StatusInstancia;
end;

procedure TForm9.Button5Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
  begin
    edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeMidia
      (edtNumeroContato.Text, '', memoMensagemEnviar.Lines.Text,
      FileOpenDialog1.FileName);
  end;
end;

procedure TForm9.Button6Click(Sender: TObject);
begin
  ApiEuAtendo1.ObterFotoPerfil(edtNumeroContato.Text, True);
end;

procedure TForm9.Button7Click(Sender: TObject);
begin
  ApiEuAtendo1.ObterGrupos;
end;

procedure TForm9.Button8Click(Sender: TObject);
begin
  ApiEuAtendo1.ObterInstancias;
end;

procedure TForm9.Button9Click(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  Botao.Tipo := 'copy';
  Botao.Texto := 'Clique aqui para copiar seu PIX';
  Botao.Codigo := '15932154121651';
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa',
    'Segue link da sua fatura em aberto.',
    'https://s33.apidevs.app/euatendo/10.png',
    'Agradecemos a prefer�ncia', Botao);
end;

procedure TForm9.btEnviaListaClick(Sender: TObject);
var
  Secoes: TJSONArray;
  Secao, Linha: TJSONObject;
  Linhas: TJSONArray;
begin
  Secoes := TJSONArray.Create;

  // Se��o de Vendas
  Secao := TJSONObject.Create;
  Secao.AddPair('title', 'Vendas');
  Linhas := TJSONArray.Create;
  Linha := TJSONObject.Create;
  Linha.AddPair('title', 'Promo��o de Medicamentos');
  Linha.AddPair('description',
    'Confira as promo��es especiais de medicamentos desta semana.');
  Linha.AddPair('rowId', 'vendas_001');
  Linhas.AddElement(Linha);

  Linha := TJSONObject.Create;
  Linha.AddPair('title', 'Novidades');
  Linha.AddPair('description',
    'Conhe�a os novos produtos dispon�veis em nossa farm�cia.');
  Linha.AddPair('rowId', 'vendas_002');
  Linhas.AddElement(Linha);

  Secao.AddPair('rows', Linhas);
  Secoes.AddElement(Secao);

  // Outras se��es podem ser adicionadas aqui...

  if ApiEuAtendo1.EnviarLista(edtNumeroContato.Text, 'Servi�os da Farm�cia',
    'Selecione uma op��o abaixo:', 'Clique Aqui',
    'Farm�cia XYZ\nhttps://exemplo.com.br', Secoes) then
    ShowMessage('Lista enviada com sucesso!')
  else
    ShowMessage('Falha ao enviar a lista.');
end;

procedure TForm9.btEnviaURLClick(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  Botao.Tipo := 'url';
  Botao.Texto := 'Clique aqui para acessar sua fatura';
  Botao.Url :=
    'https://fatura.clientbase.com.br/de056ae8-16cd-4c45-a103-a6bfe2023850';
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa',
    'Segue link da sua fatura em aberto.',
    'https://s33.apidevs.app/euatendo/10.png',
    'Agradecemos a prefer�ncia', Botao);
end;

procedure TForm9.btFakeCallClick(Sender: TObject);
begin
  edtIDMensagem.Text := ApiEuAtendo1.FazerLigacao(edtNumeroContato.Text, 5);
end;

procedure TForm9.cbVersaoChange(Sender: TObject);
begin
if cbVersao.ItemIndex = 0 then
   begin
   ApiEuAtendo1.VersionAPI := TVersionOption.V1;
   edtApiGlobal.Text := '9bb2b5203266a594dfbe41597c7ff0f2';
   edtUrl.Text := 'https://demo1.apieuatendo.com.br';

   ApiEuAtendo1.EvolutionApiURL := edtUrl.text;
   ApiEuAtendo1.GlobalAPI := edtApiGlobal.Text;

   end
   else
   begin
   edtApiGlobal.Text := '731c573a3b28f00380b9e4306599bf73';
   edtUrl.Text := 'https://demo2.apieuatendo.com.br';
   ApiEuAtendo1.VersionAPI := TVersionOption.V2 ;
   ApiEuAtendo1.EvolutionApiURL := edtUrl.text;
   ApiEuAtendo1.GlobalAPI := edtApiGlobal.Text;
   end;
end;

procedure TForm9.edtApiGlobalExit(Sender: TObject);
begin
  ApiEuAtendo1.GlobalAPI := edtApiGlobal.Text;
end;

procedure TForm9.edtNomeExit(Sender: TObject);
begin
  edtNome.Text := TRegEx.Replace(edtNome.Text, '[^a-zA-Z0-9]', '');
  ApiEuAtendo1.NomeInstancia := edtNome.Text;
end;

procedure TForm9.edtSenhaExit(Sender: TObject);
begin
  ApiEuAtendo1.ChaveApi := edtSenha.Text;
end;

procedure TForm9.edtStatusChange(Sender: TObject);
var
  IsOpen: Boolean;
begin
  IsOpen := edtStatus.Text = 'open';

  Button17.Enabled := IsOpen;
  Button6.Enabled := IsOpen;
  Button3.Enabled := IsOpen;
  Button5.Enabled := IsOpen;
  Button18.Enabled := IsOpen;
  Button10.Enabled := IsOpen;
  Button13.Enabled := IsOpen;
  Button12.Enabled := IsOpen;
  Button7.Enabled := IsOpen;
  Button14.Enabled := IsOpen;
  Button19.Enabled := IsOpen;
end;

procedure TForm9.edtUrlExit(Sender: TObject);
begin
  ApiEuAtendo1.EvolutionApiURL := edtUrl.Text;
end;

function TForm9.SaveImageFromURLToDisk(const ImageURL, NumeroContato
  : string): string;
var
  HttpClient: TNetHTTPClient;
  ImageStream: TMemoryStream;
  HttpResponse: IHTTPResponse;
  DirPath, Filepath: string;
begin
  Result := '';

  HttpClient := TNetHTTPClient.Create(nil);
  try
    ImageStream := TMemoryStream.Create;
    try
      HttpResponse := HttpClient.Get(ImageURL, ImageStream);
      if HttpResponse.StatusCode = 200 then
      begin
        ImageStream.Position := 0;

        DirPath := ExtractFilePath(ParamStr(0)) + 'foto_perfil\';
        Filepath := DirPath + NumeroContato + '.jpg';

        if not DirectoryExists(DirPath) then
          ForceDirectories(DirPath);

        ImageStream.SaveToFile(Filepath);

        Result := Filepath;
      end
      else
        raise Exception.Create('Erro ao baixar a imagem. HTTP Status: ' +
          HttpResponse.StatusCode.ToString);
    finally
      ImageStream.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TForm9.Button21Click(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  // Preencher os dados do bot�o do tipo URL
  Botao.Tipo := 'call';
  Botao.Texto := 'Clique aqui para ligar para o suporte';
  Botao.PhoneNumber := '+559982385000';
  // Envia o bot�o usando o m�todo EnviarBota
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa',
    'Segue link da sua fatura em aberto.',
    'https://s33.apidevs.app/euatendo/10.png',
    'Agrade�emos a preferencia', Botao);
end;

procedure TForm9.Button22Click(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  // Preencher os dados do bot�o do tipo URL
  Botao.Tipo := 'reply';
  Botao.Texto := 'Aceita a trasacao?';
  Botao.Codigo := '1593';
  // Envia o bot�o usando o m�todo EnviarBota
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa',
    'Segue link da sua fatura em aberto.',
    'https://s33.apidevs.app/euatendo/10.png',
    'Agrade�emos a preferencia', Botao);
end;

procedure TForm9.Button23Click(Sender: TObject);
var
  Botao1, Botao2, Botao3: TButtonTipo;
begin
  Botao1.Tipo := 'reply';
  Botao1.Texto := 'Obrigado';
  Botao1.ID := '123';

  Botao2.Tipo := 'copy';
  Botao2.Texto := 'Copir link';
  Botao2.Codigo := 'https://doc.apicomponente.com.br';

  Botao3.Tipo := 'url';
  Botao3.Texto := 'acessar documenta��o';
  Botao3.Url := 'https://doc.apicomponente.com.br';

  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'T�tulo', 'Descri��o',
    'https://s33.apidevs.app/euatendo/10.png', 'Rodap�',
    [Botao1, Botao2, Botao3]);
end;

procedure TForm9.Button20Click(Sender: TObject);
var
  erro: String;
begin
  ApiEuAtendo1.AlterarPropriedadesInstancia(True, True, True, True, True,
    'esse numero desativou as liga��es', erro);
end;

procedure TForm9.ApplyBestFit(Grid: TDBGrid);
var
  I, MaxWidth, RowWidth: Integer;
  FieldName: string;
  DisplayText: string;
  Column: TColumn;
  DataSet: TDataSet;
  Field: TField;
begin
  if not Assigned(Grid.DataSource) or not Assigned(Grid.DataSource.DataSet) then
    Exit;

  DataSet := Grid.DataSource.DataSet;

  // Itera pelas colunas do grid
  for I := 0 to Grid.Columns.Count - 1 do
  begin
    Column := Grid.Columns[I];
    FieldName := Column.FieldName;

    // Verifica se o campo existe no DataSet
    Field := DataSet.FindField(FieldName);
    if not Assigned(Field) then
      Continue; // Pula para a pr�xima coluna se o campo n�o existir

    // Define o tamanho inicial como o cabe�alho da coluna
    MaxWidth := Grid.Canvas.TextWidth(Column.Title.Caption) + 10;

    // Percorre os registros vis�veis para calcular o tamanho necess�rio
    DataSet.DisableControls;
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        DisplayText := Field.DisplayText; // Usa o Field encontrado
        RowWidth := Grid.Canvas.TextWidth(DisplayText) + 10;
        if RowWidth > MaxWidth then
          MaxWidth := RowWidth;
        DataSet.Next;
      end;
    finally
      DataSet.EnableControls;
    end;

    // Ajusta a largura da coluna
    Column.Width := MaxWidth;
  end;
end;


procedure TForm9.DBGrid1DblClick(Sender: TObject);
begin
  if Assigned(ClientDataSet1.FindField('instancename')) then
    edtNome.Text := ClientDataSet1.FieldByName('instancename').AsString;

  if Assigned(ClientDataSet1.FindField('apikey')) then
    edtSenha.Text := ClientDataSet1.FieldByName('apikey').AsString;

  if Assigned(ClientDataSet1.FindField('id')) then
    edtIdGrupo.Text := ClientDataSet1.FieldByName('id').AsString;

    Button4.OnClick(Sender);
end;

end.
