unit Unit3DLog;

interface
uses
Winapi.OpenGL, Winapi.Windows, Vcl.Dialogs, UnitLog, System.SysUtils, System.Variants, System.Classes;
   procedure SetDCPixelFormat (hdc : HDC);
   procedure Create3DLog(log: TLog; hendle: HWND );



implementation
   procedure SetDCPixelFormat (hdc : HDC);

  var

    pfd : TPixelFormatDescriptor;
    nPixelFormat : Integer;

  begin

    FillChar (pfd, SizeOf (pfd), 0);

    pfd.dwFlags :=PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;

    nPixelFormat :=ChoosePixelFormat (hdc, @pfd);

    SetPixelFormat(hdc, nPixelFormat, @pfd);

  end;

  procedure Create3DLog(log: TLog; hendle: HWND );
    var
    DC: HDC;
    hrc: HGLRC;
    point, point1, point2, point3: TPointLog;
    i, j, z, z2: Integer;
  begin

    DC:= GetDC(hendle);

    SetDCPixelFormat(DC);

    hrc := wglCreateContext(DC);

    wglMakeCurrent(DC, hrc);

    glClearColor (0.5, 0.5, 0.7, 1.0);

    glMatrixMode (GL_PROJECTION);

    glLoadIdentity;

    glFrustum (-1, 1, -1, 1, 2, 20);

    glMatrixMode (GL_MODELVIEW);

    glLoadIdentity;

    glTranslatef(0.0, 0.0, -6.0);

    glEnable (GL_LIGHTING);

    glEnable (GL_LIGHT0);

    glEnable (GL_DEPTH_TEST);

    glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
     i:=0;

     for i:=0 to log.n-1 do
     begin

     z:=TLogSection(log.sections[i]).z;
     if i < log.n-1 then
     z2 := TLogSection(log.sections[i+1]).z;


         for j:=0 to TLogSection(log.sections[i]).m-1 do
         begin
           if( (j < TLogSection(log.sections[i]).m-1) and (i < log.n-1)) then
           begin
              point := TPointLog(TLogSection(log.sections[i]).points[j]);
              point1 := TPointLog(TLogSection(log.sections[i+1]).points[j]);
              point2 := TPointLog(TLogSection(log.sections[i+1]).points[j+1]);
              point3 := TPointLog(TLogSection(log.sections[i]).points[j+1]);

              glBegin(GL_TRIANGLES);
              glVertex3i(point.x, point.y, z);
              glVertex3i(point1.x, point1.y, z2);
              glVertex3i(point2.x, point2.y, z2);
              glEnd;

              glBegin(GL_TRIANGLES);
              glVertex3i(point.x, point.y, z);
              glVertex3i(point1.x, point1.y, z2);
              glVertex3i(point3.x, point3.y, z);
              glEnd;
            end;
         end;


     end;
    SwapBuffers(DC);

    InvalidateRect(hendle, nil, False);
  end;

end.
