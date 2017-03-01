unit Unit3DLog;

interface
uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils, System.Variants, System.Classes;


   procedure SetDCPixelFormat (dc : HDC);
   procedure Rotated3DLog(angle: Double; log: TLog; form: TForm);
   procedure Create3DLog(log: TLog; handle: HWND );
   procedure Destroy3DLog();
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

  procedure Create3DLog(log: TLog; handle: HWND );
    var
    point, point1, point2, point3: TPointLog;
    i, j, z, z2: Integer;
  begin
    Destroy3DLog();
    H:= handle;
    DC:= GetDC(handle);

    SetDCPixelFormat(DC);

    hrc := wglCreateContext(DC);

    wglMakeCurrent(DC, hrc);

    glClearColor (0.4, 0.7, 0.7, 1.0);

    glMatrixMode (GL_PROJECTION);

    glLoadIdentity;

    glFrustum (-3000, 3000, -3000, 3000, 2, 300);

    glMatrixMode (GL_MODELVIEW);

    glLoadIdentity;

    //glTranslatef(0.0, 0.0, -6.0);
    glTranslated(0,0,-5);

    glEnable (GL_LIGHTING);

    glEnable (GL_LIGHT0);

    glEnable (GL_DEPTH_TEST);

    glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

     //glRotated(45,0.1,1.0,0.0);
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
        //


     end;
      //glRotatef(30.0,0.0,1.0,0.0);

      SwapBuffers(DC);

      InvalidateRect(handle, nil, False);
  end;

  procedure Destroy3DLog();

  begin
    wglMakeCurrent(0,0);
    wglDeleteContext(hrc);
    ReleaseDC(H,DC);
    DeleteDC(DC);
  end;

  procedure Rotated3DLog(angle: Double; log: TLog; form: TForm);

  begin
     glRotatef(angle,0,0,1);
     Create3DLog(log,form.Handle);
  end;
end.
