{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;

Var
  T : TTarget;
  P : TPackage;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('fcl-json');
{$ifdef ALLPACKAGES}
    P.Directory:='fcl-json';
{$endif ALLPACKAGES}
    P.Version:='2.2.2-0';
    P.Dependencies.Add('fcl-base');
    P.Author := 'Michael van Canneyt';
    P.License := 'LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'Json interfacing, part of Free Component Libraries (FCL), FPC''s OOP library.';
    P.NeedLibC:= false;

    P.SourcePath.Add('src');

    T:=P.Targets.AddUnit('fpjson.pp');
    T:=P.Targets.AddUnit('jsonconf.pp');
      with T.Dependencies do
        begin
          AddUnit('fpjson');
          AddUnit('jsonparser');
        end;
    T:=P.Targets.AddUnit('jsonparser.pp');
      with T.Dependencies do
        begin
          AddUnit('fpjson');
          AddUnit('jsonscanner');
        end;
    T:=P.Targets.AddUnit('jsonscanner.pp');

    P.ExamplePath.Add('examples');
    T:=P.Targets.AddExampleProgram('confdemo.pp');
    T:=P.Targets.AddExampleProgram('parsedemo.pp');
    T:=P.Targets.AddExampleProgram('simpledemo.pp');

    // simpledemo.lpi
    // confdemo.lpi
    // parsedemo.lpi

{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}



