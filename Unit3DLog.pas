unit Unit3DLog;

interface

uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils,
System.Variants, System.Classes;

  procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single);
  procedure DestroyGL();
  procedure RotateLog(multiplierX, multiplierY: Integer);
  procedure CreateLog3DGL(log : TLog);
  procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  procedure Zumm(multiplier : Integer);
  procedure SetLineMode();
  procedure SetFillMode();


var
 H: HWND;
 DC: HDC;
 hrc: HGLRC;
 vLeft, vRight, vBottom, vTop, vNear, vFar, HWidth, HHeight, zumm1: Integer;
 angleX, angleY : Double;
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
     zumm1:=16000;
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
     vNear :=0;
     vFar := 60000;
     glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
     glEnable (GL_LIGHTING);
     glEnable(GL_LIGHT0);
     glEnable(GL_LIGHT1);
     glEnable(GL_SCISSOR_TEST);
     glEnable(GL_COLOR_MATERIAL);

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
      zumm1 := zumm1 + multiplier;
   end;

  procedure RotateLog(multiplierX, multiplierY: Integer);
  begin
      angleX := angleX + multiplierX;
      angleY := angleY + multiplierY;
  end;

  procedure SetLineMode();
  begin
    glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
  end;

  procedure SetFillMode();
  begin
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
  end;

  procedure CreateLog3DGL(log : TLog);
  var
  point, point1, point2, point3: TPointLog;
  i, j, z, z2, a, xN, yN, zN: Integer;
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
             xN := point.y*(z2-z2) + point1.y*(z2-z) + point2.y*(z-z2);
             yN := z*(point1.x - point2.x) + z2*(point2.x-point.x) + z2*(point.x-point1.x);
             zN := point.x*(point1.y - point2.y) + point1.x*(point2.y-point.y) + point2.x*(point.y-point1.y);
            glBegin(GL_QUADS);
            glColor3f(0.7,0.7,0.4);
            glNormal3i(xN,yN,zN);
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
              xN := point.y*(z2-z2) + point1.y*(z2-z) + point2.y*(z-z2);
              yN := z*(point1.x - point2.x) + z2*(point2.x-point.x) + z2*(point.x-point1.x);
              zN := point.x*(point1.y - point2.y) + point1.x*(point2.y-point.y) + point2.x*(point.y-point1.y);
              glBegin(GL_QUADS);
              glColor3f(0.7,0.7,0.4);
              glNormal3i(xN,yN,zN);
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

  procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  begin
    HWidth := Width;
    HHeight := Height;
    glViewport(xLeft1, yTop1, Width, Height);
    glScissor(xLeft1, yTop1, Width, Height);
    glLoadIdentity;
    gluPerspective(30,           // угол видимости в направлении оси Y
                Width / Height, // угол видимости в направлении оси X
                0,            // расстояние от наблюдателя до ближней плоскости отсечения
                60000);

    if zumm1 >0 then
    gluLookAt (0, zumm1+3000, zumm1*2, 0.0, 0.0, 0.0, 0, 1, 0);
    glTranslatef(0.0, 0.0, -9000.0);   // перенос объекта - ось Z
    glRotated(angleX, 0.0, 1.0,0.0);
    //glRotated(angleY, 1.0, 0.0,0.0);
    InvalidateRect(H, nil, False);
  end;
end.
