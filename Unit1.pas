  unit Unit1;

  interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.Grids,
  Vcl.ComCtrls, Data.DB, Vcl.DBGrids, UnitLog, Vcl.Menus, Winapi.OpenGL, Unit3DLog,
  Vcl.ExtCtrls;

  type
    TForm1 = class(TForm)
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    ListView1: TListView;
    ListView2: TListView;
    procedure ListBox1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);

    private
      { Private declarations }
    public
      { Public declarations }
    end;
    procedure SetListViewItemSection(items: TList; view : TListView);
  var
    Form1: TForm1;
    derictoryPath: string;
    log : TLog;
    HRC : HGLRC ;
    angle: single;
  implementation

  {$R *.dfm}
  procedure SetDCPixelFormat ( hdc : HDC );
     var
      pfd : TPixelFormatDescriptor;
      nPixelFormat : Integer;
     begin
      FillChar (pfd, SizeOf (pfd), 0);
      pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
      nPixelFormat := ChoosePixelFormat (hdc, @pfd);
      SetPixelFormat (hdc, nPixelFormat, @pfd);
     end;

  procedure TForm1.FormResize(Sender: TObject);
    begin
      ResizeForm(ClientWidth,ClientHeight);
    end;

  procedure TForm1.ListBox1Click(Sender: TObject);
    var
    path, s: string;

    begin
      if ListBox1.ItemIndex >=0  then
      begin
          path := derictoryPath+'\'+ ListBox1.Items.Strings[ListBox1.ItemIndex];
          log := TLog.Create(path);

          if Memo1.Lines.Count>0 then
          begin
             Memo1.Lines.Clear();
             ListView1.Items.Clear();
             ListView2.Items.Clear();
          end;

          SetListViewItemSection(log.sections, ListView1);

          for s in  log.GetProertyList do
          begin
             Memo1.Lines.Add(s);
             SetOpenGL(Handle);
             Create3DLog(log);
          end;

      end;
    end;

  procedure TForm1.ListView1Click(Sender: TObject);
  var
      i: Integer;
      Item: TListItem;
  begin
    try
        if ListView2.Items.Count>0 then
        begin
          ListView2.Items.Clear();
        end;
        for i:=0 to TLogSection(log.sections[ListView1.Selected.Index]).points.Count-1 do
        begin
            Item := ListView2.Items.Add;
            Item.Caption := TPointLog(TLogSection(log.sections[ListView1.Selected.Index]).points[i]).x.ToString();
            Item.SubItems.Add(TPointLog(TLogSection(log.sections[ListView1.Selected.Index]).points[i]).y.ToString());
        end;
    except
    end;
  end;

  procedure TForm1.N1Click(Sender: TObject);
  var
        sr: TSearchRec;
    begin
      SelectDirectory('Выбор папки', '',derictoryPath);

      if FindFirst(derictoryPath+'\*.lprf', faAnyFile, sr)=0  then  //ищем  файлы Word  в каталоге
      if ListBox1.Items.Count>0 then
      ListBox1.Items.Clear();

      repeat
          Listbox1.Items.Add(sr.Name); //выводим список в ListBox
      until FindNext(sr)<>0;
      FindClose(sr);
    end;

  procedure SetListViewItemSection(items: TList; view : TListView);
    var
    i: Integer;
    Item: TListItem;

    begin
      for i:=0 to items.Count-1 do
      begin
        Item := view.Items.Add;
        Item.Caption := TLogSection(items[i]).z.ToString();
        Item.SubItems.Add(TLogSection(items[i]).m.ToString());
      end;

    end;

end.


