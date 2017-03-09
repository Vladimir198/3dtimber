unit Unit3DLog;

interface

uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils,
System.Variants, System.Classes, System.Math;

  procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single; log : TLog);
  procedure DestroyGL();
  procedure RotateLog(multiplierX, multiplierY: Integer);
  procedure CreateLog3DGL(log : TLog);
  procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  procedure Zumm(multiplier : Double);
  procedure SetLineMode();
  procedure SetFillMode();
  procedure Translated(multiplyerX, multiplyerY, multiplyerZ : Integer);

var
 H: HWND;
 DC: HDC;
 hrc: HGLRC;
 vLeft, vRight, vBottom, vTop, vNear, vFar, HWidth, HHeight: Integer;
 angleX, angleY, zumm1, translatedX, translatedY, translatedZ  : Double;
 viewTriger : (Perspectiva,Orto) = Perspectiva;
 Log1 : TLog;
 normalArray : array of Double;

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

  procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single; log : TLog);
   const
    LightPosition: array [0..3] of GLfloat = (10000.0, 10000.0, 10000.0, 10000.0);
    LightAmbient: array [0..3] of GLfloat = ( 0.5, 0.5, 0.5, 1.0 );
    LightDiffuse: array [0..3] of GLfloat = ( 0.9, 0.9, 0.9, 1.0 );
    LightPosition1: array [0..3] of GLfloat = (-100000.0, 15000.0, 10000.0, 10000.0);
    LightAmbient1: array [0..3] of GLfloat = ( 0.2, 0.2, 0.2, 1.0 );
    LightDiffuse1: array [0..3] of GLfloat = ( 0.3, 0.3, 0.3, 1.0 );

   begin
     Log1:= log;
     zumm1:=log.maxZ/1.5;
     translatedZ := -(log.maxZ/2);
     H := handle;
     DC := GetDC(H);
     SetDCPixcelFormat(DC);
     hrc := wglCreateContext(DC);
     wglMakeCurrent(DC, hrc);
     glClearColor(BGCRed, BGCGreen, BGCBlue, BGCAlpha);
     glEnable(GL_DEPTH_TEST);
     glEnable(GL_SCISSOR_TEST);
     glEnable(GL_COLOR_MATERIAL);
     glEnable(GL_LIGHTING);
     glLightfv(GL_LIGHT0, GL_AMBIENT, @LightAmbient);
	   glLightfv(GL_LIGHT0, GL_DIFFUSE, @LightDiffuse);
     glLightfv(GL_LIGHT0, GL_POSITION,@LightPosition);
     glEnable(GL_LIGHT0);
     glLightfv(GL_LIGHT1, GL_AMBIENT, @LightAmbient1);
	   glLightfv(GL_LIGHT1, GL_DIFFUSE, @LightDiffuse1);
     glLightfv(GL_LIGHT1, GL_POSITION,@LightPosition1);
     glEnable(GL_LIGHT1);
     glBlendFunc(GL_SRC_ALPHA,GL_ONE);
   end;

  procedure DestroyGL();
   begin
     wglMakeCurrent(0,0);
     wglDeleteContext(hrc);
     ReleaseDC(H, DC);
     DeleteDC(DC);
   end;

  procedure Zumm(multiplier : Double);
   begin
      zumm1 := zumm1 + multiplier;
   end;

  procedure Translated(multiplyerX, multiplyerY, multiplyerZ : Integer);
    begin
        translatedX:= translatedX + multiplyerX;
        translatedY := translatedY + multiplyerY;
        translatedZ := translatedZ+ multiplyerZ;
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
  counter, normalCounter: Integer;
  begin
    glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT );
    counter:=0;
    normalCounter :=0;
    glBegin(GL_TRIANGLES);
     while counter < log.pointList3D.Count do
     begin

      glColor3f(0.7,0.7,0.4);
      glNormal3d(TNormalV(log.normalList3D[normalCounter]).x, TNormalV(log.normalList3D[normalCounter]).y, TNormalV(log.normalList3D[normalCounter]).z);
      normalCounter:= normalCounter+1;
      glVertex3i(TPointLog(log.pointList3D[counter]).x, TPointLog(log.pointList3D[counter]).y, TPointLog(log.pointList3D[counter]).z);
      counter :=counter+1;
      glVertex3i(TPointLog(log.pointList3D[counter]).x, TPointLog(log.pointList3D[counter]).y, TPointLog(log.pointList3D[counter]).z);
      counter :=counter+1;
      glVertex3i(TPointLog(log.pointList3D[counter]).x, TPointLog(log.pointList3D[counter]).y, TPointLog(log.pointList3D[counter]).z);
      counter :=counter+1;

     end;
     glEnd;
     SwapBuffers(DC);
  end;

  procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  begin
    HWidth := Width;
    HHeight := Height;
    glViewport(xLeft1, yTop1, Width, Height);
    glScissor(xLeft1, yTop1, Width, Height);
    glLoadIdentity;
    gluPerspective(30,        // угол видимости в направлении оси Y
                Width/Height, // угол видимости в направлении оси X
                1,            // расстояние от наблюдателя до ближней плоскости отсечения
                100000);      // дальняя плоскость отсечения
    if zumm1<2000 then
    zumm1:= 2000;
    gluLookAt(zumm1, zumm1, zumm1, 0.0, 0.0, 0.0, 0, 1, 0);
    glRotated(angleX, 0.0, 1.0,0.0);
    glRotated(angleY, 1.0, 0.0,0.0);
    glTranslated(translatedX, translatedY, translatedZ);
    InvalidateRect(H, nil, False);
  end;

end.
