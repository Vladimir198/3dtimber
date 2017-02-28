unit UnitLog;
    
interface
uses
    System.SysUtils, System.Variants, System.Classes;
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
   points: array of TPointLog;
 end;

 TLog = class
     public
     version, pointInSection, id, d1, dCentr, d2, dTop, lenghtLog, flag: Word;
     n: Integer;
     date: TDateTime;
     curve, reserv: Byte;
     Vf, impulsPrice: Single;
     curveDirection, sbeg, sbegCom: SmallInt;
     arrayReserv: array[0..83] of Byte;
     sections: array of TLogSection;

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
       for i:=0 to n-1 do
       begin
        section := TLogSection.Create();

         BlockRead(f, section.z, 4);
         byteCounter:= byteCounter+4;
         Seek(f,byteCounter);
         BlockRead(f, section.m, 2);
         byteCounter:= byteCounter+2;

         Seek(f,byteCounter);
         for j:=0 to section.m-1 do
         begin
           point := TPointLog.Create();
           BlockRead(f, point.x, 2);
           byteCounter:= byteCounter+2;
           Seek(f,byteCounter);
           BlockRead(f, point.y, 2);
           byteCounter:= byteCounter+2;
           Seek(f,byteCounter);
            sections[i].points[j]:=point;
         end;
         sections[i]:=section;
       end;



       CloseFile(f);
   end;
end.
