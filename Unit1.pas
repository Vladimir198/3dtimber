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
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);


    private
      { Private declarations }
    public
      { Public declarations }
    end;
    procedure SetListViewItemSection(items: TList; view : TListView);
    procedure CreateLog( log: TLog; Sender: TObject);
  var
    Form1: TForm1;
    derictoryPath: string;
    log : TLog;
    HRC : HGLRC ;
    DC: HDC;
    mouse: TPoint;
    angleX, angleY: Integer;
    rotateTriger: Boolean;
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

  procedure TForm1.FormCreate(Sender: TObject);
    begin
      rotateTriger:= False;
      DC:= GetDC(Handle);
      SetDCPixelFormat(DC);
      hrc := wglCreateContext(DC);
      wglMakeCurrent(DC, hrc);
      glEnable(GL_DEPTH_TEST); // включаем проверку разрешения фигур (впереди стоящая закрывает фигуру за ней)
      glDepthFunc(GL_LEQUAL);  //тип проверки
      //gluPerspective(90,500,100,100);

    end;

  procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
      mouse.X := X;
      mouse.Y := Y;
      rotateTriger:= True;
  end;

  procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
  begin
  if not(log = nil) then
    begin
       if rotateTriger then
       begin
         angleX := mouse.X - X;
         angleY := mouse.Y - Y;
         mouse.X := X;
         mouse.Y := Y;
         glRotated((-angleX), 0.0,1.0,0.0);
         glRotated((-angleY), 1.0,0.0,0.0);
         CreateLog(log, Sender);
       end;

    end;

  end;

  procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  begin
       rotateTriger:=False;
  end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
glScale(1.1,1.1,1.1);
 CreateLog(log, Sender);
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
glScale(0.9,0.9,0.9);
CreateLog(log, Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
    begin
    if not(log = nil) then
    begin
    CreateLog(log, Sender);

    glViewport(0, 0, ClientWidth, ClientHeight); //выделяем область куда будет выводиться наш буфер

    glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
    glLoadIdentity;  //Сбрасываем текущую матрицу
    glFrustum ( -2000 , 2000 , -2000 , 2000 , 1.2 , 2000 ); //Область видимости
    glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
    glLoadIdentity;//Сбрасываем текущую матрицу
    gluLookAt(0,0,2000,0,0,0,0,1,0);  //позиция наблюдателя
    InvalidateRect ( DC,nil,False );  //перерисовка формы
  end;
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
              CreateLog(log,Sender);
             //SetOpenGL(Handle);
             //Create3DLog(log);
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

  procedure CreateLog( log: TLog; Sender: TObject);
  var
    point, point1, point2, point3: TPointLog;
    i, j, z, z2: Integer;
  begin
     //FormResize(Sender); //процедура обновления
     glEnable(GL_LIGHT1);
     //glRotated(90,0,1,0);
   glClearColor (0.6, 0.6, 0.6, 1.0); // цвет фона
   glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // очистка буфера цвета
    for i:=0 to log.n-2 do
     begin

     z:=TLogSection(log.sections[i]).z;

     z2 := TLogSection(log.sections[i+1]).z;


         for j:=0 to TLogSection(log.sections[i]).m-2 do
         begin
              if j = TLogSection(log.sections[i]).m-2 then
              begin
                point := TPointLog(TLogSection(log.sections[i]).points[j+1]);
                point1 := TPointLog(TLogSection(log.sections[i+1]).points[j+1]);
                point2 := TPointLog(TLogSection(log.sections[i+1]).points[0]);
                point3 := TPointLog(TLogSection(log.sections[i]).points[0]);

                glBegin(GL_QUADS);
                glColor3f(0.7,0.7,0.4);
                glVertex3i(point.x, point.y, z);
                glVertex3i(point1.x, point1.y, z2);
                glVertex3i(point2.x, point2.y, z2);
                glVertex3i(point3.x, point3.y, z);
                glEnd;
              end;

                point := TPointLog(TLogSection(log.sections[i]).points[j]);
                point1 := TPointLog(TLogSection(log.sections[i+1]).points[j]);
                point2 := TPointLog(TLogSection(log.sections[i+1]).points[j+1]);
                point3 := TPointLog(TLogSection(log.sections[i]).points[j+1]);

              glBegin(GL_QUADS);
              glColor3f(0.7,0.7,0.4);
              glVertex3i(point.x, point.y, z);
              glVertex3i(point1.x, point1.y, z2);
              glVertex3i(point2.x, point2.y, z2);
              glVertex3i(point3.x, point3.y, z);
              glEnd;
          end;
     end;
    SwapBuffers(DC);
  end;
end.


