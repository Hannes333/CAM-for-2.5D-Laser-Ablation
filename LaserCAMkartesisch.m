function varargout = LaserCAMkartesisch(varargin)
% Dies ist das Skript zum Fenster LaserCAMkartesisch.fig
% In diesem Code werden alle Eingaben die auf dem LaserCAMkartesisch.fig getätigt
% werden ausgewertet.
% Aus diesem Skript kann ein weiteres Skript aufgerufen namens NCCodekartesisch.m
% Das entsprechende Fenster zu NCCodekartesisch.m lautett NCCodekartesisch.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserCAMkartesisch_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserCAMkartesisch_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LaserCAMkartesisch is made visible.
function LaserCAMkartesisch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LaserCAMkartesisch (see VARARGIN)

clc %Bereinigt das Command Window

% Globales Struct zur Übergabe der Variabeln wird erstellt
global Var

%Ausgangsvariabeln werden definiert
Schichtdicke=0.001; %Höhenabstand der Schichten in [mm]
Strahlkompensation1=0; %Soll Strahlkompensation1 angewendet werden? (1=ja) (0=nein)
KonturAbstand1=0.001; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]
Umrandung=0; %Soll die umrandungs Kontur abgefahren werden? (1=ja) (0=nein)
UmrandungSkywrite=0; %Soll bei der Umrandung Skywrite verwendet werden? (1=ja) (0=nein)
UmrandungBreakangle=30; %Wird dieser Winkel von Kante zu Kante überschritten, wird Skywrite eingefügt [Grad]
UmrandungSkywritestart=0.3; %Skywrite zur Beschleunigung der Spiegel und Galvamotoren [µs]
UmrandungSkywriteend=0.3; %Skywritelänge zur Abbremsung der Spiegel und Galvamotoren [µs]
Strahlkompensation2=0; %Soll Strahlkompensation2 angewendet werden? (1=ja) (0=nein)
KonturAbstand2=0.002; %Um diesen Abstand wird die Aussenkontur nach Innen verschoben [mm]
Schraffur=0; %Sollen die Schraffuren berechnet werden? (1=ja) (0=nein)
Linienabstand=0.005; %Abstand zwischen den Laserbahnen[mm]
SchraffurSkywrite=0; %Soll Skywrite angewendet werden? (1=ja) (0=nein)
SchraffurSkywritestart=0.3; %Skywrite zur Beschleunigung der Spiegel und Galvamotoren [µs]
SchraffurSkywriteend=0.3; %Skywrite zur Abbremsung der Spiegel und Galvamotoren [µs]
Schraffurwinkel=0; %Sollen Schraffurwinkel verwendet werden? (1=ja) (0=nein)
Schraffurwinkelstart=0; %Richtungswinkel der ersten Schraffur [Grad]
Schraffurwinkelinkrem=23; %Richtungswinkel der darauf folgenden Schraffuren [Grad]
Hatchtyp=1; %Linienverlauf der Schraffuren (1=Rechteck) (0=Zickzack)

%Ausgangsvariabeln werden auf den Feldern eingefügt
set(handles.edit5,'String',num2str(Schichtdicke));
set(handles.checkbox2,'Value',Strahlkompensation1);
set(handles.edit7,'String',num2str(KonturAbstand1));
set(handles.checkbox3,'Value',Umrandung);
set(handles.checkbox4,'Value',UmrandungSkywrite);
set(handles.edit9,'String',num2str(UmrandungBreakangle));
set(handles.edit10,'String',num2str(UmrandungSkywritestart));
set(handles.edit11,'String',num2str(UmrandungSkywriteend));
set(handles.checkbox5,'Value',Strahlkompensation2);
set(handles.edit12,'String',num2str(KonturAbstand2));
set(handles.checkbox6,'Value',Schraffur);
set(handles.edit13,'String',num2str(Linienabstand));
set(handles.checkbox7,'Value',SchraffurSkywrite);
set(handles.edit15,'String',num2str(SchraffurSkywritestart));
set(handles.edit16,'String',num2str(SchraffurSkywriteend));
set(handles.checkbox8,'Value',Schraffurwinkel);
set(handles.edit17,'String',num2str(Schraffurwinkelstart));
set(handles.edit18,'String',num2str(Schraffurwinkelinkrem));

%Einige Ausgangsvariabeln werden als globale Variabeln gespeichert
Var.Schichtdicke=Schichtdicke;
Var.KonturAbstand1=KonturAbstand1;
Var.UmrandungBreakangle=UmrandungBreakangle;
Var.UmrandungSkywritestart=UmrandungSkywritestart;
Var.UmrandungSkywriteend=UmrandungSkywriteend;
Var.KonturAbstand2=KonturAbstand2;
Var.Linienabstand=Linienabstand;
Var.SchraffurSkywritestart=SchraffurSkywritestart;
Var.SchraffurSkywriteend=SchraffurSkywriteend;
Var.Schraffurwinkelstart=Schraffurwinkelstart;
Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
Var.Hatchtyp=Hatchtyp;

%Ausgangswerte zum NC-Code werden definiert
Var.NCText.Header1='G90';
Var.NCText.Header2='G359';
Var.NCText.Header3='VELOCITY ON';
Var.NCText.Header4='AIR_ON';
Var.NCText.Header5='F1000';
Var.NCText.Header6='';
Var.NCText.Header7='';
Var.NCText.Header8='';
Var.NCText.Header9='';
Var.NCText.Header10='';
Var.NCText.Fokus1='G00 Z(Fok-';
Var.NCText.Fokus2=')';
Var.NCText.Eilgang1='G00 U';
Var.NCText.Eilgang2=' B';
Var.NCText.Eilgang3='';
Var.NCText.StartSky1='G08 G01 U';
Var.NCText.StartSky2=' B';
Var.NCText.StartSky3='';
Var.NCText.Laser1='G08 G01 U';
Var.NCText.Laser2=' B';
Var.NCText.Laser3='';
Var.NCText.EndSky1='G08 G01 U';
Var.NCText.EndSky2=' B';
Var.NCText.EndSky3='';
Var.NCText.Laseron='GALVO LASEROVERRIDE U ON';
Var.NCText.Laseroff='GALVO LASEROVERRIDE U OFF';
Var.NCText.Kommentar1='//';
Var.NCText.Kommentar2='';
Var.NCText.Finish1='AIR_OFF';
Var.NCText.Finish2='END PROGRAM';
Var.NCText.Finish3='';
Var.NCText.Finish4='';
Var.NCText.Finish5='';

%Pfad mit Titel, wo der NC-Code gespeichert wird
Var.Titelpfad='';

%Alle Felder bis auf den STL-Datei importieren Button müssen inaktiv sein
set(handles.checkbox1,'Enable','off');
set(handles.edit3,'Enable','off');
set(handles.edit4,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.checkbox2,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.checkbox3,'Enable','off');
set(handles.checkbox4,'Enable','off');
set(handles.edit9,'Enable','off');
set(handles.edit10,'Enable','off');
set(handles.edit11,'Enable','off');
set(handles.checkbox5,'Enable','off');
set(handles.edit12,'Enable','off');
set(handles.checkbox6,'Enable','off');
set(handles.edit13,'Enable','off');
set(handles.checkbox7,'Enable','off');
set(handles.edit15,'Enable','off');
set(handles.edit16,'Enable','off');
set(handles.checkbox8,'Enable','off');
set(handles.edit17,'Enable','off');
set(handles.edit18,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.checkbox9,'Enable','off');
set(handles.checkbox10,'Enable','off');
set(handles.checkbox11,'Enable','off');
set(handles.checkbox12,'Enable','off');
set(handles.checkbox13,'Enable','off');
set(handles.checkbox14,'Enable','off');
set(handles.slider1,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton7,'Enable','off');
set(handles.pushbutton8,'Enable','off');
set(handles.edit22,'Enable','off');
set(handles.pushbutton10,'Enable','off');
set(handles.pushbutton11,'Enable','off');

% Choose default command line output for LaserCAMkartesisch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserCAMkartesisch wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = LaserCAMkartesisch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Wird ausgeführt nach Benutzung von Button Stl-Datei importieren
function pushbutton1_Callback(hObject, eventdata, handles)
global Var

[FileName,PathName] = uigetfile('*.stl','Auswahl der Stl-Datei');
if ischar(FileName) && ischar(PathName)
    Pfad=[PathName,FileName];
    Titel=[FileName(1:end-4),'NCCode'];
    Var.Titel=Titel;
    
    %Funktion, die die Stl-Datei einliest
    [f,v,n] = F00_stlread(Pfad); 
    fv.vertices=v; %v enthält die Koordinaten der Eckpunkte
    fv.faces=f; %f sagt, welche drei Eckpunkte aus v ein Dreieck bilden
    %Übergabe der Variablen
    Var.v=v;
    Var.n=n;
    Var.f=f;
    Var.fv=fv;
    disp('Stl-Objekt eingelesen');

    %Ausgabe Höchster Punkt Stl-Datei und Tiefster Punkt Stl-Datei
    Stloben=max(v(:,3)); %Z-Koordinate des höchstgelegensten Stl-Objekt Punktes [mm]
    Stlunten=min(v(:,3)); %Z-Koordinate des tiefstgelegensten Stl-Objekt Punktes [mm]
    set(handles.edit1,'String',Stloben);
    set(handles.edit2,'String',Stlunten);
    Var.Stloben=Stloben;

    %Darstellung des Stl-objekts
    cla %Grafik zurücksetzen
    FDStlObjekt(1,fv);
    view([-40 50]); %Set a nice view angle

    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=0;
    Auswahlhoeheoben=Stloben;
    Auswahlhoeheunten=Stlunten;
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);

    %Häcken werden auf aus zurückgesetzt
    set(handles.checkbox9,'Value',0);
    set(handles.checkbox10,'Value',0);
    set(handles.checkbox11,'Value',0);
    set(handles.checkbox12,'Value',0);
    set(handles.checkbox13,'Value',0);
    set(handles.checkbox14,'Value',0);
    
    %Entsprechende Felder auf dem GUI müssen auswählbar sein
    set(handles.checkbox1,'Enable','on');
    set(handles.checkbox1,'Value',0);
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off');
    set(handles.edit5,'Enable','on');
    set(handles.checkbox2,'Enable','on');
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.pushbutton11,'Enable','on');
        
    %Schalflächen zur Strahlkompensation1 werden aktiviert
    Strahlkompensation1=get(handles.checkbox2,'Value');
    if Strahlkompensation1==1
        set(handles.edit7,'Enable','on');
    else
        set(handles.edit7,'Enable','off');
    end

    %Schalflächen zur Konturumrandung werden richtig aktiviert
    set(handles.checkbox3,'Enable','on');
    Umrandung=get(handles.checkbox3,'Value');
    if Umrandung==1
        set(handles.checkbox4,'Enable','on');
        UmrandungSkywrite=get(handles.checkbox4,'Value');
        if UmrandungSkywrite==1
            set(handles.edit9,'Enable','on');
            set(handles.edit10,'Enable','on');
            set(handles.edit11,'Enable','on');
        else
            set(handles.edit9,'Enable','off');
            set(handles.edit10,'Enable','off');
            set(handles.edit11,'Enable','off');
        end
        set(handles.checkbox5,'Enable','on');
        Strahlkompensation2=get(handles.checkbox5,'Value');
        if Strahlkompensation2==1
            set(handles.edit12,'Enable','on');
        else
            set(handles.edit12,'Enable','off');
        end
    else
        set(handles.checkbox4,'Enable','off');
        set(handles.edit9,'Enable','off');
        set(handles.edit10,'Enable','off');
        set(handles.edit11,'Enable','off');
        set(handles.checkbox5,'Enable','off');
        set(handles.edit12,'Enable','off');
    end

    %Schalflächen zur Schraffur werden richtig aktiviert
    set(handles.checkbox6,'Enable','on');
    Schraffuren=get(handles.checkbox6,'Value');
    if Schraffuren==1
        set(handles.edit13,'Enable','on');
        set(handles.checkbox7,'Enable','on');
        SchraffurSkywrite=get(handles.checkbox7,'Value');
        if SchraffurSkywrite==1
            set(handles.edit15,'Enable','on');
            set(handles.edit16,'Enable','on');
        else
            set(handles.edit15,'Enable','off');
            set(handles.edit16,'Enable','off');
        end
        set(handles.checkbox8,'Enable','on');
        Schraffurwinkel=get(handles.checkbox8,'Value');
        if Schraffurwinkel==1
            set(handles.edit17,'Enable','on');
            set(handles.edit18,'Enable','on');
        else
            set(handles.edit17,'Enable','off');
            set(handles.edit18,'Enable','off');
        end
    else
        set(handles.checkbox7,'Enable','off');
        set(handles.edit15,'Enable','off');
        set(handles.edit16,'Enable','off');
        set(handles.checkbox8,'Enable','off');   
        set(handles.edit17,'Enable','off');
    	set(handles.edit18,'Enable','off');
    end
    
    %Schalflächen mit Ansichtwerzeugen werden aktiviert
    set(handles.pushbutton5,'Enable','on');
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
end

%Wird ausgeführt nach Benutzung von edit1
function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit2
function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
global Var

%Aktualisierung einiger Felder bezüglich des Sclicing
Auswahlhoehen=get(hObject,'Value');
if Auswahlhoehen==1
    set(handles.edit3,'Enable','on');
    set(handles.edit4,'Enable','on');
else
    set(handles.edit3,'Enable','off');
    set(handles.edit4,'Enable','off')
end

%Funktion, die die Schnitthoehen berechnet wird aufgerufen
Schichtdicke=str2double(get(handles.edit5,'String'));
Auswahlhoehen=get(handles.checkbox1,'Value');
Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
[Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
Var.Schichtdicke=Schichtdicke;
Var.Schnitthoehen=Schnitthoehen;
Var.Zoben=Zoben;
Var.Zunten=Zunten;

%Aktualisierung einiger Felder auf dem GUI
set(handles.edit5,'String',Schichtdicke);
set(handles.edit6,'String',length(Schnitthoehen));
set(handles.edit3,'String',Zoben);
set(handles.edit4,'String',Zunten);

%Wird ausgeführt nach Benutzung von edit3
function edit3_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit3 wird ausgewertet
Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
if isnan(Auswahlhoeheoben)
    warndlg('Ungültige Eingabe')
else
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit4
function edit4_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit4 wird ausgewertet
Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
if isnan(Auswahlhoeheunten)
    warndlg('Ungültige Eingabe')
else
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    Schichtdicke=str2double(get(handles.edit5,'String'));
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit5
function edit5_Callback(hObject, eventdata, handles)
global Var
%Funktion, die die Schnitthoehen berechnet wird aufgerufen
Schichtdicke=str2double(get(handles.edit5,'String'));
if Schichtdicke==0
    warndlg('Schichtdicke muss grösser Null sein')
    set(handles.edit5,'String',num2str(Var.Schichtdicke));
elseif isnan(Schichtdicke)
    warndlg('Ungültige Eingabe')
    set(handles.edit5,'String',num2str(Var.Schichtdicke));
else
    if Schichtdicke<0
        set(handles.edit5,'String',num2str(abs(Schichtdicke)));
        Schichtdicke=abs(Schichtdicke);
    end
    Auswahlhoehen=get(handles.checkbox1,'Value');
    Auswahlhoeheoben=str2double(get(handles.edit3,'String'));
    Auswahlhoeheunten=str2double(get(handles.edit4,'String'));
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten;

    %Aktualisierung einiger Felder auf dem GUI
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit 6
function edit6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox2
function checkbox2_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox2 werden richtig aktiviert
Strahlkompensation1=get(hObject,'Value');
if Strahlkompensation1==1
    set(handles.edit7,'Enable','on');
else
    set(handles.edit7,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit7
function edit7_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit7 wird ausgewertet
KonturAbstand1=str2double(get(handles.edit7,'String'));
if KonturAbstand1<0
    set(handles.edit7,'String',num2str(abs(KonturAbstand1)));
elseif KonturAbstand1==0
    warndlg('Konturabstand1 muss grösser Null sein')
    set(handles.edit7,'String',num2str(Var.KonturAbstand1));
elseif isnan(KonturAbstand1)
    warndlg('Ungültige Eingabe')
    set(handles.edit7,'String',num2str(Var.KonturAbstand1));
else
    Var.KonturAbstand1=KonturAbstand1;
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox3 werden richtig aktiviert
Umrandung=get(handles.checkbox3,'Value');
if Umrandung==1
    set(handles.checkbox4,'Enable','on');
    UmrandungSkywrite=get(handles.checkbox4,'Value');
    if UmrandungSkywrite==1
        set(handles.edit9,'Enable','on');
        set(handles.edit10,'Enable','on');
        set(handles.edit11,'Enable','on');
    else
        set(handles.edit9,'Enable','off');
        set(handles.edit10,'Enable','off');
        set(handles.edit11,'Enable','off');
    end
    set(handles.checkbox5,'Enable','on');
    Strahlkompensation2=get(handles.checkbox5,'Value');
    if Strahlkompensation2==1
        set(handles.edit12,'Enable','on');
    else
        set(handles.edit12,'Enable','off');
    end
else
    set(handles.checkbox4,'Value',0);
    set(handles.checkbox5,'Value',0);
    set(handles.checkbox4,'Enable','off');
    set(handles.edit9,'Enable','off');
    set(handles.edit10,'Enable','off');
    set(handles.edit11,'Enable','off');
    set(handles.checkbox5,'Enable','off');
    set(handles.edit12,'Enable','off');
end

%Wird ausgeführt nach Benutzung von checkbox4
function checkbox4_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox4 werden richtig aktiviert
UmrandungSkywrite=get(handles.checkbox4,'Value');
if UmrandungSkywrite==1
    set(handles.edit9,'Enable','on');
    set(handles.edit10,'Enable','on');
    set(handles.edit11,'Enable','on');
else
    set(handles.edit9,'Enable','off');
    set(handles.edit10,'Enable','off');
    set(handles.edit11,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit9
function edit9_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit9 wird ausgewertet
UmrandungBreakangle=str2double(get(hObject,'String'));
if UmrandungBreakangle<0
    set(handles.edit9,'String',num2str(abs(UmrandungBreakangle)));
elseif isnan(UmrandungBreakangle)
    warndlg('Ungültige Eingabe')
    set(handles.edit9,'String',num2str(Var.UmrandungBreakangle));
else
    Var.UmrandungBreakangle=UmrandungBreakangle;
end
    
% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit10
function edit10_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit10 wird ausgewertet
UmrandungSkywritestart=str2double(get(handles.edit10,'String'));
if UmrandungSkywritestart<0
    set(handles.edit10,'String',num2str(abs(UmrandungSkywritestart)));
elseif isnan(UmrandungSkywritestart)
    warndlg('Ungültige Eingabe')
    set(handles.edit10,'String',num2str(Var.UmrandungSkywritestart));
else
    Var.UmrandungSkywritestart=UmrandungSkywritestart;
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit11
function edit11_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit11 wird ausgewertet
UmrandungSkywriteend=str2double(get(handles.edit11,'String'));
if UmrandungSkywriteend<0
    set(handles.edit11,'String',num2str(abs(UmrandungSkywriteend)));
elseif isnan(UmrandungSkywriteend)
    warndlg('Ungültige Eingabe')
    set(handles.edit11,'String',num2str(Var.UmrandungSkywriteend));
else
    Var.UmrandungSkywriteend=UmrandungSkywriteend;
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)

Strahlkompensation2=get(handles.checkbox5,'Value');
if Strahlkompensation2==1
    set(handles.edit12,'Enable','on');
else
    set(handles.edit12,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit12
function edit12_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit12 wird ausgewertet
KonturAbstand2=str2double(get(handles.edit12,'String'));
if KonturAbstand2<0
    set(handles.edit12,'String',num2str(abs(KonturAbstand2)));
elseif KonturAbstand2==0
    warndlg('Konturabstand 2 muss grösser Null sein')
    set(handles.edit12,'String',num2str(Var.KonturAbstand2));
elseif isnan(KonturAbstand2)
    warndlg('Ungültige Eingabe')
    set(handles.edit12,'String',num2str(Var.KonturAbstand2));
else
	Var.KonturAbstand2=KonturAbstand2;
end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von Schraffuren werden richtig aktiviert
Schraffuren=get(handles.checkbox6,'Value');
if Schraffuren==1
    set(handles.edit13,'Enable','on');
    set(handles.checkbox7,'Enable','on');
    SchraffurSkywrite=get(handles.checkbox7,'Value');
    if SchraffurSkywrite==1
        set(handles.edit15,'Enable','on');
        set(handles.edit16,'Enable','on');
    else
        set(handles.edit15,'Enable','off');
        set(handles.edit16,'Enable','off');
    end
    set(handles.checkbox8,'Enable','on');
    Schraffurwinkel=get(handles.checkbox8,'Value');
    if Schraffurwinkel==1
        set(handles.edit17,'Enable','on');
        set(handles.edit18,'Enable','on');
    else
        set(handles.edit17,'Enable','off');
        set(handles.edit18,'Enable','off');
    end
else
    set(handles.checkbox7,'Value',0);
    set(handles.checkbox8,'Value',0);
    set(handles.edit13,'Enable','off');
    set(handles.checkbox7,'Enable','off');
    set(handles.edit15,'Enable','off');
    set(handles.edit16,'Enable','off');
    set(handles.checkbox8,'Enable','off');   
    set(handles.edit17,'Enable','off');
    set(handles.edit18,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit13
function edit13_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit13 wird ausgewertet
Linienabstand=str2double(get(handles.edit13,'String'));
if Linienabstand<0
    set(handles.edit13,'String',num2str(abs(Linienabstand)));
elseif Linienabstand==0
    warndlg('Der Linienabstand muss grösser Null sein')
    set(handles.edit13,'String',num2str(Var.Linienabstand));
elseif isnan(Linienabstand)
    warndlg('Ungültige Eingabe')
    set(handles.edit13,'String',num2str(Var.Linienabstand));
else
    Var.Linienabstand=Linienabstand;
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von  checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)

set(handles.checkbox7,'Enable','on');
SchraffurSkywrite=get(handles.checkbox7,'Value');
if SchraffurSkywrite==1
    set(handles.edit15,'Enable','on');
    set(handles.edit16,'Enable','on');
else
    set(handles.edit15,'Enable','off');
    set(handles.edit16,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit15
function edit15_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit15 wird ausgewertet
SchraffurSkywritestart=str2double(get(handles.edit15,'String'));
if SchraffurSkywritestart<0
    set(handles.edit15,'String',num2str(abs(SchraffurSkywritestart)));
elseif isnan(SchraffurSkywritestart)
    warndlg('Ungültige Eingabe')
    set(handles.edit15,'String',num2str(Var.SchraffurSkywritestart));
else
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit 16
function edit16_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit16 wird ausgewertet
SchraffurSkywriteend=str2double(get(handles.edit16,'String'));
if SchraffurSkywriteend<0
    set(handles.edit16,'String',num2str(abs(SchraffurSkywriteend)));
elseif isnan(SchraffurSkywriteend)
    warndlg('Ungültige Eingabe')
    set(handles.edit16,'String',num2str(Var.SchraffurSkywriteend));
else
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
end

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
%Entsprechende Unterfelder von checkbox8 werden richtig aktiviert
set(handles.checkbox8,'Enable','on');
Schraffurwinkel=get(handles.checkbox8,'Value');
if Schraffurwinkel==1
    set(handles.edit17,'Enable','on');
    set(handles.edit18,'Enable','on');
else
    set(handles.edit17,'Enable','off');
    set(handles.edit18,'Enable','off');
end

%Wird ausgeführt nach Benutzung von edit17
function edit17_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit17 wird ausgewertet
Schraffurwinkelstart=str2double(get(handles.edit17,'String'));
if isnan(Schraffurwinkelstart)
    warndlg('Ungültige Eingabe')
    set(handles.edit17,'String',num2str(Var.Schraffurwinkelstart));
else
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
end

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von edit18
function edit18_Callback(hObject, eventdata, handles)
global Var
%Eingabe in edit18 wird ausgewertet
Schraffurwinkelinkrem=str2double(get(handles.edit18,'String'));
if isnan(Schraffurwinkelinkrem)
    warndlg('Ungültige Eingabe')
    set(handles.edit18,'String',num2str(Var.Schraffurwinkelinkrem));
else
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
end

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Wird ausgeführt nach Benutzung von pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global Var
%Zusammensuchen der benötigten Werte
Schichtdicke=str2double(get(handles.edit5,'String'));
Schnitthoehen=Var.Schnitthoehen;
v=Var.v;
n=Var.n;
f=Var.f;
fv=Var.fv;
Zoben=Var.Zoben;
Titel=Var.Titel;
Strahlkompensation1=get(handles.checkbox2,'Value');
KonturAbstand1=str2double(get(handles.edit7,'String'));
Umrandung=get(handles.checkbox3,'Value');
UmrandungSkywrite=get(handles.checkbox4,'Value');
UmrandungBreakangle=str2double(get(handles.edit9,'String'));
UmrandungSkywritestart=str2double(get(handles.edit10,'String'));
UmrandungSkywriteend=str2double(get(handles.edit11,'String'));
Strahlkompensation2=get(handles.checkbox5,'Value');
KonturAbstand2=str2double(get(handles.edit12,'String'));
Schraffur=get(handles.checkbox6,'Value');
Linienabstand=str2double(get(handles.edit13,'String'));
SchraffurSkywrite=get(handles.checkbox7,'Value');
SchraffurSkywritestart=str2double(get(handles.edit15,'String'));
SchraffurSkywriteend=str2double(get(handles.edit16,'String'));
Schraffurwinkel=get(handles.checkbox8,'Value');
Schraffurwinkelstart=str2double(get(handles.edit17,'String'));
Schraffurwinkelinkrem=str2double(get(handles.edit18,'String'));
Hatchtyp=Var.Hatchtyp;

%Ebene die Dargestellt werden soll
d=1; 

%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Schnitthöhe: ',num2str(Hoehe(d))]); 

%Darstellung des Stl-objekts
cla %Grafik zurücksetzen
FDStlObjekt(1,fv);
view([-40 50]); %Set a nice view angle

%Funktion, die die Slices macht wird aufgerufen
disp('Slices werden berechnet...');
[Konturen0]=F10_Slicing( f,v,Schnitthoehen,Schichtdicke );
disp('Slices berechnet');

%Die Schichten werden absteigend sortiert
Konturen0=flipud(Konturen0); %Oberste Schnittebene ist nun im obersten CellArray Eintrag
Var.Konturen0=Konturen0;

%Darstellung der Schnittkonturen 
FDSchnittkontur(1,d,Konturen0);

%Entsprechende Schaltflächen zur Darstellung werden sichtbar gemacht
set(handles.checkbox9,'Enable','on'); %Checkbox Darstellung Stl-Objekt
set(handles.checkbox9,'Value',1); %Checkbox Darstellung Stl-Objekt
set(handles.checkbox10,'Enable','on'); %Checkbox Darstellung Schnittkontur
set(handles.checkbox10,'Value',1); %Checkbox Darstellung Schnittkontur

%Funktion, die die Strahlkompensation 1 berechnet
if Strahlkompensation1==1
    bar = waitbar(0,'Strahlkompensation 1 wird berechnet...'); %Ladebalken erstellen
    Konturen1=cell(size(Konturen0));
    for k=1:size(Konturen0,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur1=Konturen0(k,:);
        [Kontur1]=F20_Strahlkomp( Kontur1,n,KonturAbstand1 ); %Funktion die die Strahlkompensation berechnet
        Konturen1(k,1:size(Kontur1,2))=Kontur1;
        waitbar(k / size(Konturen0,1)) %Ladebalken aktualisieren
    end
    close(bar) %Ladebalken schliessen
else
    Konturen1=Konturen0;
end
Var.Konturen1=Konturen1;

%Darstellung der Schnittlinien mit Strahlkompensation1
if Strahlkompensation1==1
    FDSchnittkontur(1,d,Konturen1);
    set(handles.checkbox11,'Enable','on'); %Checkbox Darstellung Strahlkompensation1
    set(handles.checkbox11,'Value',1); %Checkbox Darstellung Strahlkompensation1
end

%Funktion, die die Umrandungskontur berechnet
if Umrandung==1
    UmrandungKonturen= F30_Umrandung( Konturen1,UmrandungSkywrite,UmrandungBreakangle,UmrandungSkywritestart,UmrandungSkywriteend);
else
    UmrandungKonturen=cell(size(Konturen1));
end
Var.UmrandungKonturen=UmrandungKonturen;

%Darstellung der Umrandungskontur
if Umrandung==1
    FDUmrandung(1,d,UmrandungKonturen);
    set(handles.checkbox13,'Enable','on'); %Checkbox Darstellung Umrandung
    set(handles.checkbox13,'Value',1); %Checkbox Darstellung Umrandung
end

%Funktion, die die Strahlkompensation 2 berechnet
if Strahlkompensation2==1
    bar = waitbar(0,'Strahlkompensation 2 wird berechnet...'); %Ladebalken erstellen
    Konturen2=cell(size(Konturen1));
    for k=1:size(Konturen1,1) %Index, der durch die Ebenen von ClosedCurves geht
        Kontur2=Konturen1(k,:);
        [Kontur2]=F20_Strahlkomp( Kontur2,n,KonturAbstand2 ); %Funktion die die Strahlkompensation berechnet
        Konturen2(k,1:size(Kontur2,2))=Kontur2;
        waitbar(k / size(Konturen0,1)) %Ladebalken aktualisieren
    end
    close(bar) %Ladebalken schliessen
else
    Konturen2=Konturen1;
end
Var.Konturen2=Konturen2;

%Darstellung der Schnittlinien mit Strahlkompensation2
if Strahlkompensation2==1
    FDSchnittkontur(1,d,Konturen2);
    set(handles.checkbox12,'Enable','on'); %Checkbox Darstellung Strahlkompensation2
    set(handles.checkbox12,'Value',1); %Checkbox Darstellung Kontur
end

%Funktion, die die Schraffuren berechnet
if Schraffur==1
    [Schraffuren]=F40_Schraffuren( Konturen2,Linienabstand,SchraffurSkywrite,SchraffurSkywritestart,SchraffurSkywriteend,Schraffurwinkel,Schraffurwinkelstart,Schraffurwinkelinkrem,Hatchtyp ); 
else
    Schraffuren=cell(size(Konturen2,1),1);
end
Var.Schraffuren=Schraffuren;

%Darstellung der Schraffuren
if Schraffur==1
    FDSchraffur(1,d,Schraffuren);
    set(handles.checkbox14,'Enable','on'); %Checkbox Darstellung Schraffuren
    set(handles.checkbox14,'Value',1); %Checkbox Darstellung Schraffuren
end

%Aktivierung Slider
set(handles.slider1,'Min',-length(Schnitthoehen)-0.1);
set(handles.slider1,'Value',-1);
set(handles.slider1,'Enable','on');

%Pushbutton 8 (NC-Code erstellen) wird aktiviert 
set(handles.pushbutton8,'Enable','on');


%Wird ausgeführt nach Benutzung von checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
global Var
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
d=abs(get(handles.slider1,'Value'));
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

%Wird ausgeführt nach Benutzung von slider1
function slider1_Callback(hObject, eventdata, handles)
global Var
d=get(handles.slider1,'Value');
d=round(d);
set(handles.slider1,'Value',d);
d=abs(d);
%Aktualisierung edit 22
Hoehe=flipud(Var.Schnitthoehen);
set(handles.edit22,'String',['Ebene: ',num2str(d),'   Schnitthöhe: ',num2str(Hoehe(d))]); 
DStlObjekt=get(handles.checkbox9,'Value');
DKontur0=get(handles.checkbox10,'Value');
DKontur1=get(handles.checkbox11,'Value');
DKontur2=get(handles.checkbox12,'Value');
DUmrandung=get(handles.checkbox13,'Value');
DSchraffur=get(handles.checkbox14,'Value');
cla
FDStlObjekt(DStlObjekt,Var.fv);
FDSchnittkontur(DKontur0,d,Var.Konturen0);
FDSchnittkontur(DKontur1,d,Var.Konturen1);
FDSchnittkontur(DKontur2,d,Var.Konturen2);
FDUmrandung(DUmrandung,d,Var.UmrandungKonturen);
FDSchraffur(DSchraffur,d,Var.Schraffuren);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%Wird ausgeführt nach Benutzung von pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
rotate3d on

%Wird ausgeführt nach Benutzung von pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
zoom on

%Wird ausgeführt nach Benutzung von pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
pan on

%Wird ausgeführt nach Benutzung von pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
NCCodekartesisch

%Wird ausgeführt nach Benutzung von edit22
function edit22_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global Var

%Dialogfenster um Ladeverzeichnis zu wählen
[FileName,PathName] = uigetfile('*.txt','Einstellungen laden');
if ischar(FileName) && ischar(PathName)
    fid = fopen([PathName,FileName], 'r'); %txt-file wird geöffnet
    %Textdatei einlesen, Zeilen mit '%' ignorieren und ':' als Separator verwenden
    text=textscan(fid,'%s%s', 'CommentStyle','%','Delimiter',':');
    fclose(fid);
    %Folgend wird den Variabeln den eingelesenen text richtig zugewiesen
    Schichtdicke=str2double(text{2}(strncmpi('Schichtdicke',text{1},12)));
    Auswahlhoehen=str2double(text{2}(strncmpi('Auswahlhoehen',text{1},13)));
    Auswahlhoeheoben=str2double(text{2}(strncmpi('Auswahlhoeheoben',text{1},16)));
    Auswahlhoeheunten=str2double(text{2}(strncmpi('Auswahlhoeheunten',text{1},17)));
    Strahlkompensation1=str2double(text{2}(strncmpi('Strahlkompensation1',text{1},19)));
    KonturAbstand1=str2double(text{2}(strncmpi('KonturAbstand1',text{1},14)));
    Umrandung=str2double(text{2}( strncmpi('Umrandung',text{1},9)&(9==cellfun(@length,text{1}))));
    UmrandungSkywrite=str2double(text{2}(strncmpi('UmrandungSkywrite',text{1},17)&(17==cellfun(@length,text{1}))));
    UmrandungSkywritestart=str2double(text{2}(strncmpi('UmrandungSkywritestart',text{1},22)));
    UmrandungSkywriteend=str2double(text{2}(strncmpi('UmrandungSkywriteend',text{1},20)));
    UmrandungBreakangle=str2double(text{2}(strncmpi('UmrandungBreakangle',text{1},19)));
    Strahlkompensation2=str2double(text{2}(strncmpi('Strahlkompensation2',text{1},19)));
    KonturAbstand2=str2double(text{2}(strncmpi('KonturAbstand2',text{1},14)));
    Schraffur=str2double(text{2}( strncmpi('Schraffur',text{1},9)&(9==cellfun(@length,text{1}))));
    Linienabstand=str2double(text{2}(strncmpi('Linienabstand',text{1},13)));
    SchraffurSkywrite=str2double(text{2}(strncmpi('SchraffurSkywrite',text{1},17)&(17==cellfun(@length,text{1}))));
    SchraffurSkywritestart=str2double(text{2}(strncmpi('SchraffurSkywritestart',text{1},22)));
    SchraffurSkywriteend=str2double(text{2}(strncmpi('SchraffurSkywriteend',text{1},20)));
    Schraffurwinkel=str2double(text{2}( strncmpi('Schraffurwinkel',text{1},15)&(15==cellfun(@length,text{1}))));
    Schraffurwinkelstart=str2double(text{2}(strncmpi('Schraffurwinkelstart',text{1},16)));
    Schraffurwinkelinkrem=str2double(text{2}(strncmpi('Schraffurwinkelinkrem',text{1},17)));
    Var.NCText.Header1=text{2}{find(strncmpi('NCText.Header1',text{1},14),1)};
    Var.NCText.Header2=text{2}{find(strncmpi('NCText.Header2',text{1},14),1)};
    Var.NCText.Header3=text{2}{find(strncmpi('NCText.Header3',text{1},14),1)};
    Var.NCText.Header4=text{2}{find(strncmpi('NCText.Header4',text{1},14),1)};
    Var.NCText.Header5=text{2}{find(strncmpi('NCText.Header5',text{1},14),1)};
    Var.NCText.Header6=text{2}{find(strncmpi('NCText.Header6',text{1},14),1)};
    Var.NCText.Header7=text{2}{find(strncmpi('NCText.Header7',text{1},14),1)};
    Var.NCText.Header8=text{2}{find(strncmpi('NCText.Header8',text{1},14),1)};
    Var.NCText.Header9=text{2}{find(strncmpi('NCText.Header9',text{1},14),1)};
    Var.NCText.Header10=text{2}{find(strncmpi('NCText.Header10',text{1},15),1)};
    Var.NCText.Fokus1=text{2}{find(strncmpi('NCText.Fokus1',text{1},13),1)};
    Var.NCText.Fokus2=text{2}{find(strncmpi('NCText.Fokus2',text{1},13),1)};
    Var.NCText.Eilgang1=text{2}{find(strncmpi('NCText.Eilgang1',text{1},15),1)};
    Var.NCText.Eilgang2=text{2}{find(strncmpi('NCText.Eilgang2',text{1},15),1)};
    Var.NCText.Eilgang3=text{2}{find(strncmpi('NCText.Eilgang3',text{1},15),1)};
    Var.NCText.StartSky1=text{2}{find(strncmpi('NCText.StartSky1',text{1},16),1)};
    Var.NCText.StartSky2=text{2}{find(strncmpi('NCText.StartSky2',text{1},16),1)};
    Var.NCText.StartSky3=text{2}{find(strncmpi('NCText.StartSky3',text{1},16),1)};
    Var.NCText.Laser1=text{2}{find(strncmpi('NCText.Laser1',text{1},13),1)};
    Var.NCText.Laser2=text{2}{find(strncmpi('NCText.Laser2',text{1},13),1)};
    Var.NCText.Laser3=text{2}{find(strncmpi('NCText.Laser3',text{1},13),1)};
    Var.NCText.EndSky1=text{2}{find(strncmpi('NCText.EndSky1',text{1},14),1)};
    Var.NCText.EndSky2=text{2}{find(strncmpi('NCText.EndSky2',text{1},14),1)};
    Var.NCText.EndSky3=text{2}{find(strncmpi('NCText.EndSky3',text{1},14),1)};
    Var.NCText.Laseron=text{2}{find(strncmpi('NCText.Laseron',text{1},14),1)};
    Var.NCText.Laseroff=text{2}{find(strncmpi('NCText.Laseroff',text{1},15),1)};
    Var.NCText.Kommentar1=text{2}{find(strncmpi('NCText.Kommentar1',text{1},17),1)};
    Var.NCText.Kommentar2=text{2}{find(strncmpi('NCText.Kommentar2',text{1},17),1)};
    Var.NCText.Finish1=text{2}{find(strncmpi('NCText.Finish1',text{1},14),1)};
    Var.NCText.Finish2=text{2}{find(strncmpi('NCText.Finish2',text{1},14),1)};
    Var.NCText.Finish3=text{2}{find(strncmpi('NCText.Finish3',text{1},14),1)};
    Var.NCText.Finish4=text{2}{find(strncmpi('NCText.Finish4',text{1},14),1)};
    Var.NCText.Finish5=text{2}{find(strncmpi('NCText.Finish5',text{1},14),1)};
    
    %Funktion, die die Schnitthoehen berechnet wird aufgerufen
    [Schnitthoehen,Zoben,Zunten,Schichtdicke]=F05_Schnitthoehen(Var.v,Schichtdicke,Auswahlhoehen,Auswahlhoeheoben,Auswahlhoeheunten);
    Var.Schichtdicke=Schichtdicke;
    Var.Schnitthoehen=Schnitthoehen;
    Var.Zoben=Zoben;
    Var.Zunten=Zunten; 
    
    %Aktualisierung einiger Felder bezüglich des Slicing
    if Auswahlhoehen==1
        set(handles.checkbox1,'Value',1);
        set(handles.edit3,'Enable','on');
        set(handles.edit4,'Enable','on');
    else
        set(handles.checkbox1,'Value',0);
        set(handles.edit3,'Enable','off');
        set(handles.edit4,'Enable','off')
    end
    set(handles.edit5,'String',Schichtdicke);
    set(handles.edit6,'String',length(Schnitthoehen));
    set(handles.edit3,'String',Zoben);
    set(handles.edit4,'String',Zunten);
    
    %Die Variabeln werden in die Felder auf dem Frontpanel geschrieben
    set(handles.edit5,'String',num2str(Schichtdicke));
    set(handles.checkbox2,'Value',Strahlkompensation1);
    set(handles.edit7,'String',num2str(KonturAbstand1));
    set(handles.checkbox3,'Value',Umrandung);
    set(handles.checkbox4,'Value',UmrandungSkywrite);
    set(handles.edit9,'String',num2str(UmrandungBreakangle));
    set(handles.edit10,'String',num2str(UmrandungSkywritestart));
    set(handles.edit11,'String',num2str(UmrandungSkywriteend));
    set(handles.checkbox5,'Value',Strahlkompensation2);
    set(handles.edit12,'String',num2str(KonturAbstand2));
    set(handles.checkbox6,'Value',Schraffur);
    set(handles.edit13,'String',num2str(Linienabstand));
    set(handles.checkbox7,'Value',SchraffurSkywrite);
    set(handles.edit15,'String',num2str(SchraffurSkywritestart));
    set(handles.edit16,'String',num2str(SchraffurSkywriteend));
    set(handles.checkbox8,'Value',Schraffurwinkel);
    set(handles.edit17,'String',num2str(Schraffurwinkelstart));
    set(handles.edit18,'String',num2str(Schraffurwinkelinkrem));
    
    %Einige Variabeln werden als globable Variabeln gespeichert
    Var.Schichtdicke=Schichtdicke;
    Var.KonturAbstand1=KonturAbstand1;
    Var.UmrandungBreakangle=UmrandungBreakangle;
    Var.UmrandungSkywritestart=UmrandungSkywritestart;
    Var.UmrandungSkywriteend=UmrandungSkywriteend;
    Var.KonturAbstand2=KonturAbstand2;
    Var.Linienabstand=Linienabstand;
    Var.SchraffurSkywritestart=SchraffurSkywritestart;
    Var.SchraffurSkywriteend=SchraffurSkywriteend;
    Var.Schraffurwinkelstart=Schraffurwinkelstart;
    Var.Schraffurwinkelinkrem=Schraffurwinkelinkrem;
    
    %Schalflächen zur Strahlkompensation1 werden aktiviert
    Strahlkompensation1=get(handles.checkbox2,'Value');
    if Strahlkompensation1==1
        set(handles.edit7,'Enable','on');
    else
        set(handles.edit7,'Enable','off');
    end

    %Schalflächen zur Konturumrandung werden richtig aktiviert
    set(handles.checkbox3,'Enable','on');
    Umrandung=get(handles.checkbox3,'Value');
    if Umrandung==1
        set(handles.checkbox4,'Enable','on');
        UmrandungSkywrite=get(handles.checkbox4,'Value');
        if UmrandungSkywrite==1
            set(handles.edit9,'Enable','on');
            set(handles.edit10,'Enable','on');
            set(handles.edit11,'Enable','on');
        else
            set(handles.edit9,'Enable','off');
            set(handles.edit10,'Enable','off');
            set(handles.edit11,'Enable','off');
        end
        set(handles.checkbox5,'Enable','on');
        Strahlkompensation2=get(handles.checkbox5,'Value');
        if Strahlkompensation2==1
            set(handles.edit12,'Enable','on');
        else
            set(handles.edit12,'Enable','off');
        end
    else
        set(handles.checkbox4,'Enable','off');
        set(handles.edit9,'Enable','off');
        set(handles.edit10,'Enable','off');
        set(handles.edit11,'Enable','off');
        set(handles.checkbox5,'Enable','off');
        set(handles.edit12,'Enable','off');
    end

    %Schaltflächen zur Schraffur werden richtig aktiviert
    set(handles.checkbox6,'Enable','on');
    Schraffuren=get(handles.checkbox6,'Value');
    if Schraffuren==1
        set(handles.edit13,'Enable','on');
        set(handles.checkbox7,'Enable','on');
        SchraffurSkywrite=get(handles.checkbox7,'Value');
        if SchraffurSkywrite==1
            set(handles.edit15,'Enable','on');
            set(handles.edit16,'Enable','on');
        else
            set(handles.edit15,'Enable','off');
            set(handles.edit16,'Enable','off');
        end
        set(handles.checkbox8,'Enable','on');
        Schraffurwinkel=get(handles.checkbox8,'Value');
        if Schraffurwinkel==1
            set(handles.edit17,'Enable','on');
            set(handles.edit18,'Enable','on');
        else
            set(handles.edit17,'Enable','off');
            set(handles.edit18,'Enable','off');
        end
    else
        set(handles.checkbox7,'Enable','off');
        set(handles.edit15,'Enable','off');
        set(handles.edit16,'Enable','off');
        set(handles.checkbox8,'Enable','off');   
        set(handles.edit17,'Enable','off');
    	set(handles.edit18,'Enable','off');
    end
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
global Var

%Dialogfenster um Speicherverzeichnis zu bestimmen
[FileName,PathName] = uiputfile('*.txt','Alle Einstellungen Speichern');
if ischar(FileName) && ischar(PathName)
    fid = fopen([PathName,FileName], 'w'); %Ein neues txt-file wird geöffnet

    %Parameter werden ins Textfile gespeichert
    fprintf(fid,['Schichtdicke:',get(handles.edit5,'String'),'\r\n']);
    fprintf(fid,['Auswahlhoehen:',num2str(get(handles.checkbox1,'Value')),'\r\n']);
    fprintf(fid,['Auswahlhoeheoben:',get(handles.edit3,'String'),'\r\n']);
    fprintf(fid,['Auswahlhoeheunten:',get(handles.edit4,'String'),'\r\n']);
    fprintf(fid,['Strahlkompensation1:',num2str(get(handles.checkbox2,'Value')),'\r\n']);
    fprintf(fid,['KonturAbstand1:',get(handles.edit7,'String'),'\r\n']);
    fprintf(fid,['Umrandung:',num2str(get(handles.checkbox3,'Value')),'\r\n']);
    fprintf(fid,['UmrandungSkywrite:',num2str(get(handles.checkbox4,'Value')),'\r\n']);
    fprintf(fid,['UmrandungBreakangle:',get(handles.edit9,'String'),'\r\n']);
    fprintf(fid,['UmrandungSkywritestart:',get(handles.edit10,'String'),'\r\n']);
    fprintf(fid,['UmrandungSkywriteend:',get(handles.edit11,'String'),'\r\n']);
    fprintf(fid,['Strahlkompensation2:',num2str(get(handles.checkbox5,'Value')),'\r\n']);
    fprintf(fid,['KonturAbstand2:',get(handles.edit12,'String'),'\r\n']);
    fprintf(fid,['Schraffur:',num2str(get(handles.checkbox6,'Value')),'\r\n']);
    fprintf(fid,['Linienabstand:',get(handles.edit13,'String'),'\r\n']);
    fprintf(fid,['SchraffurSkywrite:',num2str(get(handles.checkbox7,'Value')),'\r\n']);
    fprintf(fid,['SchraffurSkywritestart:',get(handles.edit15,'String'),'\r\n']);
    fprintf(fid,['SchraffurSkywriteend:',get(handles.edit16,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkel:',num2str(get(handles.checkbox8,'Value')),'\r\n']);
    fprintf(fid,['Schraffurwinkelstart:',get(handles.edit17,'String'),'\r\n']);
    fprintf(fid,['Schraffurwinkelinkrem:',get(handles.edit18,'String'),'\r\n']);
    fprintf(fid,['NCText.Header1:',Var.NCText.Header1,'\r\n']);
    fprintf(fid,['NCText.Header2:',Var.NCText.Header2,'\r\n']);
    fprintf(fid,['NCText.Header3:',Var.NCText.Header3,'\r\n']);
    fprintf(fid,['NCText.Header4:',Var.NCText.Header4,'\r\n']);
    fprintf(fid,['NCText.Header5:',Var.NCText.Header5,'\r\n']);
    fprintf(fid,['NCText.Header6:',Var.NCText.Header6,'\r\n']);
    fprintf(fid,['NCText.Header7:',Var.NCText.Header7,'\r\n']);
    fprintf(fid,['NCText.Header8:',Var.NCText.Header8,'\r\n']);
    fprintf(fid,['NCText.Header9:',Var.NCText.Header9,'\r\n']);
    fprintf(fid,['NCText.Header10:',Var.NCText.Header10,'\r\n']);
    fprintf(fid,['NCText.Fokus1:',Var.NCText.Fokus1,'\r\n']);
    fprintf(fid,['NCText.Fokus2:',Var.NCText.Fokus2,'\r\n']);
    fprintf(fid,['NCText.Eilgang1:',Var.NCText.Eilgang1,'\r\n']);
    fprintf(fid,['NCText.Eilgang2:',Var.NCText.Eilgang2,'\r\n']);
    fprintf(fid,['NCText.Eilgang3:',Var.NCText.Eilgang3,'\r\n']);
    fprintf(fid,['NCText.StartSky1:',Var.NCText.StartSky1,'\r\n']);
    fprintf(fid,['NCText.StartSky2:',Var.NCText.StartSky2,'\r\n']);
    fprintf(fid,['NCText.StartSky3:',Var.NCText.StartSky3,'\r\n']);
    fprintf(fid,['NCText.Laser1:',Var.NCText.Laser1,'\r\n']);
    fprintf(fid,['NCText.Laser2:',Var.NCText.Laser2,'\r\n']);
    fprintf(fid,['NCText.Laser3:',Var.NCText.Laser3,'\r\n']);
    fprintf(fid,['NCText.EndSky1:',Var.NCText.EndSky1,'\r\n']);
    fprintf(fid,['NCText.EndSky2:',Var.NCText.EndSky2,'\r\n']);
    fprintf(fid,['NCText.EndSky3:',Var.NCText.EndSky3,'\r\n']);
    fprintf(fid,['NCText.Laseron:',Var.NCText.Laseron,'\r\n']);
    fprintf(fid,['NCText.Laseroff:',Var.NCText.Laseroff,'\r\n']);
    fprintf(fid,['NCText.Kommentar1:',Var.NCText.Kommentar1,'\r\n']);
    fprintf(fid,['NCText.Kommentar2:',Var.NCText.Kommentar2,'\r\n']);
    fprintf(fid,['NCText.Finish1:',Var.NCText.Finish1,'\r\n']);
    fprintf(fid,['NCText.Finish2:',Var.NCText.Finish2,'\r\n']);
    fprintf(fid,['NCText.Finish3:',Var.NCText.Finish3,'\r\n']);
    fprintf(fid,['NCText.Finish4:',Var.NCText.Finish4,'\r\n']);
    fprintf(fid,['NCText.Finish5:',Var.NCText.Finish5,'\r\n']);

    fclose(fid); %txt-file wird geschlossen
end
