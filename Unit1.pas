  unit Unit1;

  interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FileCtrl, Vcl.Grids,
  Vcl.ComCtrls, Data.DB, Vcl.DBGrids, UnitLog;

  type
    TForm1 = class(TForm)
      ListBox1: TListBox;
      Button1: TButton;
    TabControl1: TTabControl;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
      procedure Button1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
    end;

  var
    Form1: TForm1;
    derictoryPath: string;
    log : TLog;
  implementation

  {$R *.dfm}

    procedure TForm1.Button1Click(Sender: TObject);
        var
        sr: TSearchRec;
    begin
          SelectDirectory('Выбор папки', '',derictoryPath);

          if FindFirst(derictoryPath+'\*.lprf', faAnyFile, sr)=0  then  //ищем  файлы Word  в каталоге

           repeat
               Listbox1.Items.Add(sr.Name); //выводим список в ListBox
            until FindNext(sr)<>0; //для проверки гита

            FindClose(sr);
    end;
procedure TForm1.ListBox1Click(Sender: TObject);
var
path:string;
begin
if ListBox1.ItemIndex >=0  then
begin
    path := derictoryPath+'\'+ ListBox1.Items.Strings[ListBox1.ItemIndex];
    log := TLog.Create(path);
    Edit1.Text := log.version.ToString();
end;

    

end;

end.


