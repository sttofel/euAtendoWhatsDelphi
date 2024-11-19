unit uPrincipal;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ApiEuAtendo,
  Vcl.ExtCtrls, EncdDecd, JPEG,Vcl.Imaging.pngimage,
  IdHTTP, IdMultipartFormData, IdSSL, IdSSLOpenSSL,IdCoderMIME,System.RegularExpressions

  //uses para baixar o arquivo direto para o disco
  ,System.Net.HttpClientComponent,System.Net.HttpClient, System.NetEncoding
  //uses para enviar menu e lista
  ,System.JSON
  ;


type
  TForm9 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    edtNome: TEdit;
    edtSenha: TEdit;
    edtStatus: TEdit;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    edtNumeroContato: TEdit;
    Button8: TButton;
    ApiEuAtendo1: TApiEuAtendo;
    FileOpenDialog1: TFileOpenDialog;
    edtIDMensagem: TEdit;
    Label8: TLabel;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    edtIdGrupo: TEdit;
    Label9: TLabel;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    edtNomeContato: TEdit;
    Label10: TLabel;
    Button18: TButton;
    Panel1: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    edtApiGlobal: TEdit;
    edtUrl: TEdit;
    Label11: TLabel;
    memoMensagemEnviar: TMemo;
    Button19: TButton;
    Button20: TButton;
    Label12: TLabel;
    edtQtdContatos: TEdit;
    cbVersao: TComboBox;
    Label13: TLabel;
    btEnviaLista: TButton;
    btEnviaURL: TButton;
    Button9: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    btFakeCall: TButton;
 procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure voceAtendeAPIObterQrCode(Sender: TObject;
      const Base64QRCode: string);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure voceAtendeAPIObterFotoPerfil(Sender: TObject;
      const FotoPerfilResponse: TFotoPerfilResponse);
    procedure voceAtendeAPIObterGrupos(Sender: TObject; const Grupos: TGrupos);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApiEuAtendo1StatusInstancia(Sender: TObject;
      const InstanceStatus: TInstanceStatus);
    procedure ApiEuAtendo1CriarInstancia(Sender: TObject;
      const InstanceResponse: TInstanceResponse);
    procedure ApiEuAtendo1ObterQrCode(Sender: TObject;
      const Base64QRCode: string);
    procedure ApiEuAtendo1ObterFotoPerfil(Sender: TObject;
      const FotoPerfilResponse: TFotoPerfilResponse);
    procedure ApiEuAtendo1ObterGrupos(Sender: TObject; const Grupos: TGrupos);
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
  private
    procedure LoadBase64ToImage(const Base64: string; Image: TImage);
    function SaveImageFromURLToDisk(const ImageURL,
      NumeroContato: string): string;
    function FileToBase64(const FileName: string): string;
    function CleanInvalidBase64Chars(const Base64Str: string): string;
    { Private declarations }
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
  Img: TPNGImage;  // Para PNG
begin
  // Remover o prefixo da string Base64
  CleanedBase64 := Base64.Replace('data:image/png;base64,', '', [rfIgnoreCase]);

  Input := TStringStream.Create(CleanedBase64, TEncoding.ASCII);
  try
    Output := TMemoryStream.Create;
    try
      DecodeStream(Input, Output);
      Output.Position := 0;

      Img := TPNGImage.Create;  // Para PNG
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
    edtNome.Text   := InstanceResponse.InstanceName;
    edtStatus.Text := InstanceResponse.Status;
    edtSenha.Text  := InstanceResponse.ApiKey;

    ApiEuAtendo1.ChaveApi      := InstanceResponse.ApiKey;
    ApiEuAtendo1.NomeInstancia := InstanceResponse.InstanceName;
  end;

procedure TForm9.ApiEuAtendo1ObterContatos(Sender: TObject;
  const Contatos: TContatos);
var
  I,total: Integer;
begin
  total := Length(Contatos);
  Memo1.Lines.Add('Contatos obtidos: ' +inttoStr(total));
  for I := 0 to Length(Contatos) - 1 do
  begin

    Memo1.Lines.Add(Format('Fone: %s, Nome: %s, Foto: %s', [Contatos[I].fone, Contatos[I].Nome, Contatos[I].foto]));
  end;
end;

procedure TForm9.ApiEuAtendo1ObterFotoPerfil(Sender: TObject;
  const FotoPerfilResponse: TFotoPerfilResponse);
begin

  if FotoPerfilResponse.Filepath <> '' then
    image1.Picture.LoadFromFile(FotoPerfilResponse.Filepath);
end;

procedure TForm9.ApiEuAtendo1ObterGrupos(Sender: TObject;
  const Grupos: TGrupos);
  var
  i:Integer;
begin
 i:=0;
    memo1.Lines.Clear;
   for I := 0 to Length(Grupos) - 1 do
   begin

      memo1.Lines.Add(grupos[I].ID);
      memo1.Lines.Add(grupos[I].Owner);
      memo1.Lines.Add(grupos[I].Desc);
      memo1.Lines.Add(grupos[I].Subject);
      memo1.Lines.Add('----------------------------');
   end;




end;

procedure TForm9.ApiEuAtendo1ObterInstancias(Sender: TObject;
  const Instancias: TInstances);
  var
  i:Integer;
begin
   i:=0;

   if ApiEuAtendo1.Version = TVersionOption.V1 then
     begin

      for I := 0 to Length(Instancias) - 1 do
       begin
            memo1.Lines.Add('Instancia ' + Instancias[i].InstanceName);
            memo1.Lines.Add('Chave ' + Instancias[i].ApiKey);
            memo1.Lines.Add('Numero ' + Instancias[i].Owner);
            memo1.Lines.Add('---------------------------------------- ' + Instancias[i].Owner);
       end;

     end;


  if ApiEuAtendo1.Version = TVersionOption.V2 then
     begin

      for I := 0 to Length(Instancias) - 1 do
       begin
            memo1.Lines.Add('Instancia ' + Instancias[i].InstanceName);
            memo1.Lines.Add('Chave ' + Instancias[i].ApiKey);
            memo1.Lines.Add('Numero ' + Instancias[i].PhoneNumber);
            memo1.Lines.Add('---------------------------------------- ' + Instancias[i].Owner);
       end;

     end;


end;

procedure TForm9.ApiEuAtendo1ObterQrCode(Sender: TObject;
  const Base64QRCode: string);
begin
  LoadBase64ToImage(Base64QRCode,Image1);
end;

procedure TForm9.ApiEuAtendo1StatusInstancia(Sender: TObject;
  const InstanceStatus: TInstanceStatus);
  begin
   edtNome.Text   := InstanceStatus.InstanceName;
   edtStatus.Text := InstanceStatus.State
end;

procedure TForm9.Button10Click(Sender: TObject);
begin
memo1.Lines.Add(ApiEuAtendo1.StatusDaMensagem(edtIDMensagem.Text,edtNumeroContato.text));
end;

procedure TForm9.Button11Click(Sender: TObject);
begin
ApiEuAtendo1.DeslogarInstancia;

if ApiEuAtendo1.DeletarInstancia(edtNome.Text) then
   showmessage('Instancia excluida com sucesso');
end;

procedure TForm9.Button12Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Obtendo contatos...');
  ApiEuAtendo1.ObterContatos;
end;

procedure TForm9.Button13Click(Sender: TObject);
var
  Numeros, ErroMsg: string;
  ResponseArray: TJSONArray;
  ResponseItem: TJSONObject;
  i: Integer;
begin
  Numeros := edtNumeroContato.Text; // Assume que edtNumero � um TEdit onde os n�meros s�o inseridos separados por v�rgula
  try
    ResponseArray := ApiEuAtendo1.ExistWhats(Numeros, ErroMsg);

    if Assigned(ResponseArray) then
    begin
      // Itera sobre o array de respostas para cada n�mero
      for i := 0 to ResponseArray.Count - 1 do
      begin
        ResponseItem := ResponseArray.Items[i] as TJSONObject;
        memo1.Lines.Add('N�mero: ' + ResponseItem.GetValue<string>('number'));
        memo1.Lines.Add('JID: ' + ResponseItem.GetValue<string>('jid'));
        memo1.Lines.Add('Existe no WhatsApp: ' + BoolToStr(ResponseItem.GetValue<Boolean>('exists'), True));

        // Verifica se o campo 'name' existe antes de tentar acess�-lo
        if ResponseItem.TryGetValue<string>('name', ErroMsg) then
          memo1.Lines.Add('Nome: ' + ErroMsg)
        else
          memo1.Lines.Add('Nome: N�o dispon�vel');

        memo1.Lines.Add(''); // Linha em branco para separa��o visual entre os n�meros
      end;
    end
    else if ErroMsg <> '' then
    begin
      memo1.Lines.Add('Erro ao verificar os n�meros: ' + ErroMsg);
    end
    else
    begin
      memo1.Lines.Add('Nenhum n�mero existe no WhatsApp.');
    end;
  except
    on E: Exception do
    begin
      memo1.Lines.Add('Erro ao verificar os n�meros: ' + E.Message);
    end;
  end;
end;


procedure TForm9.Button14Click(Sender: TObject);
var
  GroupJid, ErroMsg: string;
  Membros: TGrupoMembros;
  I: Integer;
  MembroStr: string;
begin
memo1.Lines.Clear;
  GroupJid := edtIdGrupo.Text; // Assume que edtGroupJid � um TEdit onde o ID do grupo � inserido
  try
    Membros := ApiEuAtendo1.ObterMembrosGrupo(GroupJid, ErroMsg);
    if Length(Membros) > 0 then
    begin
      MembroStr := 'Membros do grupo: ' + sLineBreak;
      for I := 0 to Length(Membros) - 1 do
      begin
        MembroStr := MembroStr + Format('ID: %s, Admin: %s', [Membros[I].ID, BoolToStr(Membros[I].Admin, True)]) + sLineBreak;
        memo1.Lines.Add(MembroStr);
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
contato : TContato;
erro:String;
begin
contato := ApiEuAtendo1.ObterDadosContato(edtNumeroContato.Text,erro);

if contato.Nome <> '' then
  edtNomeContato.Text := contato.Nome;
end;

procedure TForm9.Button18Click(Sender: TObject);
begin


   FileOpenDialog1.Execute;

   if FileOpenDialog1.FileName <> '' then
     begin
     memo1.Lines.Clear;
     memo1.Lines.Add(FileToBase64(FileOpenDialog1.FileName));
     end;

   ApiEuAtendo1.EnviarMensagemDeBase64(edtNumeroContato.Text,'segue seu boleto',Memo1.Lines.Text,'document','orcamento.pdf');
   ApiEuAtendo1.EnviarMensagemDeBase64('559982385000','segue seu boleto',Memo1.Lines.Text,'document','orcamento.pdf');


//    extens�es de pdf,doc,docx,txt � tudo como document
//    extens�es de pdf,doc,docx,txt ,zip,rar tudo como document
//    extens�es de jpg,jpeg,png,webp,gif tudo como image
//    extens�es de mp3.wav.ogg tudo como audio




end;

procedure TForm9.Button19Click(Sender: TObject);
var
erro:String;
begin

  if edtIdGrupo.Text <> '' then
     ApiEuAtendo1.SendMessageGhostMentionToGroup(edtIdGrupo.Text,memoMensagemEnviar.Lines.text,erro);// SendMessageGhostMentionToGroup

  if erro <> '' then
    ShowMessage(erro);
end;

function TForm9.FileToBase64(const FileName: string): string;
var
  InputStream: TFileStream;
  Bytes: TBytes;
  base64:String;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;

  InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Bytes, InputStream.Size);
    InputStream.Read(Bytes[0], InputStream.Size);
    base64 := TNetEncoding.Base64.EncodeBytesToString(Bytes);
    base64 := CleanInvalidBase64Chars(base64);
    Result := base64;
  finally
    InputStream.Free;
  end;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin

          ApiEuAtendo1.ChaveApi        := edtSenha.Text;
          ApiEuAtendo1.NomeInstancia   := edtNome.Text;
          ApiEuAtendo1.EvolutionApiURL := edtUrl.Text;
          ApiEuAtendo1.GlobalAPI       := edtApiGlobal.text;


          Button17.Enabled := false;
          Button6.Enabled  := false;
          Button3.Enabled  := false;
          Button5.Enabled  := false;
          Button18.Enabled := false;
          Button10.Enabled := false;
          Button13.Enabled := false;
          Button12.Enabled := false;
          Button7.Enabled  := false;
          Button14.Enabled := false;
          Button19.Enabled := false;

end;

function TForm9.CleanInvalidBase64Chars(const Base64Str: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Base64Str) do
  begin
    // Adiciona ao resultado apenas se for um caractere v�lido em Base64
    if Base64Str[I] in ['A'..'Z', 'a'..'z', '0'..'9', '+', '/', '='] then
      Result := Result + Base64Str[I];
  end;
end;


procedure TForm9.Button1Click(Sender: TObject);
var
  ErrorMsg: string;
begin
  try

    ApiEuAtendo1.NomeInstancia := edtNome.Text;
    ApiEuAtendo1.ChaveApi      := edtSenha.Text;


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
      ShowMessage('Erro inesperado: ' + ErrorMsg);
    end;
  end;
end;

procedure TForm9.Button20Click(Sender: TObject);
var
erro:String;
begin
ApiEuAtendo1.AlterarPropriedadesInstancia(true,true,true,true,true,'esse numero desativou as liga��es',erro);
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
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa', 'Segue link da sua fatura em aberto.','https://s33.apidevs.app/euatendo/10.png', 'Agrade�emos a preferencia', Botao);
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
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa', 'Segue link da sua fatura em aberto.','https://s33.apidevs.app/euatendo/10.png', 'Agrade�emos a preferencia', Botao);
end;

procedure TForm9.Button23Click(Sender: TObject);
var
  Botao1, Botao2, Botao3: TButtonTipo;
begin
    Botao1.Tipo := 'reply';
    Botao1.Texto := 'Obrigado';
    Botao1.Id := '123';

    Botao2.Tipo := 'copy';
    Botao2.Texto := 'Copir link';
    Botao2.Codigo := 'https://doc.apicomponente.com.br';

    Botao3.Tipo := 'url';
    Botao3.Texto := 'acessar documenta��o';
    Botao3.Url := 'https://doc.apicomponente.com.br';

    ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'T�tulo', 'Descri��o','https://s33.apidevs.app/euatendo/10.png', 'Rodap�', [Botao1, Botao2, Botao3]);
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
ApiEuAtendo1.ObterQrCode;
end;

procedure TForm9.Button3Click(Sender: TObject);
var
id:String;
begin
 edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeTexto(edtNumeroContato.Text,memoMensagemEnviar.Lines.text);
 edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeTexto('559982385000', 'Estou testando o seu componente');
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
ApiEuAtendo1.StatusInstancia();
end;

procedure TForm9.Button5Click(Sender: TObject);
begin
   FileOpenDialog1.Execute;
   if FileOpenDialog1.FileName <> '' then
     begin
     edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeMidia('559982385000','','Estou testando o seu componente',FileOpenDialog1.FileName);
     edtIDMensagem.Text := ApiEuAtendo1.EnviarMensagemDeMidia(edtNumeroContato.Text,'',memoMensagemEnviar.Lines.Text,FileOpenDialog1.FileName);
     end;
end;

procedure TForm9.Button6Click(Sender: TObject);
begin
ApiEuAtendo1.ObterFotoPerfil(edtNumeroContato.text,true);
end;

procedure TForm9.Button7Click(Sender: TObject);
begin
ApiEuAtendo1.obterGrupos;
end;

procedure TForm9.Button8Click(Sender: TObject);
begin
memo1.Lines.Clear;
ApiEuAtendo1.obterInstancias;
//ApiEuAtendo1.obterDadosInstancia
end;

procedure TForm9.Button9Click(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  // Preencher os dados do bot�o do tipo URL
  Botao.Tipo := 'copy';
  Botao.Texto := 'Clique aqui para copiar seu PIX';
  Botao.Codigo := '15932154121651';
  // Envia o bot�o usando o m�todo EnviarBota
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa', 'Segue link da sua fatura em aberto.','https://s33.apidevs.app/euatendo/10.png', 'Agrade�emos a preferencia', Botao);
end;

procedure TForm9.btEnviaListaClick(Sender: TObject);
var
Secoes: TJSONArray;
Secao, Linha: TJSONObject;
Linhas: TJSONArray;
begin

try
    Secoes := TJSONArray.Create;
    // Adiciona a se��o de Vendas
    Secao := TJSONObject.Create;
    Secao.AddPair('title', 'Vendas');
    Linhas := TJSONArray.Create;
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Promo��o de Medicamentos');
    Linha.AddPair('description', 'Confira as promo��es especiais de medicamentos desta semana.');
    Linha.AddPair('rowId', 'vendas_001');
    Linhas.AddElement(Linha);
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Novidades');
    Linha.AddPair('description', 'Conhe�a os novos produtos dispon�veis em nossa farm�cia.');
    Linha.AddPair('rowId', 'vendas_002');
    Linhas.AddElement(Linha);
    Secao.AddPair('rows', Linhas);
    Secoes.AddElement(Secao);
    // Adiciona a se��o de Financeiro
    Secao := TJSONObject.Create;
    Secao.AddPair('title', 'Financeiro');
    Linhas := TJSONArray.Create;
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Segunda Via de Boleto');
    Linha.AddPair('description', 'Solicite a segunda via de seu boleto.');
    Linha.AddPair('rowId', 'financeiro_001');
    Linhas.AddElement(Linha);
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Hist�rico de Pagamentos');
    Linha.AddPair('description', 'Consulte seu hist�rico de pagamentos.');
    Linha.AddPair('rowId', 'financeiro_002');
    Linhas.AddElement(Linha);
    Secao.AddPair('rows', Linhas);
    Secoes.AddElement(Secao);
    // Adiciona a se��o de D�vidas
    Secao := TJSONObject.Create;
    Secao.AddPair('title', 'D�vidas');
    Linhas := TJSONArray.Create;
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Hor�rio de Funcionamento');
    Linha.AddPair('description', 'Saiba os hor�rios de funcionamento de nossas lojas.');
    Linha.AddPair('rowId', 'duvidas_001');
    Linhas.AddElement(Linha);
    Linha := TJSONObject.Create;
    Linha.AddPair('title', 'Contatos');
    Linha.AddPair('description', 'Veja os contatos para atendimento ao cliente.');
    Linha.AddPair('rowId', 'duvidas_002');
    Linhas.AddElement(Linha);
    Secao.AddPair('rows', Linhas);
    Secoes.AddElement(Secao);
    if ApiEuAtendo1.EnviarLista(edtNumeroContato.Text, 'Servi�os da Farm�cia', 'Selecione uma op��o abaixo:', 'Clique Aqui', 'Farm�cia XYZ\nhttps://exemplo.com.br', Secoes) then
      ShowMessage('Lista enviada com sucesso!')
    else
      ShowMessage('Falha ao enviar a lista.');
  finally
   //ApiEuAtendo.Free;
  end;
end;

procedure TForm9.btEnviaURLClick(Sender: TObject);
var
  Botao: TButtonTipo;
begin
  // Preencher os dados do bot�o do tipo URL
  Botao.Tipo := 'url';
  Botao.Texto := 'Clique aqui para acessar sua fatura';
  Botao.Url := 'https://fatura.clientbase.com.br/de056ae8-16cd-4c45-a103-a6bfe2023850';
  // Envia o bot�o usando o m�todo EnviarBota
  ApiEuAtendo1.EnviarBotao(edtNumeroContato.Text, 'Apidevs informa', 'Segue link da sua fatura em aberto.','https://s33.apidevs.app/euatendo/10.png', 'Agrade�emos a preferencia', Botao);

end;


procedure TForm9.btFakeCallClick(Sender: TObject);
begin
edtIDMensagem.Text := ApiEuAtendo1.FazerLigacao(edtNumeroContato.text,5);
end;

procedure TForm9.cbVersaoChange(Sender: TObject);
begin
 if cbVersao.ItemIndex = 0 then
   begin
   ApiEuAtendo1.VersionAPI := TVersionOption.V1;
   edtApiGlobal.Text := 'ASD3F21APIDEVS6A5SPAULOJRDEVFA1';
   edtUrl.Text := 'https://apiv1demo.apicomponente.com.br';

   ApiEuAtendo1.EvolutionApiURL := edtUrl.text;
   ApiEuAtendo1.GlobalAPI := edtApiGlobal.Text;

   end
   else
   begin
   edtApiGlobal.Text := 'ASD3F21APIDEVS6A5SPAULOJRDEVFA1';
   edtUrl.Text := 'https://apiv2demo.apicomponente.com.br';
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
begin

if ApiEuAtendo1.Version = TVersionOption.V1 then
begin
  if edtStatus.Text <> 'open' then
      begin
       Button17.Enabled := false;
       Button6.Enabled  := false;
       Button3.Enabled  := false;
       Button5.Enabled  := false;
       Button18.Enabled := false;
       Button10.Enabled := false;
       Button13.Enabled := false;
       Button12.Enabled := false;
       Button7.Enabled  := false;
       Button14.Enabled := false;
       Button19.Enabled := false;
      end
      else
      begin
       Button17.Enabled := True;
       Button6.Enabled  := True;
       Button3.Enabled  := True;
       Button5.Enabled  := True;
       Button18.Enabled := True;
       Button10.Enabled := True;
       Button13.Enabled := True;
       Button12.Enabled := True;
       Button7.Enabled  := True;
       Button14.Enabled := True;
       Button19.Enabled := True;
      end;
  end;

  if ApiEuAtendo1.Version = TVersionOption.V2 then
begin
  if edtStatus.Text <> 'open' then
      begin
       Button17.Enabled := false;
       Button6.Enabled  := false;
       Button3.Enabled  := false;
       Button5.Enabled  := false;
       Button18.Enabled := false;
       Button10.Enabled := false;
       Button13.Enabled := false;
       Button12.Enabled := false;
       Button7.Enabled  := false;
       Button14.Enabled := false;
       Button19.Enabled := false;
      end
      else
      begin
        Button17.Enabled := True;
        Button6.Enabled  := True;
        Button3.Enabled  := True;
        Button5.Enabled  := True;
        Button18.Enabled := True;
        Button10.Enabled := True;
        Button13.Enabled := True;
        Button12.Enabled := True;
        Button7.Enabled  := True;
        Button14.Enabled := True;
        Button19.Enabled := True;
      end;


  end;






end;

procedure TForm9.edtUrlExit(Sender: TObject);
begin
ApiEuAtendo1.EvolutionApiURL := edtUrl.Text;
end;

function TForm9.SaveImageFromURLToDisk(const ImageURL, NumeroContato: string): string;
var
  HttpClient: TNetHTTPClient;
  ImageStream: TMemoryStream;
  HttpResponse: IHTTPResponse;
  DirPath, FilePath: string;
begin
  Result := '';

  HttpClient := TNetHTTPClient.Create(nil);
  try
    ImageStream := TMemoryStream.Create;
    try
      HttpResponse := HttpClient.Get(ImageURL, ImageStream);
      if HttpResponse.StatusCode = 200 then
      begin
        ImageStream.Position := 0;  // Reset stream position

        // Define o diret�rio e o caminho do arquivo
        DirPath := ExtractFilePath(ParamStr(0)) + 'foto_perfil\';
        FilePath := DirPath + NumeroContato + '.jpg';

        // Se o diret�rio n�o existir, cria o diret�rio
        if not DirectoryExists(DirPath) then
          ForceDirectories(DirPath);

        // Salva o arquivo no disco
        ImageStream.SaveToFile(FilePath);

        // Retorna o caminho do arquivo
        Result := FilePath;
      end
      else
        raise Exception.Create('Erro ao baixar a imagem. HTTP Status: ' + HttpResponse.StatusCode.ToString);
    finally
      ImageStream.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TForm9.voceAtendeAPIObterFotoPerfil(Sender: TObject;
  const FotoPerfilResponse: TFotoPerfilResponse);
  var
  caminho:String;
begin
caminho := FotoPerfilResponse.ProfilePictureURL;
if FotoPerfilResponse.Filepath <> '' then
  image1.Picture.LoadFromFile(FotoPerfilResponse.Filepath);

end;

procedure TForm9.voceAtendeAPIObterGrupos(Sender: TObject;
  const Grupos: TGrupos);
  var
  grupo : Tgrupo;
begin
  memo1.Lines.Clear;
  memo1.Lines.Add(Grupos[1].ID);
  memo1.Lines.Add(Grupos[1].Owner);
  memo1.Lines.Add(Grupos[1].Desc);
end;

procedure TForm9.voceAtendeAPIObterQrCode(Sender: TObject;
  const Base64QRCode: string);
begin
   LoadBase64ToImage(Base64QRCode,Image1);
end;


end.
