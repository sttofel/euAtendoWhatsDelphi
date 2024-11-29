unit uFunctions;

interface

uses
  System.JSON, System.SysUtils, System.Variants, System.DateUtils;

function VariantToJSON(Value: Variant): TJSONValue;
function LimpaTelefone(Const Numero: string): string;

// https://stackoverflow.com/questions/76463926/delphi-11-3-unable-to-create-add-jsons-from-variant

implementation

function VariantToJSON(Value: Variant): TJSONValue;
  var i: integer;
      JSONArray: TJSONArray;
  function VarToInt(Value: Variant): integer;
  begin
    Result := Value;
  end;
  function VarToFloat(Value: Variant): double;
  begin
    Result := Value;
  end;
  function Item(Value: Variant): TJSONValue;
  begin
    case VarType(Value) of
      varEmpty, varNull, varUnknown:
        Result := TJSONNull.Create;
      varSmallint, varInteger, varShortInt, VarInt64:
        Result := TJSONNumber.Create(VarToInt(Value));
      varSingle, varDouble, varCurrency:
        Result := TJSONNumber.Create(VarToFloat(Value));
      varDate:
        Result := TJSONString.Create(DateToISO8601(Value));
      varBoolean:
        Result := TJSONBool.Create(Value);
      else
        Result := TJSONString.Create(Value);
    end;
  end;
begin
  if not VarIsArray(Value) then
  begin
    Result := Item(Value);
  end
  else
  begin
    JSONArray := TJSONArray.Create;
    for i := 0 to Length(Value) do
    begin
      JSONArray.AddElement(Item(Value[i]));
    end;
    Result := JSONArray;
  end;
end;

function LimpaTelefone(const Numero: string): string;
var
   x: integer;
   st: string;
begin
  st:='';
  for x:=1 to length(Numero) do
  begin
    if (Numero[x] <> '(') and
       (Numero[x] <> ')') and
       (Numero[x] <> '-') then
      st:=st + Numero[x];
  end;
  Result:=Trim(st);
end;

end.
