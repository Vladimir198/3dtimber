unit Unit3DLog;

interface

uses
Winapi.OpenGL, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, UnitLog, System.SysUtils,
System.Variants, System.Classes, System.Math;

  procedure SetPropertyGL(handle : HWND; BGCRed, BGCGreen, BGCBlue, BGCAlpha : Single);
  procedure DestroyGL();
  procedure RotateLog(multiplierX, multiplierY: Integer);
  procedure CreateLog3DGL(log : TLog);
  procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  procedure Zumm(multiplier : Integer);
  procedure SetLineMode();
  procedure SetFillMode();
  procedure Create3DSection (log : TLog; n : Integer);
  procedure CreateTriangle ();
var
 H: HWND;
 DC: HDC;
 hrc: HGLRC;
 vLeft, vRight, vBottom, vTop, vNear, vFar, HWidth, HHeight, zumm1: Integer;
 angleX, angleY : Double;
 viewTriger : (Perspectiva,Orto) = Perspectiva;
 quadObj : GLUquadricObj;
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
   const
      LightAmbient: array [0..3] of GLfloat = (0.5, 0.5, 0.5, 1.0);  // Ambient Light Values
      LightDiffuse: array [0..3] of GLfloat = (0.5, 0.5, 0.5, 1.0);  // Diffuse Light Values
      LightPosition: array [0..3] of GLfloat = (100, 100, 100.0, 1.0);
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

     glEnable(GL_SCISSOR_TEST);

     //glEnable(GL_AUTO_NORMAL);
     glEnable(GL_SMOOTH);
     glEnable(GL_COLOR_MATERIAL);
      glEnable(GL_LIGHTING);
      glLightfv(GL_LIGHT0, GL_AMBIENT, @LightAmbient[0]);				// Setup The Ambient Light
      glLightfv(GL_LIGHT0, GL_DIFFUSE, @LightDiffuse[0]);				// Setup The Diffuse Light
      glLightfv(GL_LIGHT0, GL_POSITION,@LightPosition[0]);			// Position The Light
      glEnable(GL_LIGHT0);							// Enable Light One
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
  i, j, z1, z2, a: Integer;
  c, xN, yN, zN : Double;
  v1,v2, vN : array [(x, y, z)] of Double;
  begin
    glClear (GL_COLOR_BUFFER_BIT);
    for i:=0 to log.n-2 do
     begin
        a:= Round(log.maxZ/2);
        z1:=((TLogSection(log.sections[i]).z)-a);

        z2 :=(TLogSection(log.sections[i+1]).z-a);

         for j:=0 to TLogSection(log.sections[i]).m-2 do
       begin
            point := TPointLog(TLogSection(log.sections[i]).points[j]);
            point1 := TPointLog(TLogSection(log.sections[i+1]).points[j]);
            point2 := TPointLog(TLogSection(log.sections[i+1]).points[j+1]);
            point3 := TPointLog(TLogSection(log.sections[i]).points[j+1]);
            v1[x] := point.x-point1.x;
            v1[y] := point.y-point1.y;
            v1[z] := z1-z2;

            v2[x] := point2.x-point1.x;
            v2[y] := point2.y-point1.y;
            v2[z] := z2-z2;

//            vN[x] := v1[y]*v2[z]-v1[y]*v2[y];
//            vN[y] := v1[z]*v2[x]-v1[x]*v2[z];
//            vN[z] := v1[x]*v2[y]-v1[y]*v2[x];
//
            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];
//
            c := Sqrt((vN[x]*vN[x])+(vN[y]*vN[y])+(vN[z]*vN[z])); //для нохождения еденичной нормали

            glBegin(GL_TRIANGLES);
            glColor3f(0.7,0.7,0.4);
            glNormal3d((vN[x]),(vN[y]),(vN[z])); //еденичный вектор нормали
            glVertex3i(point1.x, point1.y, z2);
            glVertex3i(point.x, point.y, z1);
            glVertex3i(point2.x, point2.y, z2);
            glEnd;
            if c=0 then c:=1;
            glBegin(GL_LINES);
            glColor3f(1.0,1.0,1.0);
            glVertex3d(point1.x, point1.y, z2);
            glVertex3d(((vN[x]/c)+point1.x),((vN[y]/c)+point1.y),((vN[z]/c)+z2));
            glEnd;

            v1[x] := point.x-point3.x;
            v1[y] := point.y-point3.y;
            v1[z] := z1-z2;

            v2[x] := point2.x-point3.x;
            v2[y] := point2.y-point3.y;
            v2[z] := z2-z1;

            vN[x] := v1[y]*v2[z]-v1[y]*v2[y];
            vN[y] := v1[z]*v2[x]-v1[x]*v2[z];
            vN[z] := v1[x]*v2[y]-v1[y]*v2[x];

//            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
//            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
//            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];

            //c := Sqrt((vN[x]*vN[x])+(vN[y]*vN[y])+(vN[z]*vN[z])); //для нохождения еденичной нормали

            glBegin(GL_TRIANGLES);
            glColor3f(0.7,0.7,0.4);
            glNormal3d((vN[x]),(vN[y]),(vN[z])); //еденичный вектор нормали
            glVertex3i(point3.x, point3.y, z1);
            glVertex3i(point2.x, point2.y, z2);
            glVertex3i(point.x, point.y, z1);
            glEnd;
             if c=0 then c:=1;
            glBegin(GL_LINES);
            glColor3f(1.0,1.0,1.0);
            glVertex3d(point3.x, point3.y, z1);
            glVertex3d(((vN[x])+point3.x),((vN[y])+point3.y),((vN[z])+z1));
            glEnd;


            if j = TLogSection(log.sections[i]).m-2 then
            begin
              point := TPointLog(TLogSection(log.sections[i]).points[j+1]);
              point1 := TPointLog(TLogSection(log.sections[i+1]).points[j+1]);
              point2 := TPointLog(TLogSection(log.sections[i+1]).points[0]);
              point3 := TPointLog(TLogSection(log.sections[i]).points[0]);
//              xN := point.y*(z2-z2) + point1.y*(z2-z) + point2.y*(z-z2);
//              yN := z*(point1.x - point2.x) + z2*(point2.x-point.x) + z2*(point.x-point1.x);
//              zN := point.x*(point1.y - point2.y) + point1.x*(point2.y-point.y) + point2.x*(point.y-point1.y);
//              c := Sqrt(xN*xN+yN*yN+zN*zN);


              glBegin(GL_TRIANGLES);
              glColor3f(0.7,0.7,0.4);
              //glNormal3d((xN/c),(yN/c),(zN/c));
              glVertex3i(point.x, point.y, z1);
              glVertex3i(point1.x, point1.y, z2);
              glVertex3i(point2.x, point2.y, z2);
              glEnd;

              glBegin(GL_LINES);
              glColor3f(1.0,1.0,1.0);
              glVertex3d(point.x, point.y, z1);
              glVertex3d((vN[x])*point1.x,(vN[y])*point1.y,(vN[z])*z2);
              glEnd;

              glBegin(GL_TRIANGLES);
              glColor3f(0.7,0.7,0.4);
              //glNormal3d((xN/c),(yN/c),(zN/c)); //еденичный вектор нормали
              glVertex3i(point.x, point.y, z1);
              glVertex3i(point2.x, point2.y, z2);
              glVertex3i(point3.x, point3.y, z1);
              glEnd;
            end;

        end;
     end;

     SwapBuffers(DC);
  end;

  procedure Create3DSection (log : TLog; n : Integer);
  var
  point, point1, point2, point3: TPointLog;
  i, z1, z2, a: Integer;
  c: Double;
  v1,v2, vN : array [(x, y, z)] of Double;
  begin
  z1 := 0;
  z2 := 100;//TLogSection(log.sections[n+1]).z - TLogSection(log.sections[n]).z;
  glClear (GL_COLOR_BUFFER_BIT);
//       for i:=0 to TLogSection(log.sections[n]).m-2 do
//       begin
              point := TPointLog.Create;
              point1 := TPointLog.Create;
              point2 :=TPointLog.Create;
//            point := TPointLog(TLogSection(log.sections[n]).points[33]);
//            point1 := TPointLog(TLogSection(log.sections[n+1]).points[33]);
//            point2 := TPointLog(TLogSection(log.sections[n+1]).points[33+1]);
//            point3 := TPointLog(TLogSection(log.sections[n]).points[33+1]);
             point.x := 100;
             point.y := 0;
             point1.x := 0;
             point1.y := 100;
             point2.x := 0;
             point2.y:=0;

            v1[x] := point.x-point1.x;
            v1[y] := point.y-point1.y;
            v1[z] := z1-z2;

            v2[x] := point2.x-point1.x;
            v2[y] := point2.y-point1.y;
            v2[z] := z2-z2;

//            vN[x] := v1[y]*v2[z]-v1[y]*v2[y];
//            vN[y] := v1[z]*v2[x]-v1[x]*v2[z];
//            vN[z] := v1[x]*v2[y]-v1[y]*v2[x];
//
            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];
//
            c := Sqrt((vN[x]*vN[x])+(vN[y]*vN[y])+(vN[z]*vN[z])); //для нохождения еденичной нормали

            glBegin(GL_TRIANGLES);
            glColor3f(0.7,0.7,0.4);
            glNormal3d((vN[x]),(vN[y]),(vN[z])); //еденичный вектор нормали
            glVertex3i(point1.x, point1.y, z2);
            glVertex3i(point.x, point.y, z1);
            glVertex3i(point2.x, point2.y, z2);
            glEnd;

            glBegin(GL_LINES);
             glVertex3d(0, 0, 0);
             glVertex3d(1000, 0, 0);
             glVertex3d(0, 0, 0);
             glVertex3d(0, 1000, 0);
             glVertex3d(0, 0, 0);
             glVertex3d(0, 0, 1000);
            //glColor3f(1.0,1.0,1.0);
           //glVertex3d(point1.x, point1.y, z2);
           // glVertex3d(((vN[x])+point1.x),((vN[y])+point1.y),((vN[z])+z2));
            glEnd;

//            v1[x] := point.x-point3.x;
//            v1[y] := point.y-point3.y;
//            v1[z] := z1-z2;
//            v2[x] := point2.x-point3.x;
//            v2[y] := point2.y-point3.y;
//            v2[z] := z2-z1;
//
//            vN[x] := v1[y]*v2[z]-v1[y]*v2[y];
//            vN[y] := v1[z]*v2[x]-v1[x]*v2[z];
//            vN[z] := v1[x]*v2[y]-v1[y]*v2[x];
//
////            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
////            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
////            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];
//
//            //c := Sqrt((vN[x]*vN[x])+(vN[y]*vN[y])+(vN[z]*vN[z])); //для нохождения еденичной нормали
//
//            glBegin(GL_TRIANGLES);
//            glColor3f(0.7,0.7,0.4);
//            glNormal3d((vN[x]),(vN[y]),(vN[z])); //еденичный вектор нормали
//            glVertex3i(point3.x, point3.y, z1);
//            glVertex3i(point2.x, point2.y, z2);
//            glVertex3i(point.x, point.y, z1);
//            glEnd;
//
//            glBegin(GL_LINES);
//            glColor3f(1.0,1.0,1.0);
//            glVertex3d(point3.x, point3.y, z1);
//            glVertex3d(((vN[x])+point3.x),((vN[y])+point3.y),((vN[z])+z1));
//            glEnd;
   // end;
  SwapBuffers(DC);
  end;

  procedure CreateTriangle ();

     var
  point, point1, point2, point3: TPointLog;
  i, z1, z2, a: Integer;
  c: Double;
  v1,v2, vN : array [(x, y, z)] of Double;
  begin
  z1 := 0;
  z2 := 0;
  glClear (GL_COLOR_BUFFER_BIT);

              point := TPointLog.Create;
              point1 := TPointLog.Create;
              point2 :=TPointLog.Create;

             point.x := 100;
             point.y := 0;
             point1.x := 0;
             point1.y := 100;
             point2.x := 0;
             point2.y:=0;

            v1[x] := point.x-point1.x;
            v1[y] := point.y-point1.y;
            v1[z] := z1-z2;

            v2[x] := point2.x-point1.x;
            v2[y] := point2.y-point1.y;
            v2[z] := z2-z2;

//            vN[x] := v1[y]*v2[z]-v1[z]*v2[y];
//            vN[y] := v1[z]*v2[x]-v1[x]*v2[z];
//            vN[z] := v1[x]*v2[y]-v1[y]*v2[x];
//
            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];
//
            c :=Sqrt((vN[x]*vN[x])+(vN[y]*vN[y]+(vN[z]*vN[z]))); //для нохождения еденичной нормали

            glBegin(GL_TRIANGLES);
            glColor3f(0.7,0.7,0.4);
            glNormal3d(((vN[x])/c),((vN[y])/c),((vN[z])/c)); //еденичный вектор нормали
            glVertex3d(point1.x, point1.y, z2);
            glVertex3d(point2.x, point2.y, z2);
            glVertex3d(point.x, point.y, z1);
            glEnd;

            glBegin(GL_LINES);
             glVertex3d(0, 0, 0);
             glVertex3d(10000, 0, 0);
             glVertex3d(0, 0, 0);
             glVertex3d(0, 10000, 0);
             glVertex3d(0, 0, 0);
             glVertex3d(0, 0, 10000);
            glColor3f(1.0,1.0,1.0);
            glVertex3d(point1.x, point1.y, z2);
            glVertex3d(((vN[x])/c)+point1.x,((vN[y])/c)+point1.y,((vN[z])/c)+z2);
            glEnd;

//
  SwapBuffers(DC);
  end;

   procedure FormResizeGL(Width, Height,  xLeft1, yTop1 : Integer);
  begin
    HWidth := Width;
    HHeight := Height;
    glViewport(xLeft1, yTop1, Width, Height);
    glScissor(xLeft1, yTop1, Width, Height);
    glLoadIdentity;
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
    gluPerspective(30,           // угол видимости в направлении оси Y
                Width / Height, // угол видимости в направлении оси X
                10,            // расстояние от наблюдателя до ближней плоскости отсечения
                60000);
    gluLookAt (0, zumm1+3000, zumm1+3000, 0.0, 0.0, 0.0, 0, 1, 0);
    //glTranslatef(0.0, 0.0, 0.0);   // перенос объекта - ось Z
    glRotated(angleX, 0.0, 1.0,0.0);
    glRotated(angleY, 1.0, 0.0,0.0);
    InvalidateRect(H, nil, False);
  end;
end.
