  unit Unit1;

  interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.Grids,
  Vcl.ComCtrls, Data.DB, Vcl.DBGrids, UnitLog, Vcl.Menus, Winapi.OpenGL, Unit3DLog,
  Vcl.ExtCtrls, Vcl.Buttons;

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
    btnFill: TButton;
    btnLine: TButton;
    procedure ListBox1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure btnLineClick(Sender: TObject);
    procedure btnFillClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);


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
    mouse: TPoint;
    x1, y1: Integer;
    rotateTriger: Boolean;
  implementation

  {$R *.dfm}


  procedure TForm1.btnFillClick(Sender: TObject);
begin
SetFillMode();
end;

procedure TForm1.btnLineClick(Sender: TObject);
begin
SetLineMode();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 SetPropertyGL( Handle, 0.5, 0.5, 0.6, 1.0);
 rotateTriger := False;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 y1:=Y;
 x1:=X;
 rotateTriger := True;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

begin

    if rotateTriger then
    begin
          RotateLog(x1-X, y1-Y);
         y1:=Y;
         x1:=X;

        Form1.FormResize(nil);
    end;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
rotateTriger := False;

end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 Zumm(-100);
 Form1.FormResize(nil);
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 Zumm(100);
 Form1.FormResize(nil);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  //CreateTriangle();
  if not (log=nil) then
  begin
   CreateLog3DGL(log);
    //Create3DSection(log, 78);
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin

  FormResizeGL(ClientWidth - PageControl1.Left, ClientHeight- PageControl1.Height , PageControl1.Left, ClientHeight - PageControl1.Top);
  Form1.FormPaint(nil);
  Form1.Color := cl3DLight;


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
          end;
          Form1.FormResize(nil);

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


