{$APPTYPE CONSOLE}

uses
  Windows, Graphics, Glib, IniFiles, MyStrUtils, Types, SysUtils;

procedure ConvertIni;
var
  I: TMemIniFile;
  CSS: TStringDynArray;

  procedure ToCSS(Name, CSSName: String);
  var
    S: String;
  begin
    S := I.ReadString('Text', Name, '');
    if S<>'' then
      AddString(CSS, '  ' + CSSName + ': ' + S + ';');
  end;

begin
  I := TMemIniFile.Create('pledit.txt');
  AddString(CSS, '.skin_text {');
  ToCSS('Normal', 'color');
  ToCSS('NormalBG', 'background-color');
  ToCSS('Font', 'font-family');
  AddString(CSS, '}');

  AddString(CSS, '.skin_text ::-moz-selection {');
  ToCSS('Current', 'color');
  ToCSS('SelectedBG', 'background-color');
  AddString(CSS, '}');
  
  AddString(CSS, '.skin_text ::selection {');
  ToCSS('Current', 'color');
  ToCSS('SelectedBG', 'background-color');
  AddString(CSS, '}');
  
  PutFile('web\pledit.css', Join(CSS, #13#10));
end;

function ConvertFont(B: TBitmap; Y: Integer; Name: String): TIntegerDynArray;
var
  BG: TColor;
  X, SX: Integer;
  C: Char;
begin
  BG := GetPixel(B, 0, Y);
  X := 1;
  for C:='a' to 'z' do
  begin
    SX := X;
    while GetPixel(B, X, Y)<>BG do
      Inc(X);
    SaveAsPNG(Crop(B, SX, Y, X, Y+7), 'web\'+Name+'_'+C+'.png');
    SetLength(Result, Length(Result)+1); Result[High(Result)] := X-SX;
    Inc(X);
  end;
end;

procedure WriteLetterWidths(Name: String; Widths: TIntegerDynArray);
var
  I: Integer;
  C: Char;
  CSS: TStringDynArray;
begin
  for I:=0 to 25 do
  begin
    C := Chr(Ord('a')+I);
    AddString(CSS, '.skin_' + Name + '_l_' + C + ' { width: ' + IntToStr(Widths[I]) + 'px; height: 7px; background-image: url(''gen_li_' + C + '.png''); }');
    AddString(CSS, '.skin_gen:hover .skin_' + Name + '_l_' + C + ' { background-image: url(''gen_la_' + C + '.png''); }');
  end;
  PutFile('web\'+Name+'_l.css', Join(CSS, #13#10));
end;

procedure ConvertGen(Name: String);
var
  B: TBitmap;
  Widths: TIntegerDynArray;
begin
  B := LoadBitmap(Name + '.bmp');
  
  SaveAsPNG(Crop(B,   0,   0,  25,  20), 'web\'+Name+'_tal.png');
  SaveAsPNG(Crop(B,  26,   0,  51,  20), 'web\'+Name+'_tacl.png');
  SaveAsPNG(Crop(B,  52,   0,  77,  20), 'web\'+Name+'_tacf.png');
  SaveAsPNG(Crop(B,  78,   0, 103,  20), 'web\'+Name+'_tacr.png');
  SaveAsPNG(Crop(B, 104,   0, 129,  20), 'web\'+Name+'_taf.png');
  SaveAsPNG(Crop(B, 130,   0, 155,  20), 'web\'+Name+'_tar.png');
                                        
  SaveAsPNG(Crop(B,   0,  21,  25,  41), 'web\'+Name+'_til.png');
  SaveAsPNG(Crop(B,  26,  21,  51,  41), 'web\'+Name+'_ticl.png');
  SaveAsPNG(Crop(B,  52,  21,  77,  41), 'web\'+Name+'_ticf.png');
  SaveAsPNG(Crop(B,  78,  21, 103,  41), 'web\'+Name+'_ticr.png');
  SaveAsPNG(Crop(B, 104,  21, 129,  41), 'web\'+Name+'_tif.png');
  SaveAsPNG(Crop(B, 130,  21, 155,  41), 'web\'+Name+'_tir.png');
  
  SaveAsPNG(Crop(B,   0,  42, 125,  56), 'web\'+Name+'_bl.png');
  SaveAsPNG(Crop(B,   0,  57, 125,  71), 'web\'+Name+'_br.png');
  SaveAsPNG(Crop(B, 127,  72, 152,  86), 'web\'+Name+'_bf.png');

  SaveAsPNG(Crop(B, 127,  42, 138,  71), 'web\'+Name+'_ml.png');
  SaveAsPNG(Crop(B, 139,  42, 147,  71), 'web\'+Name+'_mr.png');
  SaveAsPNG(Crop(B, 158,  42, 169,  66), 'web\'+Name+'_mbl.png');
  SaveAsPNG(Crop(B, 170,  42, 178,  66), 'web\'+Name+'_mbr.png');

  Widths := 
  ConvertFont(B, 88, Name+'_la');
  ConvertFont(B, 96, Name+'_li');

  WriteLetterWidths(Name, Widths);
end;

procedure ConvertPlEdit(Name: String);
var
  B: TBitmap;
begin
  B := LoadBitmap(Name + '.bmp');
  
  SaveAsPNG(Crop(B,   0,   0,  25,  20), 'web\'+Name+'_tal.png');
  SaveAsPNG(Crop(B,  26,   0, 126,  20), 'web\'+Name+'_tac.png');
  SaveAsPNG(Crop(B, 127,   0, 152,  20), 'web\'+Name+'_taf.png');
  SaveAsPNG(Crop(B, 153,   0, 178,  20), 'web\'+Name+'_tar.png');
                                        
  SaveAsPNG(Crop(B,   0,  21,  25,  41), 'web\'+Name+'_til.png');
  SaveAsPNG(Crop(B,  26,  21, 126,  41), 'web\'+Name+'_tic.png');
  SaveAsPNG(Crop(B, 127,  21, 152,  41), 'web\'+Name+'_tif.png');
  SaveAsPNG(Crop(B, 153,  21, 178,  41), 'web\'+Name+'_tir.png');
  
  SaveAsPNG(Crop(B,   0,  42,  12,  71), 'web\'+Name+'_ml.png');
  SaveAsPNG(Crop(B,  31,  42,  51,  71), 'web\'+Name+'_mr.png');

  SaveAsPNG(Crop(B,   0,  72, 125, 110), 'web\'+Name+'_bl.png');
  SaveAsPNG(Crop(B, 126,  72, 276, 110), 'web\'+Name+'_br.png');
  SaveAsPNG(Crop(B, 179,   0, 204,  38), 'web\'+Name+'_bf.png');
  SaveAsPNG(Crop(B, 205,   0, 280,  38), 'web\'+Name+'_bx.png');
end;

procedure ConvertVideo(Name: String);
var
  B: TBitmap;
begin
  B := LoadBitmap(Name + '.bmp');
  
  SaveAsPNG(Crop(B,   0,   0,  25,  20), 'web\'+Name+'_tal.png');
  SaveAsPNG(Crop(B,  26,   0, 126,  20), 'web\'+Name+'_tac.png');
  SaveAsPNG(Crop(B, 127,   0, 152,  20), 'web\'+Name+'_taf.png');
  SaveAsPNG(Crop(B, 153,   0, 178,  20), 'web\'+Name+'_tar.png');
                                        
  SaveAsPNG(Crop(B,   0,  21,  25,  41), 'web\'+Name+'_til.png');
  SaveAsPNG(Crop(B,  26,  21, 126,  41), 'web\'+Name+'_tic.png');
  SaveAsPNG(Crop(B, 127,  21, 152,  41), 'web\'+Name+'_tif.png');
  SaveAsPNG(Crop(B, 153,  21, 178,  41), 'web\'+Name+'_tir.png');
  
  SaveAsPNG(Crop(B, 127,  42, 138,  71), 'web\'+Name+'_ml.png');
  SaveAsPNG(Crop(B, 139,  42, 147,  71), 'web\'+Name+'_mr.png');

  SaveAsPNG(Crop(B,   0,  42, 125,  80), 'web\'+Name+'_bl.png');
  SaveAsPNG(Crop(B,   0,  81, 125, 119), 'web\'+Name+'_br.png');
  SaveAsPNG(Crop(B, 127,  81, 152, 119), 'web\'+Name+'_bf.png');
end;

procedure ConvertAvs(Name: String);
var
  B: TBitmap;
begin
  B := LoadBitmap(Name + '.bmp');
  
  SaveAsPNG(Crop(B,  15,   0,  65,  15), 'web\'+Name+'_tl.png');
  SaveAsPNG(Crop(B,  66,   0,  80,  15), 'web\'+Name+'_tf.png');
  SaveAsPNG(Crop(B,  81,   0,  97,  15), 'web\'+Name+'_tr.png');

  SaveAsPNG(Crop(B,   0,  16,   7, 188), 'web\'+Name+'_ml.png');
  SaveAsPNG(Crop(B,   8,  16,  14, 188), 'web\'+Name+'_mr.png');

  SaveAsPNG(Crop(B,  15,  16,  65,  21), 'web\'+Name+'_bl.png');
  SaveAsPNG(Crop(B,  66,  16,  80,  21), 'web\'+Name+'_bf.png');
  SaveAsPNG(Crop(B,  81,  16,  97,  21), 'web\'+Name+'_br.png');
end;

begin
  CreateDirectory('web', nil);
  if FileExists('gen.bmp') then
    ConvertGen('gen');
  if FileExists('pledit.bmp') then
    ConvertPlEdit('pledit');
  if FileExists('video.bmp') then
    ConvertVideo('video');
  if FileExists('mb.bmp') then
    ConvertVideo('mb');
  if FileExists('avs.bmp') then
    ConvertAvs('avs');
  ConvertIni;
end.
