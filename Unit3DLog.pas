unit Unit3DLog;

interface
uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils, System.Variants, System.Classes;


   procedure SetDCPixelFormat (dc : HDC);
   procedure SetOpenGL(handle: HWND);
   procedure Rotated3DLog(angle: Double);
   procedure Create3DLog(log: TLog);
   procedure Destroy3DLog();
   procedure ResizeForm (Width: Integer; Height: Integer);
 var
 H: THandle;
 DC: HDC;
 hrc: HGLRC;
implementation

   procedure SetDCPixelFormat(dc:HDC);

    var pfd:TPixelFormatDescriptor;
    nPixelFormat:Integer;

  begin
    FillChar(pfd,SizeOf(pfd),0);
    with pfd do
     begin
      nSize     := sizeof(pfd);
      nVersion  := 1;
      dwFlags   := PFD_DRAW_TO_WINDOW or
                   PFD_SUPPORT_OPENGL or
                   PFD_DOUBLEBUFFER;
      iPixelType:= PFD_TYPE_RGBA;
      cColorBits:= 16;
      cDepthBits:= 64;
      iLayerType:= PFD_MAIN_PLANE;
     end;

    nPixelFormat:=ChoosePixelFormat(DC,@pfd);
    SetPixelFormat(DC,nPixelFormat,@pfd);
  end;

  procedure SetOpenGL(handle: HWND);
  begin
    H:= handle;
    DC:= GetDC(handle);
    SetDCPixelFormat(DC);
    hrc := wglCreateContext(DC);
    wglMakeCurrent(DC, hrc);
    glShadeModel(GL_SMOOTH);
    //glViewport(0, 0, 500, 500);
  end;

  procedure Create3DLog(log: TLog );
    var
    point, point1, point2, point3: TPointLog;
    i, j, z, z2: Integer;
  begin
    glClearColor (0.4, 0.8, 0.8, 1.0);

    glMatrixMode (GL_PROJECTION);

    glLoadIdentity;

    glFrustum (-3000, 3000, -3000, 3000, 30, 300);

    glMatrixMode (GL_MODELVIEW);

    glLoadIdentity;

    glTranslated(0,0,-5);

    glEnable (GL_LIGHTING);

    glEnable (GL_LIGHT0);

    glEnable (GL_DEPTH_TEST);

    glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
     gluLookAt(6000,6000,6000,0,0,3000,0,0,1);
     glRotatef(15,0,1,0);
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
              glVertex3i(point.x, point.y, z);
              glVertex3i(point1.x, point1.y, z2);
              glVertex3i(point2.x, point2.y, z2);
              glVertex3i(point3.x, point3.y, z);
              glEnd;
          end;



     end;
      SwapBuffers(DC);

  end;

  procedure Destroy3DLog();

  begin
    wglMakeCurrent(0,0);
    wglDeleteContext(hrc);
    ReleaseDC(H,DC);
    DeleteDC(DC);
  end;

  procedure Rotated3DLog(angle: Double);

  begin
     glRotatef(angle,0,0,1);
     InvalidateRect ( H,nil,False );
  end;

  procedure ResizeForm (Width: Integer; Height: Integer);
  begin
    glViewport(0, 0, 500, 500); //выделяем область куда будет выводиться наш буфер
    glMatrixMode ( GL_PROJECTION ); //переходим в матрицу проекции
    glLoadIdentity;  //Сбрасываем текущую матрицу
    glFrustum ( -1 , 1 , -1 , 1 , 1.25 , 100.0 ); //Область видимости
    glMatrixMode ( GL_MODELVIEW ); //переходим в модельную матрицу
    glLoadIdentity;//Сбрасываем текущую матрицу
    gluLookAt(5000,5000,5000,0,0,0,0,0,1);  //позиция наблюдателя
    InvalidateRect ( H,nil,False );  //перерисовка формы
  end;
end.
