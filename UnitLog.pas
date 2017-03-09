unit UnitLog;
    
interface
uses
    System.SysUtils, System.Variants, System.Classes, Vcl.Dialogs, System.Math, Winapi.OpenGL;
 type

 TPointLog = class
 public
   x:SmallInt;
   y:SmallInt;
   z:Integer;
 end;
 TNormalV = class
   public
   x:Double;
   y:Double;
   z:Double;
 end;
 TLogSection = class
 public
   z:Integer;
   m:Word;
   points: TList;
 end;

 TLog = class
     private
     procedure SetNormal();
     procedure SetPoint3D();
     public
     version, pointInSection, id, d1, dCentr, d2, dTop, lenghtLog, flag: Word;
     n: Integer;
     date: TDateTime;
     curve, reserv: Byte;
     Vf, impulsPrice: Single;
     curveDirection, sbeg, sbegCom : SmallInt;
     maxX, maxY, minX, minY, minZ, maxZ :Double;
     arrayReserv: array[0..83] of Byte;
     sections, pointList3D, normalList3D: TList;

     function GetProertyList(): TStringList;
     constructor Create(path: string);

end;

implementation

   constructor TLog.Create(path: string);
   var
   f: file;
   i, j, byteCounter: Integer;
   section: TLogSection;
   point: TPointLog;
   begin
       try
       AssignFile(f, path);
       FileMode:= fmOpenRead;
       Reset(f,1);

       BlockRead(f,version,2);
       Seek(f,2);
       BlockRead(f,n,4);
       Seek(f,6);
       BlockRead(f,pointInSection,2);
       Seek(f,8);
       BlockRead(f,id,2);
       Seek(f,10);
       BlockRead(f,date,8);
       Seek(f,18);
       BlockRead(f,d1,2);
       Seek(f,20);
       BlockRead(f,dCentr,2);
       Seek(f,22);
       BlockRead(f,d2,2);
       Seek(f,24);
       BlockRead(f,dTop,2);
       Seek(f,26);
       BlockRead(f,lenghtLog,2);
       Seek(f,28);
       BlockRead(f,curve,1);
       Seek(f,29);
       BlockRead(f,reserv,1);
       Seek(f,30);
       BlockRead(f,curveDirection,2);
       Seek(f,32);
       BlockRead(f,sbeg,2);
       Seek(f,34);
       BlockRead(f,sbegCom,2);
       Seek(f,36);
       BlockRead(f,Vf,4);
       Seek(f,40);
       BlockRead(f, flag, 2);
       Seek(f,42);
       BlockRead(f, impulsPrice, 4);
       Seek(f,46);


       for i:=0 to 83 do
       begin
         BlockRead(f, arrayReserv[i], 1);
         Seek(f,46 + i+1);
       end;
       byteCounter := 130;
       sections:= TList.Create();
       for i:=0 to n-1 do
       begin
         section := TLogSection.Create();

         BlockRead(f, section.z, 4);
         byteCounter:= byteCounter+4;
         Seek(f,byteCounter);
         BlockRead(f, section.m, 2);
         byteCounter:= byteCounter+2;
         Seek(f,byteCounter);
         sections.Add(section);
         TLogSection(sections[i]).points:= TList.Create();
         if i=0 then
         begin
           maxZ := section.z;
           minZ := section.z;
         end;
         minZ := Min(minZ, section.z);
         maxZ := Max( section.z, maxZ);
         for j:=0 to section.m-1 do
         begin

           point := TPointLog.Create();
           BlockRead(f, point.x, 2);
           byteCounter:= byteCounter+2;
           Seek(f,byteCounter);
           BlockRead(f, point.y, 2);
           byteCounter:= byteCounter+2;
           Seek(f,byteCounter);
           point.z := section.z;
           TLogSection(sections[i]).points.Add(point);

           if j=0 then
           begin
             maxX := point.x;
             minX := point.x;
             maxY := point.y;
             minY := point.y;
            end;

           minX := Min(minX, point.x);
           maxX := Max(point.x, maxX);
           minY := Min(minY, point.y);
           maxY := Max(point.y, maxY);

         end;


       end;
       CloseFile(f);
       SetPoint3D();
       SetNormal();
       except
       on E : Exception do
       ShowMessage('Ошибка чтения файла! '+ E.Message);
       end;

   end;

  function TLog.GetProertyList(): TStringList;
  var
  propertyList: TStringList;
  s: string;

  begin
   propertyList:= TStringList.Create();
   s:= 'Индекс бревна: ' + Self.id.ToString();
   propertyList.Add(s);
   s:= 'Диаметр первого торца (мм): ' + Self.d1.ToString();
   propertyList.Add(s);
   s:= 'Диаметр середины бревна (мм): ' + Self.dCentr.ToString();
   propertyList.Add(s);
   s:= 'Диаметр второго торца (мм): ' + Self.d2.ToString();
   propertyList.Add(s);
   s:= 'Диаметр вершины торца (мм): ' + Self.dTop.ToString();
   propertyList.Add(s);
   s:= 'Длина бревна (см): ' + Self.lenghtLog.ToString();
   propertyList.Add(s);
   s:= 'Физический объем (м. куб): ' + roundto( Self.Vf,-3).ToString();
   propertyList.Add(s);
   s:= 'Кривизна (%): ' + (Self.curve/10).ToString();
   propertyList.Add(s);
   Result:= propertyList;
  end;

  procedure TLog.SetPoint3D();
  var
  i, j, z1, z2, a : Integer;

  point : TPointLog;
  begin
    Self.pointList3D := TList.Create;
    a:= Round(Self.maxZ/2);
    for i:=0 to Self.n-2 do
    begin
        z1:=(TLogSection(Self.sections[i]).z-a);
        z2 :=(TLogSection(Self.sections[i+1]).z-a);

        for j:=0 to TLogSection(Self.sections[i]).m-2 do
        begin
            point := TPointLog(TLogSection(Self.sections[i+1]).points[j]);
            point.z :=z2;
            Self.pointList3D.Add(point);
            point := TPointLog(TLogSection(Self.sections[i]).points[j]);
            point.z :=z1;
            Self.pointList3D.Add(point);
            point := TPointLog(TLogSection(Self.sections[i+1]).points[j+1]);
            point.z :=z2;
            Self.pointList3D.Add(point);

            point := TPointLog(TLogSection(Self.sections[i]).points[j+1]);
            point.z :=z1;
            Self.pointList3D.Add(point);
            point := TPointLog(TLogSection(Self.sections[i+1]).points[j+1]);
            point.z :=z2;
            Self.pointList3D.Add(point);
            point := TPointLog(TLogSection(Self.sections[i]).points[j]);
            point.z :=z1;
            Self.pointList3D.Add(point);

            if j= TLogSection(Self.sections[i]).m-2 then
            begin
              point := TPointLog(TLogSection(Self.sections[i+1]).points[j+1]);
              point.z :=z2;
              Self.pointList3D.Add(point);
              point := TPointLog(TLogSection(Self.sections[i]).points[j+1]);
              point.z :=z1;
              Self.pointList3D.Add(point);
              point := TPointLog(TLogSection(Self.sections[i+1]).points[0]);
              point.z :=z2;
              Self.pointList3D.Add(point);

              point := TPointLog(TLogSection(Self.sections[i]).points[0]);
              point.z :=z1;
              Self.pointList3D.Add(point);
              point := TPointLog(TLogSection(Self.sections[i+1]).points[0]);
              point.z :=z2;
              Self.pointList3D.Add(point);
              point := TPointLog(TLogSection(Self.sections[i]).points[j+1]);
              point.z :=z1;
              Self.pointList3D.Add(point);
            end;
        end;
      end;
  end;

  procedure TLog.SetNormal();
  var
  point, point1, point2: TPointLog;
  normalV : TNormalV;
  counter: Integer;
  c : Double;
  v1,v2, vN : array [(x, y, z)] of Double;
  begin
    Self.normalList3D := TList.Create();
     counter :=0;
         while counter < Self.pointList3D.Count do
       begin
            normalV := TNormalV.Create();
            point := Self.pointList3D[counter];
            counter:= counter+1;
            point1 := Self.pointList3D[counter];
            counter:= counter+1;
            point2 := Self.pointList3D[counter];
            counter:= counter+1;

            v1[x] := point1.x-point.x;
            v1[y] := point1.y-point.y;
            v1[z] := point1.z-point.z;

            v2[x] := point2.x-point.x;
            v2[y] := point2.y-point.y;
            v2[z] := point2.z-point.z;

            vN[x] := v1[z]*v2[y]-v1[y]*v2[z];
            vN[y] := v1[x]*v2[z]-v1[z]*v2[x];
            vN[z] := v1[y]*v2[x]-v1[x]*v2[y];

            c := Sqrt((vN[x]*vN[x])+(vN[y]*vN[y])+(vN[z]*vN[z])); //для нохождения еденичной нормали
            normalV.x:= vN[x]/c;
            normalV.y:= vN[y]/c;
            normalV.z:= vN[z]/c;
            Self.normalList3D.Add(normalV);
        end;
     end;

end.
