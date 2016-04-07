function [Schraffuren,VorschubDominant,Umdrehungen,Winkel]=F41_Schraffuren( Konturen,Linienabstand,Skywrite,Skywritestart,Skywriteend,Schraffurwinkelstart,Schraffurwinkelinkrem,Verhaeltnis,Scangeschw,VorschubAmax,Drehoffsetlength,Modus,MinJumplengthY,WinkelAnpassung)
%F41_Schraffuren berechnet aus geschlossenen Konturen die Schraffuren. 
%Als Imput bekommt diese Funktion das CellArray Konturen. In diesem Cell
%Array enth�lt jede Zeile die geschlossenen Konturen einer Schnittebene.
%Jedes einzelnes Array vom Cell Array Konturen hat vier Spalten.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Eckpunkte der geschlossenen Kontur. Werden diese Zeile f�r Zeile
%miteinander verbunden, entsteht eine geschlossene Kontur. 
%In der vierten Spalte jedes Arrays, ist die Dreiecksnummer der
%Stl-Datei gespeichert aus dem der Eckpunkt auf dieser Zeile entstanden
%ist.
%Ein weiterer Imput ist der Linienabstand. Dieser gibt an welchen Abstand
%die einzelnen Schraffurlinen sp�ter haben sollen. 
%Der Imput Skywrite gibt an ob Skywrite berechnet werden soll (1=ja, 0=nein)
%Skywritestart ist die L�nge [mm], die die Skywritestarlinien haben sollen.
%Skywriteend ist die L�nge [mm], die die Skywriteendlinien haben sollen.
%Schraffurwinkelstart ist der erste SchraffurWinkel in Grad. Dieser wird
%nur ben�tigt falls Modus=2, bei einem freiw�hlbaren Winkel
%Schraffurwinkelinkrem ist der variable Winkel in Grad der von Schraffur zu
%Schraffur �ndert. 
%Der Imput Verh�ltnis wird f�r die Berechnung des kleinstm�glichen Winkels
%ben�tigt. Dieser wird ben�tigt falls Modus=1.
%Der Imput Scangeschwindigkeit wird ben�tigt um die Drehgeschwindigkeit der
%Drehachse zu berechnen.
%Liegt die berechnete Drehgeschwindigkeit �ber der maximalen
%Drehgeschwindigkeit des Imputs VorschubAmax, wird eine Warnmeldung
%generiert.
%Der Imput Drehoffsetlength gibt die minimale L�nge zwischen den
%Schraffuren in Drehrichtung an [mm]
%Der Imput MinJumplengthY [mm] gibt die minimale L�nge der Jumplinie in
%Y-Richtung an.
%Der Imput WinkelAnpassen (1=ja) (0=nein) gibt an ob der Winkel angepasst 
%werden soll damit die maximale Drehzahl und Scangeschwindigkeit nicht 
%�berschritten und der kleinstm�chlie Winkel nicht unterschritten wird.
%Output dieser Funktion ist das Cell Array Schraffuren. Jede Zeile in
%diesem Cell Array enth�lt die berechneten Schraffuren einer Schnittebene.
%In den ersten drei Spalten sind die x-, y- und z-Koordinaten der einzelnen
%Schraffurpunkte enthalten. In der vierten Spalte ist definiert um was f�r
%einen Linietyp es sich handelt. 
%0=Eilganglinie, die mit ausgeschaltetem Laser so schnell wie m�glich 
%abgefahren werden kann (G00)
%1=Linie, die mit eingeschaltetem Laser mit Scangeschwindigkeit abgefahren
%werden kann  (G01)
%2=Skywritestartlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%3=Skywriteendlinie, die mit ausgeschaltetem Laser mit
%Scangeschwindigkeit abgefahren werden kann (G01)
%5=Linie, die mit ausgeschaltetem Laser abgefahren wird (Zwischenlinie)
%7=Linie, die mit ausgeschaltetem Laser abgefahren wird (Jumplinie)
%Der Output VorschubDominant ist ein Array in dem die berechnete 
%Drehgeschwindigkeit f�r jede Ebene gespeichert ist [�/s].
%Der Output Umdrehungen enth�lt die zus�tzlichen vollen Umdrehungen in [�]
%die n�tig sind um einen kontinuierliche steigenden Winkel im NC-Code f�r
%die Drehachse zu berechnen.

[m,n]=size(Konturen); 

%Testen ob die einzelnen Konturen die gleichen z-Koordinaten haben
for i=1:m
    for j=1:n
        if ~isempty(Konturen{i,j})
            if (Konturen{i,j}(1,3)==Konturen{i,j}(:,3))
                %Alles OK
            else
                warning(['Nicht alle Punkte von Kurve (',int2str(i),',',int2str(j),') haben die selbe z-Kooridnate.'])
            end
        end
    end
end

%Skalierung der y-Achse von Grad zu Millimeter
for k=1:size(Konturen,1) %Index, der durch die Ebenen von Konturen geht
    for i=1:size(Konturen,2) %Index, der durch Unterkurven von Konturen geht
        if ~isempty(Konturen{k,i})
            Skalierfaktor=(2*pi*Konturen{k,1}(1,3))/360;
            Konturen{k,i}(:,2)=Konturen{k,i}(:,2)*Skalierfaktor; %Skalierung der y-Achse von Grad zu Millimeter
        end
    end
end

%Berechnung wichtiger Grundparameter f�r Schraffurerstellung
BreiteX=zeros(1,size(Konturen,1)); %Array zur Speicherung der maximalen Breite in X-Richtung jeder Schraffur
Winkel=zeros(1,size(Konturen,1)); %Array zur Speicherung des berechneten Schraffurwinkels jeder Ebene
WinkelN=zeros(1,size(Konturen,1)); %Array zur Speicherung des negativen Schraffurwinkels jeder Ebene
Anzahllinien=zeros(1,size(Konturen,1)); %Anzahl Linien die in einen Umfang passen bei gegebenem Winkel
Linienabstande=zeros(1,size(Konturen,1)); %Array zur Speicherung angepasster Linienabst�nde
LinienabstandeN=zeros(1,size(Konturen,1)); %Array zur Speicherung angepasster Linienabst�nde f�r die Verzerrung
SkywritestartN=zeros(1,size(Konturen,1)); %Array zur Speicherung der berechneten SkywriteStartl�nge f�r die Verzerrung
SkywriteendN=zeros(1,size(Konturen,1)); %Array zur Speicherung der berechneten SkywriteEndl�nge f�r die Verzerrung
VorschubDominant=zeros(1,size(Konturen,1)); %Array zur Speicherung des berechneten Vorschubs der Dominanten Drehachse
Umfang=zeros(1,size(Konturen,1)); %Array zur Speicherung des berechneten Umfangs jeder Ebene
Drehoffsets=zeros(1,size(Konturen,1)); %Array zur Speicherung der Drehoffsetl�nge zwischen den Ebenen
WarnungGezeigt=0; %Vermerkt ob der Warnhinweis zur Drehzahl bereits gezeigt wurde
for k=1:size(Konturen,1) %Index, der durch die Ebenen von Konturen geht
    Konturenexist=0;
    minx=+Inf;
    maxx=-Inf;
    for i=1:size(Konturen,2) %Index, der durch Unterkurven von Konturen geht
        if ~isempty(Konturen{k,i})
            Konturenexist=1;
            if min(Konturen{k,i}(:,1))<minx
                minx=min(Konturen{k,i}(:,1));
            end
            if max(Konturen{k,i}(:,1))>maxx
                maxx=max(Konturen{k,i}(:,1));
            end
        end
    end
    if Konturenexist==1 %Es existieren SchnittKonturen auf dieser Ebene
        BreiteX(k)=maxx-minx;
        SchnittHoehe=Konturen{k,1}(1,3);
        Umfang(k)=(2*pi*SchnittHoehe);
        
        WinkelKlein=atand((Verhaeltnis*Linienabstand)/BreiteX(k)); %kleinstm�glicher Winkel
        WinkelMax=asind((VorschubAmax*Umfang(k))/(360*Scangeschw)); %Maximalm�glicher Winkel ohne �berschreitung der maximalen Drehzahl und Scangeschwindigkeit
        WinkelGross=atand(Umfang(k)/Linienabstand); %gr�ssm�glicher Winkel 
        if Schraffurwinkelinkrem==0 || k==1 %Winkelinkrement wird nicht verwendet
            if Modus==1 %kleinstm�glicher Winkel
                MinJumplengthY=0;
                if WinkelAnpassung==0 %Winkelanpassung wird nicht verwendet
                    Winkel(k)=WinkelKlein;
                else%WinkelAnpassung==1 %Winkelanpassung wird verwendet
                    if WinkelKlein>WinkelMax
                        Winkel(k)=WinkelMax;
                    else
                        Winkel(k)=WinkelKlein;
                    end
                end
            elseif Modus==2 %freigew�hlter Winkel
                if WinkelAnpassung==0 %Winkelanpassung wird nicht verwendet
                    Winkel(k)=Schraffurwinkelstart;
                else %WinkelAnpassung==1 %Winkelanpassung wird verwendet
                    if Schraffurwinkelstart>WinkelMax
                        Winkel(k)=WinkelMax;
                    elseif Schraffurwinkelstart<-WinkelMax
                        Winkel(k)=-WinkelMax;
                    elseif Schraffurwinkelstart>=0 && Schraffurwinkelstart<WinkelKlein
                        Winkel(k)=WinkelKlein;
                    elseif Schraffurwinkelstart>-WinkelKlein && Schraffurwinkelstart<0
                        Winkel(k)=-WinkelKlein;
                    end
                end
            elseif Modus==3 %gr�sstm�glicher Winkel
                if WinkelAnpassung==0 %Winkelanpassung wird nicht verwendet
                    Winkel(k)=WinkelGross;
                else %WinkelAnpassung==1 %Winkelanpassung wird verwendet
                    if WinkelGross>WinkelMax
                        Winkel(k)=WinkelMax;
                    elseif WinkelGross<-WinkelMax
                        Winkel(k)=-WinkelMax;
                    elseif WinkelGross>=0 && WinkelGross<WinkelKlein
                        Winkel(k)=WinkelKlein;
                    elseif WinkelGross>-WinkelKlein && WinkelGross0
                        Winkel(k)=-WinkelKlein;
                    end
                end
            end
        else %Winkelinkrement wird verwendet
            Winkel(k)=Winkel(k-1)+Schraffurwinkelinkrem;
            if WinkelAnpassung==0 %Winkelanpassung wird nicht verwendet
                while Winkel(k)>WinkelGross 
                    Winkel(k)=Winkel(k)-(2*WinkelGross);
                end
            else %WinkelAnpassung==1 %Winkelanpassung wird verwendet
                if WinkelMax>WinkelKlein %Damit er in der Whileschlaufe nicht h�ngen bleibt
                    while (Winkel(k)>WinkelMax) || (Winkel(k)>-WinkelKlein && Winkel(k)<WinkelKlein)
                        if Winkel(k)>WinkelMax
                            Winkel(k)=Winkel(k)-(2*WinkelMax);
                        end
                        if Winkel(k)>-WinkelKlein && Winkel(k)<WinkelKlein
                            Winkel(k)=Winkel(k)+(2*WinkelKlein);
                        end
                    end
                end
            end
        end       
        WinkelN(k)=-Winkel(k); %Vorzeichenwechsel damit Darstellung intuitiver
        Anzahllinien(k)=(Umfang(k)*cosd(WinkelN(k)))/Linienabstand; %Anzahl Linien die in einen Umfang passen bei gegebenem Winkel
        Linienabstande(k)=(Umfang(k)*cosd(WinkelN(k)))/round(Anzahllinien(k)); %Angepasster Linienabstand damit die obere Schraffurkante indentisch mit der Unteren ist
        LinienabstandeN(k)=Linienabstande(k)/cosd(WinkelN(k)); %Linienabstand f�r Berechnungen inerhalb der Verzerrung
        SkywritestartN(k)=Skywritestart*cosd(WinkelN(k)); %SkywriteStartL�nge f�r Berechnungen inerhalb der Verzerrung
        SkywriteendN(k)=Skywriteend*cosd(WinkelN(k)); %SkywriteEndL�nge f�r Berechnungen inerhalb der Verzerrung
        VorschubDominant(k)=abs((360*Scangeschw*sind(WinkelN(k)))/Umfang(k)); %Vorschub der Dominanten Drehachse wird berechnen
        if VorschubDominant(k)>=VorschubAmax %Maximal m�gliche Drehzahl wird �berschritten
            if WarnungGezeigt==0 %Warnung wurde noch nie angezeigt
                warning('Hinweis: Die maximale Drehzahl wird �berschritten');
                WarnungGezeigt=1;
            end
        end
    end
end
 
%Folgende Schlaufe versetzt die Y-Koordinaten jedes Punktes (Verzerrung)
for k=1:size(Konturen,1) %Index, der durch die Ebenen von Konturen geht
    for i=1:size(Konturen,2) %Index, der durch Unterkurven von Konturen geht
        if ~isempty(Konturen{k,i})
            Konturen{k,i}(:,2)=Konturen{k,i}(:,2)+Konturen{k,i}(:,1)*tand(WinkelN(k));
        end
    end
end

Schraffuren=cell(m,1); %CellArray zur Speicherung der Schraffuren jeder Ebene
Umdrehungen=cell(m,1); %CellArray zur Speicherung der zus�tzlichen Umdrehungen jeder Ebene
AnzahlUmdrehungen=0; %Z�hlt die Anzahl voller Umdrehungen
bar = waitbar(0,'Schraffuren werden berechnet...'); %Ladebalken erstellen
for k=1:m %Index, der durch die Ebenen itteriert
counter=1; %Index, der hilft die berechneten SectPts ins Array SectPts einzuf�llen
if isempty(Konturen{k,1}) %In dieser Ebene gibt es keine geschlossenen Konturen
    SectPts=[];
    YLines=[];
else %In dieser Ebene gibt es geschlossenen Konturen

%Schritt 0: Arraygr�sse absch�tzen
    %tic
    %disp('Schritt 0');
    miny=Inf; %Mininalwert der Schraffur in Y-Richtung
    maxy=-Inf; %Maximalwert der Schraffur in Y-Richtung
    AnzahlSectPts=0;
    for i=1:size(Konturen,2) %Index, der durch die geschlossenen Kurven auf der selben Ebene iteriert
        if ~isempty(Konturen{k,i})
            for p=1:(size(Konturen{k,i},1)-1)
                %AnzahlSectPts=AnzahlSectPts+1+ceil(abs(Konturen{k,i}(p,1)-Konturen{k,i}(p+1,1))/Linienabstand);
                AnzahlSectPts=AnzahlSectPts+1+ceil(abs(Konturen{k,i}(p,2)-Konturen{k,i}(p+1,2))/Linienabstand);
                if min(Konturen{k,i}(:,2))<miny
                    miny=min(Konturen{k,i}(:,2)); 
                end
                if max(Konturen{k,i}(:,2))>maxy
                    maxy=max(Konturen{k,i}(:,2)); 
                end
            end
        end
    end
    AnzahlSectPts=AnzahlSectPts+100;
    SectPts=zeros(AnzahlSectPts,4); %Array zur Speicherung der Schnittpunkte
    if Modus==1 %kleinstm�glicher Winkel
        if Skywrite==0
            hy=[miny+Linienabstand*Verhaeltnis+0.0001:LinienabstandeN(k):maxy]'; %Hatchvektor
        else
            if WinkelN(k)>0
                hy=[miny+Linienabstand*Verhaeltnis+0.0001+SkywritestartN(k)*sind(WinkelN(k)):LinienabstandeN(k):maxy]'; %Hatchvektor
            else
                hy=[miny+Linienabstand*Verhaeltnis+0.0001+SkywritestartN(k)*sind(-WinkelN(k)):LinienabstandeN(k):maxy]'; %Hatchvektor
            end
        end
    else %Modus==2 %freiw�hlbarer Winkel oder Modus==3 %gr�sstm�glicher Winkel
        if Skywrite==0
            hy=[miny+0.0001:LinienabstandeN(k):maxy]'; %Hatchvektor
        else
            hy=[miny+0.0001:LinienabstandeN(k):maxy]'; %Hatchvektor
        end
    end
    %toc
    
%Schritt 1: Berechne die Schnittpunkte zwischen den Y-linien (hy) und den Konturen
    %disp('Schritt 1');
    %tic
    for i=1:size(Konturen,2) %Index, der durch die geschlossenen Kurven auf der selben Ebene iteriert
        if ~isempty(Konturen{k,i}) 
            for p=1:size(Konturen{k,i},1)-1 %Index der durch die Zeilen der Konturen geht
                E0=Konturen{k,i}(p,1:3); %vorangehender Eckpunkt 0 wird zwischengespeichert
                E1=Konturen{k,i}(p+1,1:2); %aktiver Eckpunkt 1 wird zwischengespeichert
                if E0(2)<E1(2) 
                    hy_cut=hy((E0(2)<hy)&(hy<=E1(2))); %Y-koordinaten der SectPts zwischen E0 und E1 werden berechent 
                    if ~isempty(hy_cut)
                        if hy_cut(end)==E1(2) %E1 liegt auf einer hatchlinie
                            warning('Konturpunkt liegt auf Hatchline'); 
                            Richtung=1;
                            if p==(size(Konturen{k,i},1)-1) %Am Ende der Kontur angelangt
                                if isequal(E1,Konturen{k,i}(1,1:2)) %Kontur geschlossen
                                    E2Y=Konturen{k,i}(2,2); %folgender Eckpunkt 2 wird zwischengespeichert
                                else %Kontur nicht geschlossen
                                    E2Y=-Inf; %Letzter Punkt E1 der ungeschlossenen Kontur wieder aus hy_cut entfernen
                                end
                            else %Noch nicht am Ende der Kontur angelangt
                                E2Y=Konturen{k,i}(p+2,2); %folgender Eckpunkt 2 wird zwischengespeichert
                            end
                            if E2Y<E1(2) %"Ber�hrung" Spezialfall B
                                hy_cut(end)=[]; %E1 wieder entfernen
                            elseif E2Y==E1(2) %"Ein Nachbar auf gleicher Linie" Spezialfall C
                                %nichts machen, E1 ist schon richtig gespeichert
                            else %E2Y>E1(2) "Schnitt" Spezialfall A
                                %nichts machen, E1 ist schon richtig gespeichert
                            end
                        end
                    end
                    x_interpol=E0(1)+(E1(1)-E0(1))/(E1(2)-E0(2))*(hy_cut-E0(2)); %x-Koordinaten der SectPts werden berechnet
                elseif E0(2)>E1(2)  
                    hy_cut=hy((E0(2)>hy)&(hy>=E1(2))); %Y-koordinaten der SectPts zwischen E0 und E1 werden berechent
                    if ~isempty(hy_cut)
                        if hy_cut(1)==E1(2) %E1 liegt auf einer Hatchlinie
                            warning('Konturpunkt liegt auf Hatchline');                           
                            Richtung=-1;
                            if p==(size(Konturen{k,i},1)-1) %Am Ende der Kontur angelangt
                                if isequal(E1,Konturen{k,i}(1,1:2)) %Kontur geschlossen
                                    E2Y=Konturen{k,i}(2,2); %zweiter Eckpunkt 2 wird zwischengespeichert
                                else %Kontur nicht geschlossen
                                    E2Y=Inf; %Letzter Punkt E1 der ungeschlossenen Kontur wieder aus hy_cut entfernen
                                end
                            else %Noch nicht am Ende der Kontur angelangt
                                E2Y=Konturen{k,i}(p+2,2); %folgender Eckpunkt 2 wird zwischengespeichert
                            end
                            if E2Y>E1(2) %"Ber�hrung" Spezialfall B  
                                hy_cut(1:end-1,:)=hy_cut(2:end,:); %Restvektor �ber E1 aufr�cken
                                hy_cut(end)=[]; %letzter Eintrag l�schen
                            elseif E2Y==E1(2) %"Ein Nachbar auf gleicher Linie" Spezialfall C
                                %nichts machen, E1 ist schon richtig gespeichert
                            else  %E2Y<E1(1) "Schnitt" Spezialfall A
                                %nichts machen, E1 ist schon richtig gespeichert
                            end
                        end
                    end
                    x_interpol=E1(1)+(E0(1)-E1(1))/(E0(2)-E1(2))*(hy_cut-E1(2)); %x-Koordinaten der SectPts werden berechnet
                else % E0 und E1 liegen auf hy 
                    if ~isempty(find(hy==E0(2),1)) %liegt punkt E0 (und damit auch E1) genau auf einer Schnittline?
                        E2=Konturen{k,i}(p+2,1:2); %folgender Eckpunkt 2 wird zwischengespeichert
                        if E2(2)==E1(2) %"Beide Nachbarn auf gleicher Linie" Speziallfall D
                            hy_cut=[]; 
                            x_interpol=[]; 
                        else %"Ein Nachbar auf gleicher Linie" Speziallfall C "Richtungswechsel"
                            if Richtung==1 && (E1(2)>E2(2)) || Richtung==-1 && (E1(2)<E2(2))
                                hy_cut=E1(2);
                                x_interpol=E1(1);
                            else %"Kein Richtungswechsel"
                                hy_cut=[]; 
                                x_interpol=[];
                            end
                        end
                    else %Liniensegment liegt nicht auf einer Linie von hx_cut
                        hy_cut=[];
                        x_interpol=[];
                    end
                end
                
                nmb_cuts=length(hy_cut); %Anzahl Schnittpunke
                if size(SectPts,1)<counter+nmb_cuts-1 %Hat es in SectPts noch genug platz?
                    warning('Array SectPts ist zu klein');
                    SectPts=[SectPts;zeros(counter+nmb_cuts-1-size(SectPts,1),4)]; %SectPts wird erweitert
                end
                SectPts(counter:counter+nmb_cuts-1,1:3)=[x_interpol,hy_cut,ones(nmb_cuts,1)*E0(3)]; %SectPts werden in SectPts angeh�ngt
                counter=counter+nmb_cuts; %der Index Counter wird ensprechend erh�ht
            end
        end
    end
    SectPts(counter+1:end,:)=[]; %Leere Eintr�ge entfernen
    SectPts(counter,1:3)=[inf,inf,inf]; %Anf�gen eines Schlusspunkts (Trick f�r Folgeschlaufe)
    %toc
    %Schritt1=SectPts;

%Schritt 2: Sortiere SectPts absteigenden nach y-Koordinaten
    %disp('Schritt 2');
    %tic
	[~,ind]=sort(SectPts(:,2));
    SectPts=SectPts(ind,:);
    %toc
    %Schritt2=SectPts;

% Schritt 3a: Die Schnittpunkte nach Y-Koordinaten ins CellArray YLines sortieren
    %disp('Schritt 3a');
    %tic
    YLines=cell(length(hy),1); %CellArray zur Speicherung der Punkte jeder Y-Linie
    YLineIndex=1; %Index zum einf�llen der Linienpunkte in YLines
    staIndex=1; %Index zur Kennzeichnung einer neuen Y-Linie in SectPts
    staWert=SectPts(staIndex,2);
    for endIndex=1:size(SectPts,1)%Endindex itteriert durch alle SectPts
        if SectPts(endIndex,2)~=staWert %Beginn neuer Y-Linie endteckt
            YLines{YLineIndex,1}=SectPts(staIndex:endIndex-1,:);
            YLineIndex=YLineIndex+1;
            staIndex=endIndex;
            staWert=SectPts(staIndex,2);
        end
    end
    YLines(YLineIndex:end)=[]; %Leere CellArrayeintr�ge entfernen
    %Schritt3a=YLines;
    %toc

% Schritt 3b: Punkte in YLines absteigend nach X-Koordinaten sortieren
    %disp('Schritt 3b');
    %tic
    for YLineIndex=1:size(YLines,1) %Itteriert durch alle YLines
        if WinkelN(k)>0
            YLines{YLineIndex}(:,1)=sort(YLines{YLineIndex}(:,1),'ascend'); %Sortiert X-Koordinaten aufsteigend
        else
            YLines{YLineIndex}(:,1)=sort(YLines{YLineIndex}(:,1),'descend'); %Sortiert X-Koordinaten absteigend
        end
    end
    %Schritt3b=YLines;
    %toc   
    
% Schritt 3c: gleiche Y-Lines zusammenf�gen berechnen
    %disp('Schritt 3c');
    %tic
    YRowSize=round(Umfang(k)/LinienabstandeN(k));
    YRow=cell(YRowSize,1); %CellArray zur Speicherung der Punkte jeder Y-Linie
    YRowIndex=1; %Index zum Einf�llen der Linienpunkte in YRow
    hyIndex=1; %Index f�r den Hatchvektor hy 
    for YLineIndex=1:size(YLines,1) %YLineIndex itteriert durch alle YLinien 
        while YLines{YLineIndex,1}(1,2)~=hy(hyIndex) %Bei leerer Punktelinie hyIndex und YRowIndex nachf�hren
            hyIndex=hyIndex+1;
            YRowIndex=YRowIndex+1;
        end    
        YRowIndex=mod(hyIndex,YRowSize); %YRowIndex berechnen um aktuelle YLine Punkte korrekt in YRow einzuf�gen
        if YRowIndex==0
            YRowIndex=YRowSize;
        end
        if isempty(YRow{YRowIndex,1}) %Keine LinienPunkte vorhanden
            YRow{YRowIndex,1}=YLines{YLineIndex,1};
        else %LinienPunkte vorhanden
            YRow{YRowIndex,1}=[YRow{YRowIndex,1};YLines{YLineIndex,1}]; %YLiniensegmente zusammenf�gen in YRow
        end
        hyIndex=hyIndex+1;
        YRowIndex=YRowIndex+1;
    end
    %Schritt3c=YRow;
    %toc 
    YLines=YRow;     
    
% Schritt 4: Skywritelinien berechnen
    %disp('Schritt 4');
    %tic
    if WinkelN(k)>0
        order=0;
    else
        order=1;
    end
    for YLineIndex=1:size(YLines,1) %Itteriert durch alle YLines
        if ~isempty(YLines{YLineIndex,1})
            %Skywrite wird nicht verwendet
            if Skywrite==0 
                if order==0
                    YLines{YLineIndex}=flipud(YLines{YLineIndex});
                    YLines{YLineIndex}(1,4)=7; %Jumplinie mit 7 kennzeichnen
                    YLines{YLineIndex}(2:2:end,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    YLines{YLineIndex}(3:2:end,4)=5; %Jeder zweite Eintrag in der vierten Spalte wird auf 5 (Laserauslinie) gesetzt
                else %order==1
                    YLines{YLineIndex}=flipud(YLines{YLineIndex});
                    YLines{YLineIndex}(1,4)=7; %Jumplinie mit 7 kennzeichnen
                    YLines{YLineIndex}(2:2:end,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    YLines{YLineIndex}(3:2:end,4)=5; %Jeder zweite Eintrag in der vierten Spalte wird auf 5 (Laserauslinie) gesetzt
                end
            %Skywrite wird verwendet    
            else %Skywrite==1
                if order==0
                    AnzahlXPts=size(YLines{YLineIndex},1);
                    LinePts=zeros(AnzahlXPts+2,4); %Array zur Speicherung aktueller LinienPunkte
                    LinePts(2:end-1,:)=flipud(YLines{YLineIndex});
                    LinePts(1,4)=7; %Jumplinie mit 7 kennzeichnen
                    LinePts(3:2:AnzahlXPts+1,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    LinePts(4:2:AnzahlXPts+1,4)=5; %Jeder zweite Eintrag in der vierten Spalte wird auf 5 (Skywriteendlinie) gesetzt
                    LinePts(1,2:3)=LinePts(2,2:3); %SkywrieStartlinie
                    LinePts(1,1)=LinePts(2,1)+SkywritestartN(k); %SkywrieStartlinie
                    LinePts(2,4)=2; %SkywrieStartlinie                  
                    LinePts(end,2:3)=LinePts(end-1,2:3); %SkywriteEndlinie
                    LinePts(end,4)=3; %SkywriteEndlinie  
                    LinePts(end,1)=LinePts(AnzahlXPts+1,1)-SkywriteendN(k); %SkywriteEndlinie
                    
                    YLines{YLineIndex,1}=LinePts; %LinePts ins Cellarray YLines einf�llen
                else %order==1
                    AnzahlXPts=size(YLines{YLineIndex},1);
                    LinePts=zeros(AnzahlXPts+2,4); %Array zur Speicherung aktueller LinienPunkte
                    LinePts(2:end-1,:)=flipud(YLines{YLineIndex});
                    LinePts(1,4)=7; %Jumplinie mit 7 kennzeichnen
                    LinePts(3:2:AnzahlXPts+1,4)=1; %Jeder zweite Eintrag in der vierten Spalte wird auf 1 (Laserlinie) gesetzt
                    LinePts(4:2:AnzahlXPts+1,4)=5; %Jeder zweite Eintrag in der vierten Spalte wird auf 5 (Laserauslinie) gesetzt
                    LinePts(1,2:3)=LinePts(2,2:3); %SkywrieStartlinie
                    LinePts(1,1)=LinePts(2,1)-SkywritestartN(k); %SkywrieStartlinie
                    LinePts(2,4)=2; %SkywrieStartlinie
                    LinePts(end,2:3)=LinePts(end-1,2:3); %SkywriteEndlinie
                    LinePts(end,4)=3; %SkywriteEndlinie              
                    LinePts(end,1)=LinePts(AnzahlXPts+1,1)+SkywriteendN(k); %SkywriteEndlinie
                    YLines{YLineIndex,1}=LinePts; %LinePts ins Cellarray YLines einf�llen
                end
            end
        end
    end
    %Schritt4=YLines; 
    %toc

    %Schritt 5: R�ckversetzen der Y-Koordinaten jedes Punktes (R�ckVerzerrung)
    for YLineIndex=1:size(YLines,1) %Itteriert durch alle YLines
         if ~isempty(YLines{YLineIndex,1})
              YLines{YLineIndex,1}(:,2)=YLines{YLineIndex,1}(:,2)-YLines{YLineIndex,1}(:,1)*tand(WinkelN(k));
         end
    end
    %Schritt5=YLines; 

    %Schritt 6: Drehoffset und Jumplinienberechnung durch umordnen der YLinien
    %disp('Schritt 6');
    %tic 
    if k==1
        Drehoffsets(k)=Drehoffsetlength;
    end
    %Finden der optimalen n�chstgelegenen Y-Koordinate 
    YDistanceAlt=Inf;
    for YLineIndex=1:size(YLines,1) %YLineIndex iteriert durch alle YLines
        if ~isempty(YLines{YLineIndex}) %aktuelle YLinie ist nicht leer
            YWert=YLines{YLineIndex}(1,2);
            if YWert<Drehoffsets(k)
                YWert=YWert+Umfang(k);
            end    
            YDistanceNeu=YWert-Drehoffsets(k); %K�rzeste Distanz zur n�chsten YLinie berechnen
            if YDistanceNeu<YDistanceAlt %Neue Distance kleiner als alte Distance
                YDistanceAlt=YDistanceNeu; %Neue k�rzesete Distance zwischenspeichern
                YLineIndexOK=YLineIndex; %Neuer optimaler Index merken
            end
        end
    end
    %Index f�r YLinien bestimmen um danach umzuordnen
    jumps=ceil(abs(((BreiteX(k)+SkywritestartN(k)+SkywriteendN(k))*tand(WinkelN(k))+MinJumplengthY)/Linienabstande(k))); %Anzahl Linien die �berspringt werden m�ssen
    Vorhanden=~cellfun(@isempty,YLines); %Gibt an ob im Cellarray YLines die entsprechende YLinie vorhanden ist 
    LengthVorhanden=length(Vorhanden); %L�nge vom Vektor Vorhanden
    Ende=length(find(Vorhanden)); %Anzahl nicht leerer Eintr�ge von Vorhanden
    Liste=zeros(Ende,1); %Liste enth�lt die Indexe zur Neuanordnung von YLines
    ListenIndex=1; %Index zur einordnung gefundener Werte in Liste
    q=YLineIndexOK; %Index der durch Vorhanden itteriert
    while ListenIndex<=Ende
        if Vorhanden(q)==1 %Eintrag noch vorhanden
            Liste(ListenIndex)=q; %Liste erg�nzen
            ListenIndex=ListenIndex+1;
            Vorhanden(q)=0; %Dieser q Eintrag ist nun nicht mehr vorhanden
            q=q+jumps;
        else %Vorhanden(p)==0 %Eintrag nicht mehr vorhanden
            q=q+1;
        end
        if q>LengthVorhanden
            q=q-LengthVorhanden;
            if q>LengthVorhanden
                q=1;
            end
        end
    end
    Schraffuren{k,1}=cell2mat(YLines(Liste)); %Neuanordnung der YLinien und Speicherung in Schraffuren    
    if k<length(Drehoffsets)
        Drehoffsets(k+1)=mod(Schraffuren{k,1}(end,2)+Drehoffsetlength,Umfang(k)); %Drehoffset f�r n�chste Schraffur berechnen
    end
    %Schritt6=Schraffuren{k};
    %toc
    
    %Schritt 7: Winkel der vollen Umdrehungen berechnen
    UmdrehungArray=zeros(size(Schraffuren{k},1),1); %Array zur Speicherung voller Umdrehungen in Grad
    Umdrehung=find(Schraffuren{k}(1:end-1,2)>Schraffuren{k}(2:end,2)); %Rolloverstellen sind in diesem Vektor mit einer 1 vermerkt
    if k>1
        if Schraffuren{k-1}(end,2)>Schraffuren{k}(1,2) %Rollover zwischen zwei Ebenen findet statt
            AnzahlUmdrehungen=AnzahlUmdrehungen+1; 
        end
    end
    staIndex=1;
    for UmdrehungIndex=1:length(Umdrehung)%UmdrehungIndex itteriert durch das Array Umdrehung
        UmdrehungArray(staIndex:Umdrehung(UmdrehungIndex))=AnzahlUmdrehungen*360; %Volle Umdrehungen werden berechnet
        staIndex=Umdrehung(UmdrehungIndex)+1;
        AnzahlUmdrehungen=AnzahlUmdrehungen+1;
    end
    UmdrehungArray(staIndex:end)=AnzahlUmdrehungen*360; %Restliche Eintr�ge werden bef�llt
    Umdrehungen{k,1}=UmdrehungArray; 

    waitbar(k/m); %Ladebalken aktualisieren
end
end
%close(bar); %Ladebalken schliessen
delete(bar);

%Skalierung der y-Achse von Millimeter zu Grad
for k=1:size(Schraffuren,1) %Index, der durch die Ebenen von Schraffuren geht
    if ~isempty(Schraffuren{k,1})
        Skalierfaktor=360/(2*pi*Schraffuren{k,1}(1,3));
        Schraffuren{k,1}(:,2)=Schraffuren{k,1}(:,2).*Skalierfaktor;
    end
end

end