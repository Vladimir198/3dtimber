unit UnitLog;
    
interface
uses
    System.SysUtils, System.Variants, System.Classes, Vcl.Dialogs, System.Math, Winapi.OpenGL;
 type

 TPointLog = class
 public
   x:SmallInt;
   y:SmallInt;
 end;

 TLogSection = class
 public
   z:Integer;
   m:Word;
   points: TList;
 end;

 TLog = class
     public
     version, pointInSection, id, d1, dCentr, d2, dTop, lenghtLog, flag: Word;
     n, minZ, maxZ: Integer;
     date: TDateTime;
     curve, reserv: Byte;
     Vf, impulsPrice: Single;
     curveDirection, sbeg, sbegCom, maxX, maxY, minX, minY : SmallInt;
     arrayReserv: array[0..83] of Byte;
     sections: TList;
     arrayIntPolig : array[0..3] of array of Integer;
     procedure Get3dPoligon ();
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
       except
       on E : Exception do
       ShowMessage('Ошибка чтения файла! '+ E.Message);
       end;

   end;

   procedure TLog.Get3dPoligon ();
   var
  point, point1, point2, point3: TPointLog;
  i, j, z1, z2, a: Integer;
  c, xN, yN, zN : Double;
  v1,v2, vN : array [(x, y, z)] of Double;
  begin

    for i:=0 to Self.n-2 do
     begin
        a:= Round(Self.maxZ/2);
        z1:=((TLogSection(Self.sections[i]).z)-a);

        z2 :=(TLogSection(Self.sections[i+1]).z-a);

         for j:=0 to TLogSection(Self.sections[i]).m-2 do
       begin

       end;

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


end.
