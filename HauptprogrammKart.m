%Dieses Skript führt die gesammte CAM Bahnberechnung durch
%!!!Für Kartesische Werkstücke!!!
%Für jeden Bearbeitungsschritt wird die entsprechende Teilfunktion aufgerufen
%Die Teilfunktione beginnen mit dem Buchsstaben F
%Für die Entwicklung von neuem Programmcode, empfielt sich zuerst nur mit diesem
%Skript ohne Benutzeroberfläche zu arbeiten, weil es übersichtlicher ist.
%In einem zweiten Schritt, kann dann der Programmcode in die
%Benutzeroberfläche integriert werden
%Das Skript zur Benutzeroberfläche lautet LaserCAM.m

clc %Bereinigt das Command Window
clear all %Löscht alle Variabeln
close all %Vernichtet offene Grafikfenster
%format long %Mehr Nachkommastellen werden angezeigt

Schichtdicke=0.1; %Höhenabstand der Schichten in [mm]

Auswahlhoehen=0; %Auswahl der Bearbeitungshöhen (1=ja) (0=nein)
Auswahlhoeheoben=0; %Auswahlhöhe Oben
Auswahlhoeheunten=-0.1; %Auswahlhöhe Unten

Strahlkompensation1=0; %Soll Strahlkompensation1 angewendet werden? (1=ja) (0=nein)
KonturAbstand1=0.05; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]

Umrandung=0; %Soll die umrandungs Kontur abgefahren werden? (1=ja) (0=nein)
UmrandungSkywrite=1; %Soll bei der Umrandung Skywrite verwendet werden? (1=ja) (0=nein)
UmrandungBreakangle=30; %Wird dieser Winkel von Kante zu Kante überschritten, wird Skywrite eingefügt [Grad]
UmrandungSkywritestart=0.5; %Skywritelänge zur Beschleunigung der Spiegel und Galvamotoren [mm]
UmrandungSkywriteend=0.5; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [mm]

Strahlkompensation2=0; %Soll Strahlkompensation2 angewendet werden? (1=ja) (0=nein)
KonturAbstand2=0.5; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]

Schraffur=1; %Sollen die Schraffuren berechnet werden? (1=ja) (0=nein)
Linienabstand=0.005; %Abstand zwischen den Laserbahnen[mm]
SchraffurSkywrite=1; %Soll Skywrite angewendet werden? (1=ja) (0=nein)
SchraffurSkywritestart=0.5; %Skywritelänge zur Beschleunigung der Spiegel und Galvamotoren [mm]
SchraffurSkywriteend=0.5; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [mm]
Schraffurwinkel=0; %Soll ein variabler Schraffurwinkel verwendet werden? (1=ja) (0=nein)
Schraffurwinkelstart=0; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=23; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
Hatchtyp=1; %Linienverlauf der Schraffuren (1=Rechteck) (0=Zickzack)

DStlObjekt=1; %Soll das Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DKontur0=1; %Soll die Schnittkontur Dargestellt werden? (1=ja) (0=nein)
DKontur1=1; %Soll die Kontur nach Strahlkompensation1 Dargestellt werden? (1=ja) (0=nein)
DKontur2=1; %Soll die Kontur nach Strahlkompensation2 Dargestellt werden? (1=ja) (0=nein)
DUmrandung=1; %Soll die Laserbahn der Umrandung Dargestellt werden? (1=ja) (0=nein)
DSchraffur=1; %Soll die Laserbahn der Schraffur Dargestellt werden? (1=ja) (0=nein)
d=1; %Ebene die Dargestellt werden soll

[FileName,PathName] = uigetfile('*.stl','Auswahl des Stl-Objekts');
Pfad=[PathName,FileName];
Titel=[FileName(1:end-4),'NCCode','.txt'];

%Einzelne CodeSchnipsel aus denen der NCCode zusammengestellt wird
NCText.Header1='G90';
NCText.Header2='G359';
NCText.Header3='VELOCITY ON';
NCText.Header4='AIR_ON';
NCText.Header5='F1000';
NCText.Header6='';
NCText.Header7='';
NCText.Header8='';
NCText.Header9='';
NCText.Header10='';
NCText.Fokus1='G00 Z(Fok-';
NCText.Fokus2=')';
NCText.Eilgang1='G00 U';
NCText.Eilgang2=' B';
NCText.Eilgang3='';
NCText.StartSky1='G08 G01 U';
NCText.StartSky2=' B';
NCText.StartSky3='';
NCText.Laser1='G08 G01 U';
NCText.Laser2=' B';
NCText.Laser3='';
NCText.EndSky1='G08 G01 U';
NCText.EndSky2=' B';
NCText.EndSky3='';
NCText.Laseron='GALVO LASEROVERRIDE U ON';
NCText.Laseroff='GALVO LASEROVERRIDE U OFF';
NCText.Kommentar1='//';
NCText.Kommentar2='';
NCText.Finish1='AIR_OFF';
NCText.Finish2='END PROGRAM';
NCText.Finish3='';
NCText.Finish4='';
NCText.Finish5='';

%Funktion, die die Stl-Datei einliest
[f,v,n] = F00_stlread(Pfad); 
fv.vertices=v; %v enthält die Koordinaten der Eckpunkte
fv.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
disp('Stl-Objekt eingelesen');

%Darstellung des Stl-objekts
%figure %Darstellung des STL-Objekts in neuem Grafikfenster
FDStlObjekt(DStlObjekt,fv);
view([-40 50]); %Set a nice view angle

%Funktion, die die Schnitthoehen berechnet wird aufgerufen
[Schnitthoehen,Zoben,Zunten]=F05_Schnitthoehen(v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);

%Funktion, die die Slices macht wird aufgerufen
[Konturen0]=F10_Slicing( f,v,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen0=flipud(Konturen0); %Oberste Schnittebene ist nun im obersten CellArray Eintrag

%Darstellung der Schnittkonturen 
FDSchnittkontur(DKontur0,d,Konturen0);

%Funktion, die die Strahlkompensation 1 berechnet
if Strahlkompensation1==1
    Konturen1=cell(size(Konturen0));
    for k=1:size(Konturen0,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur1=Konturen0(k,:);
        [Kontur1]=F20_Strahlkomp( Kontur1,n,KonturAbstand1 ); %Funktion die die Strahlkompensation berechnet
        Konturen1(k,1:size(Kontur1,2))=Kontur1;
    end
else
    Konturen1=Konturen0;
end

%Darstellung der Schnittlinien mit Strahlkompensation1
FDSchnittkontur(DKontur1,d,Konturen1);

%Funktion, die die Umrandungskontur berechnet
if Umrandung==1
    UmrandungKonturen= F30_Umrandung( Konturen1,UmrandungSkywrite,UmrandungBreakangle,UmrandungSkywritestart,UmrandungSkywriteend);
    disp('Umrandungskontur berechnet');
else
    UmrandungKonturen=cell(size(Konturen1));
end

%Darstellung der Umrandungskontur
FDUmrandung(DUmrandung,d,UmrandungKonturen);

%Funktion, die die Strahlkompensation 2 berechnet
if Strahlkompensation2==1
    Konturen2=cell(size(Konturen1));
    for k=1:size(Konturen1,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur2=Konturen1(k,:);
        [Kontur2]=F20_Strahlkomp( Kontur2,n,KonturAbstand2 ); %Funktion die die Strahlkompensation berechnet
        Konturen2(k,1:size(Kontur2,2))=Kontur2;
    end
else
    Konturen2=Konturen1;
end

%Darstellung der Schnittlinien mit Strahlkompensation2
FDSchnittkontur(DKontur2,d,Konturen2);

%Funktion, die die Schraffuren berechnet
if Schraffur==1
    [Schraffuren]=F40_Schraffuren( Konturen2,Linienabstand,SchraffurSkywrite,SchraffurSkywritestart,SchraffurSkywriteend,Schraffurwinkel,Schraffurwinkelstart,Schraffurwinkelinkrem,Hatchtyp ); 
    disp('Schraffuren berechnet');
else
    Schraffuren=cell(size(Konturen2,1),1);
end

%Darstellung der Schraffuren
FDSchraffur(DSchraffur,d,Schraffuren);

%Berechnung Stloben
Stloben=max(v(:,3));

%Funktion, die den NC-Code erstellt
F50_NCCode(  Schraffuren,Stloben,Schichtdicke,Titel,UmrandungKonturen,NCText );
disp('NC-Code erstellt');

%{
%% Darstellung einer neuen Ebene
clf('reset')
d=1;
FDStlObjekt(DStlObjekt,fv); %Erstellt ein neues Fenster...
view([-40 50]); %Set a nice view angle
FDSchnittkontur(DKontur0,d,Konturen0);
FDSchnittkontur(DKontur1,d,Konturen1);
FDUmrandung(DUmrandung,d,UmrandungKonturen);
FDSchnittkontur(DKontur2,d,Konturen2);
FDSchraffur(DSchraffur,d,Schraffuren);
%}