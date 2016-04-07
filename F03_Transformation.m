function [f2,v2] = F03_Transformation(f,v)
%F03_Transformation transformiert eine zylindrische Stl-Datei in eine
%kartesische (Abrollen)
%Imput Array v, enthält die Koordinaten der Eckpunkt der Dreiecke, aus
%denen das Stl-Objekt aufgebaut ist.
%imput Array f, enthält die Informationen, welche drei Eckpunkte vom Array
%v zu einem Dreieck verbunden werden müssen.
%Output Array v2, enthält die Koordinaten der transformierten Eckpunkt der 
%Dreiecke, aus denen das neue Stl-Objekt aufgebaut ist.
%Output Array f2, enthält die Informationen, welche drei Eckpunkte vom Array
%v2 zu einem Dreieck verbunden werden müssen.

bar = waitbar(0,'Transformation wird durchgeführt...'); %Ladebalken erstellen
%Schritt 0: abschätzen wie viele Einträge das neue Array v2 braucht
%disp('Schritt 0');
%tic
AnzahlDreiecke=0;
for i=1:size(f,1)
    vs=[v(f(i,1),:);v(f(i,2),:);v(f(i,3),:)]; %aktuelles Dreieck wir in vs zwischengespeichert
    [~,ind]=sort(vs(:,2),'descend');
    vs=vs(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Y einträgen sortiert 
    if (vs(1,2)>0)&&(vs(3,2)<=0) && max(vs(:,3))>0 %Dreieck wird von y=0 Ebene gespalten und hat ein Eckpunkt mit positiven Z-Koordinaten
        if min(vs(:,3))<=0 %Dreieck wird von z=0 Ebene gespalten
            AnzahlDreiecke=AnzahlDreiecke-1;
        else
            %Spezielle Transformation mit Dreieckspaltung
            AnzahlDreiecke=AnzahlDreiecke+3;
        end
    else
        %Normale Transformation
        AnzahlDreiecke=AnzahlDreiecke+1;
    end
end
%toc

%Schritt 1: Koordinatentransformation und Dreiecke die die y=0 Ebene schneiden spalten
%disp('Schritt 1');
%tic
v2=zeros(AnzahlDreiecke*3,3);
f2=zeros(AnzahlDreiecke,3);
f2(:,:)=[[1:3:AnzahlDreiecke*3]',[2:3:AnzahlDreiecke*3]',[3:3:AnzahlDreiecke*3]'];
b=[1 2 3];
for i=1:size(f,1) %Index, der durch die Dreiecke iteriert
    vs=[v(f(i,1),:);v(f(i,2),:);v(f(i,3),:)]; %aktuelles Dreieck wir in vs zwischengespeichert
    [~,ind]=sort(vs(:,2),'descend');
    vs=vs(ind,:); %die drei Eckpunktkoordinaten sind nun absteigend nach den Y-Koordinaten sortiert 
    if (vs(1,2)>0)&&(vs(3,2)<=0) && max(vs(:,3))>0 %Dreieck wird von y=0 Ebene gespalten und hat ein Eckpunkt mit positiven Z-Koordinaten
        if min(vs(:,3))<=0 %Dreieck wird von z=0 Ebene gespalten
            warning('Dreieck wird von z=0 und y=0 Ebene gespalten');
        else 
            %Spezielle Transformation mit Dreieckspaltung
            vs(:,2:3)=[atand(vs(:,3)./vs(:,2))+(vs(:,2)>0).*-180+90,sqrt(vs(:,2).^2+vs(:,3).^2)]; %Koordinatentransformation geschnittens Dreieck
            if vs(2,2)<=0 %Fall E2y<=0
                E13=[vs(1,1)+((vs(3,1)-vs(1,1))*(-vs(1,2)))/(vs(3,2)-vs(1,2)),0,vs(1,3)+((vs(3,3)-vs(1,3))*(-vs(1,2)))/(vs(3,2)-vs(1,2))];
                E23=[vs(2,1)+((vs(3,1)-vs(2,1))*(-vs(2,2)))/(vs(3,2)-vs(2,2)),0,vs(2,3)+((vs(3,3)-vs(2,3))*(-vs(2,2)))/(vs(3,2)-vs(2,2))];
                %erstes Dreieck speichern
                v2(b,:)=[[vs(1,1),vs(1,2)+360,vs(1,3)];[E13(1),360,E13(3)];[vs(2,1),vs(2,2)+360,vs(2,3)]];
                %zweites Dreieck speichern
                v2(b+3,:)=[[E13(1),360,E13(3)];[E23(1),360,E23(3)];[vs(2,1),vs(2,2)+360,vs(2,3)]];
                %drittes Dreieck speichern
                v2(b+6,:)=[vs(3,:);E23;E13];
                b=b+9;
            else %vs(2,2)>0 Fall E2y>0
                E12=[vs(1,1)+((vs(2,1)-vs(1,1))*(-vs(1,2)))/(vs(2,2)-vs(1,2)),0,vs(1,3)+((vs(2,3)-vs(1,3))*(-vs(1,2)))/(vs(2,2)-vs(1,2))];
                E13=[vs(1,1)+((vs(3,1)-vs(1,1))*(-vs(1,2)))/(vs(3,2)-vs(1,2)),0,vs(1,3)+((vs(3,3)-vs(1,3))*(-vs(1,2)))/(vs(3,2)-vs(1,2))];
                %erstes Dreieck speichern
                v2(b,:)=[[vs(1,1),vs(1,2)+360,vs(1,3)];[E13(1),360,E13(3)];[E12(1),360,E12(3)]];
                %zweites Dreieck speichern
                v2(b+3,:)=[vs(3,:);vs(2,:);E13];
                %drittes Dreieck speichern
                v2(b+6,:)=[vs(2,:);E12;E13];
                b=b+9;
            end
        end
    else 
        %Normale Transformation
        v2(b,:)=[v(f(i,:),1),atand(v(f(i,:),3)./v(f(i,:),2))+(v(f(i,:),2)>0).*180+90,sqrt(v(f(i,:),2).^2+v(f(i,:),3).^2)];
        b=b+3;
    end
    if mod(i,round(AnzahlDreiecke/50))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        waitbar((i/AnzahlDreiecke)) %Aktualisierung Ladebalken
    end
end
%toc
%close(bar); %Ladebalken schliessen
delete(bar);

end