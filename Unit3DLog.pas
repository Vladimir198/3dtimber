unit Unit3DLog;

interface

uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils,
System.Variants, System.Classes;

  procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single);
  procedure DestroyGL();
  procedure RotateLog(multiplier: Integer);
  procedure CreateLog3DGL(log : TLog);
  procedure FormResizeGL(Width, Height : Integer);
  procedure Zumm(multiplier : Integer);
  procedure SetOrto();
  procedure SetPerspektiva();
  procedure SetLineMode();
  procedure SetFillMode();


var
 H: HWND;
 DC: HDC;
 hrc: HGLRC;
 vLeft, vRight, vBottom, vTop, vNear, vFar, HWidth, HHeight, zumm1: Integer;
 angle : Double;
 viewTriger : (Perspectiva,Orto) = Perspectiva;
 implementation
   procedure SetDCPixcelFormat (hdc: HDC);
   var
   pfd : TPixelFormatDescriptor;
   nPixcelFormat : Integer;
   begin
     FillChar(pfd, SizeOf(pfd), 0);
     pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
     nPixcelFormat := ChoosePixelFormat(hdc, @pfd);
     SetPixelFormat(hdc, nPixcelFormat, @pfd);
   end;

   procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single);
   begin
     zumm1:=60;
     angle := 90;
     H := handle;
     DC := GetDC(H);
     SetDCPixcelFormat(DC);
     hrc := wglCreateContext(DC);
     wglMakeCurrent(DC, hrc);
     glClearColor(BGCRed, BGCGreen, BGCBlue, BGCAlpha);
     glColor3f(1.0, 0.0, 0.5);
     vLeft := -20000;
     vRight := 20000;
     vTop := 7000;
     vBottom := -7000;
     vNear :=2100;
     vFar := 47000;
     glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
     //glEnable (GL_DEPTH_TEST);
     glEnable (GL_LIGHTING);
     glEnable(GL_LIGHT0);
   end;

   procedure DestroyGL();
   begin
     wglMakeCurrent(0,0);
     wglDeleteContext(hrc);
     ReleaseDC(H, DC);
     DeleteDC(DC);
   end;

   procedure Zumm(multiplier : Integer);
   begin
      vLeft := vLeft -  multiplier*200;
      vRight := vRight + multiplier*200;
      vTop := vTop + multiplier*200;
      vBottom := vBottom - multiplier*200;
        zumm1 := zumm1 + multiplier;
   end;

  procedure RotateLog(multiplier: Integer);
  begin
      glLoadIdentity;
      angle := angle + multiplier;
      glRotated(angle, 0.0, 1.0,0.0); //поворот объекта - ось Y
      InvalidateRect(H, nil, False);
  end;

  procedure SetLineMode();
  begin
    glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
  end;

  procedure SetFillMode();
  begin
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
  end;

  procedure SetPerspektiva();
  begin
    viewTriger :=Perspectiva;
    glLoadIdentity;
    gluPerspective(zumm1,           // угол видимости в направлении оси Y
                HWidth / HHeight, // угол видимости в направлении оси X
                2100,            // расстояние от наблюдателя до ближней плоскости отсечения
                47000);
    //glFrustum(vLeft, vRight, vBottom, vTop, vNear, vFar); // задаем перспективу
    glTranslatef(0.0, 0.0, -9000.0);   // перенос объекта - ось Z
    glRotated(angle, 0.0, 1.0,0.0);
    InvalidateRect(H, nil, False);
  end;

   procedure SetOrto();
   begin
    viewTriger :=Orto;
    glLoadIdentity;
    glOrtho(vLeft, vRight, vBottom, vTop, vNear, vFar); // задаем перспективу
    glTranslatef(0.0, 0.0, -9000.0);   // перенос объекта - ось Z
    glRotated(angle, 0.0, 1.0,0.0);
    InvalidateRect(H, nil, False);
   end;

  procedure CreateLog3DGL(log : TLog);
  var
  point, point1, point2, point3: TPointLog;
  i, j, z, z2, a: Integer;
  begin
    glClear (GL_COLOR_BUFFER_BIT);
    for i:=0 to log.n-2 do
     begin
        a:= Round(log.maxZ/2);
        z:=((TLogSection(log.sections[i]).z)-a);

        z2 :=(TLogSection(log.sections[i+1]).z-a);


       for j:=0 to TLogSection(log.sections[i]).m-2 do
       begin
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

        end;
     end;
     SwapBuffers(DC);
  end;

  procedure FormResizeGL(Width, Height : Integer);
  begin
    HWidth := Width;
    HHeight := Height;
    glViewport(0, 0, Width, Height);
    glLoadIdentity;
    case viewTriger of
     Perspectiva : gluPerspective(zumm1,           // угол видимости в направлении оси Y
                Width / Height, // угол видимости в направлении оси X
                3100,            // расстояние от наблюдателя до ближней плоскости отсечения
                47000);
     Orto : glOrtho(vLeft, vRight, vBottom, vTop, vNear, vFar);
     end; // задаем перспективу
    glTranslatef(0.0, 0.0, -9000.0);   // перенос объекта - ось Z
    glRotated(angle, 0.0, 1.0,0.0);
    InvalidateRect(H, nil, False);
  end;
end.
