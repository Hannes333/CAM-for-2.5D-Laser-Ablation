%Dieses Skript führt die gesammte CAM Bahnberechnung durch 
%!!! für Zylindrische Werkstücke !!! 
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

Schichtdicke=0.01; %Höhenabstand der Schichten in [mm]

Auswahlhoehen=0; %Auswahl der Bearbeitungshöhen (1=ja) (0=nein)
Auswahlhoeheoben=0.925; %Auswahlhöhe Oben
Auswahlhoeheunten=0.9; %Auswahlhöhe Unten

Linienabstand=0.05; %Abstand zwischen den Laserbahnen[mm]
Scangeschw=1000; %Einstellen der Scangeschwindigkeit [mm/s]
VorschubAmax=2700; %Maximale Drehzahl der Drehachse A [°/s]
MinJumplengthY=0.001; %Minimale Länge der Jumplinie in Y-Richtung [mm]
Drehoffsetlength=0.2; %Minimale Länge zwischen den Schraffuren in Drehrichtung [mm]
SchraffurSkywrite=1; %Soll Skywrite angewendet werden? (1=ja) (0=nein)
SchraffurSkywritestart=0.1; %Skywritelänge zur Beschleunigung der Spiegel und Galvamotoren [mm]
SchraffurSkywriteend=0.1; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [mm]
Modus=1; %Startwinkel (1=kleinsmöglicher Winkel) (2=freiwählbarer Winkel) (3=grösstmöglicher Winkel)
Verhaeltnis=0.6; %Verhältnis zwischen Markierlinie zu Jumplinie bei Startwinkelberechnung nach Modus 1
Schraffurwinkelstart=20; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=0; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
WinkelAnpassung=1; %Winkel anpassen damit maximale Drehzahl und Scangeschwindigkeit nicht überschritten und kleinstmöchlier Winkel nicht unterschritten wird (1=ja) (0=nein)

DStlObjekt1=1; %Soll das zylindrische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DStlObjekt2=1; %Soll das kartesische Stl-Objekt Dargestellt werden? (1=ja) (0=nein)
DKontur=1; %Soll die Schnittkontur Dargestellt werden? (1=ja) (0=nein)
DSchraffur=1; %Soll die Laserbahn der Schraffur Dargestellt werden? (1=ja) (0=nein)
d=1; %Ebene die Dargestellt werden soll

[FileName,PathName] = uigetfile('*.stl','Auswahl des Stl-Objekts');
Pfad=[PathName,FileName];
%Pfad='ETHZylinder2mmNegativ.stl';
Titel=[FileName(1:end-4),'NCCode','.txt'];
%Titel='ETHZylinderNCcode.txt';

%Einzelne CodeSchnipsel aus denen der NCCode zusammengestellt wird
NCText.Header1='G90';
NCText.Header2='G359';
NCText.Header3='VELOCITY ON';
NCText.Header4='AIR_ON';
NCText.Header5='';
NCText.Header6='';
NCText.Header7='';
NCText.Header8='';
NCText.Header9='';
NCText.Header10='';
NCText.Fokus1='G08 G01 U';
NCText.Fokus2=' A';
NCText.Fokus3=' Z(zFok+zA+';
NCText.Fokus4=')';
NCText.Vorschub1='F';
NCText.Vorschub2=' //Dominante Geschw [°/s]';
NCText.Eilgang1='G00 U';
NCText.Eilgang2=' A';
NCText.Eilgang3='';
NCText.Laseraus1='G08 G01 U';
NCText.Laseraus2=' A';
NCText.Laseraus3='';
NCText.StartSky1='G08 G01 U';
NCText.StartSky2=' A';
NCText.StartSky3='';
NCText.Laser1='G08 G01 U';
NCText.Laser2=' A';
NCText.Laser3='';
NCText.EndSky1='G08 G01 U';
NCText.EndSky2=' A';
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
disp('Stl-Objekt eingelesen');

%Darstellung des original Stl-Objekts
v1=v; 
v1(:,2)=v1(:,2)*-(360/(2*pi)); %Anpassung der orignal Stldatei an die Skalierung in Grad der Y-Richtung
fv1.vertices=v1; %v enthält die Koordinaten der Eckpunkte
fv1.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt1,fv1,[0.2 0.2 0.8]);
view([45 45]); %Set a nice view angle
camlight(20,225); %Lichtquelle hinzufügen

%Funktion, die die Stl-Datei von Kartesisch- in Zylinderkoordinaten umwandelt
[f2,v2] = F03_Transformation(f,v);
disp('Transformation durchgeführt');

%Darstellung des Stl-Objekts nach der Koordinatentrasformation
fv2.vertices=v2; %v enthält die Koordinaten der Eckpunkte
fv2.faces=f2; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
FD2StlObjekt(DStlObjekt2,fv2,[0.2 0.8 0.8]);

%Funktion, die die Schnitthoehen berechnet wird aufgerufen
[Schnitthoehen,Zoben,Zunten]=F05_Schnitthoehen(v2,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
Zoben 
Zunten
AnzahlSchnittebenen=size(Schnitthoehen,1)

%Funktion, die die Slices macht wird aufgerufen
[Konturen0]=F11_Slicing( f2,v2,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen0=flipud(Konturen0); %Oberste Schnittebene ist nun im obersten CellArray Eintrag

%Darstellung der Schnittkonturen 
FD2Schnittkontur(DKontur,d,Konturen0);

%Funktion, die die Schraffuren berechnet
[Schraffuren,VorschubDominant,Umdrehungen,Winkel]=F41_Schraffuren( Konturen0,Linienabstand,SchraffurSkywrite,SchraffurSkywritestart,SchraffurSkywriteend,Schraffurwinkelstart,Schraffurwinkelinkrem,Verhaeltnis,Scangeschw,VorschubAmax,Drehoffsetlength,Modus,MinJumplengthY,WinkelAnpassung); 
disp('Schraffuren berechnet');

%Darstellung der Schraffuren
FD2Schraffur(DSchraffur,d,Schraffuren);

%Addition der Y-Koordinaten der Schraffuren und den zusätzlichen vollen Umdrehungen
SchraffurenNC=Schraffuren;
for k=1:size(SchraffurenNC,1) %Index, der durch die Ebenen itteriert
    if ~isempty(SchraffurenNC{k})
        SchraffurenNC{k}(:,2)=SchraffurenNC{k}(:,2)+Umdrehungen{k}(:,1);
    end
end

%Funktion, die den NC-Code erstellt
F51_NCCode(SchraffurenNC,Titel,NCText,VorschubDominant);
disp('NC-Code erstellt');

%{
%% Darstellung einer neuen Ebene
cla
d=1; %Ebene die Dargestellt werden soll
FD2StlObjekt(DStlObjekt1,fv1,[0.2 0.2 0.8]); %Erstellt ein neues Fenster...
camlight(20,225); %Lichtquelle hinzufügen
FD2StlObjekt(DStlObjekt2,fv2,[0.2 0.8 0.8]);
FD2Schnittkontur(DKontur,d,Konturen0);
FD2Schraffur(DSchraffur,d,Schraffuren);
%}