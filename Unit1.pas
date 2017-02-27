  unit Unit1;

  interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FileCtrl;

  type
    TForm1 = class(TForm)
      ListBox1: TListBox;
      Button1: TButton;
      procedure Button1Click(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
    end;

  var
    Form1: TForm1;

  implementation

  {$R *.dfm}

    procedure TForm1.Button1Click(Sender: TObject);
        var
        path: String;
        sr: TSearchRec;
    begin
          SelectDirectory('Выбор папки', '',path);

          if FindFirst(path+'\*.lprf', faAnyFile, sr)=0  then  //ищем  файлы Word  в каталоге

           repeat
               Listbox1.Items.Add(sr.Name); //выводим список в ListBox
            until FindNext(sr)<>0; //для проверки гита

            FindClose(sr);
    end;
end.


