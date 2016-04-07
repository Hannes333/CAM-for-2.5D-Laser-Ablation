function []=FD2Schraffur(DSchraffur,d,Schraffuren)
%Funktion, die die Schraffuren darstellt

if DSchraffur==1
    %bar = waitbar(0.2,'Schraffur wird dargestellt...'); %Ladebalken erstellen
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    Heigths=[Schraffuren{k}(1,3),Schraffuren{k}(1,3)];
    SizeH=size(Schraffuren{k},1);
    for h=2:SizeH
        if Schraffuren{k}(h-1,2)<=Schraffuren{k}(h,2) %Kein RolloverPunkt
            if Schraffuren{k}(h,4)==0 %Eilgang
                    plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'y');
            elseif Schraffuren{k}(h,4)==1 || Schraffuren{k}(h,4)==4 %Laserlinie
                plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'b');
            elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
                plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'g');
            elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
                plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'r');
            elseif Schraffuren{k}(h,4)==5 %Laserauslinie (Zwischenlinie)
                plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'Color',[1,0.65,0]);
            elseif Schraffuren{k}(h,4)==7 %Laserauslinie (Eilgang)
                plot3(Schraffuren{k}(h-1:h,1),Schraffuren{k}(h-1:h,2),Heigths,'Color',[1,0.9,0]);
            end
        else %RolloverPunkt existiert
            E1x=Schraffuren{k}(h-1,1);
            E1y=Schraffuren{k}(h-1,2);
            E11y=Schraffuren{k}(h-1,2)-360;
            E2x=Schraffuren{k}(h,1);
            E2y=Schraffuren{k}(h,2);
            if E1y<360 && E2y>0
                Sx=(E1x)+((E2x-E1x)*-E11y)/(E2y-E11y);
                if Schraffuren{k}(h,4)==0 %Eilgang
                    plot3([E1x,Sx],[E1y,360],Heigths,'y');
                    plot3([Sx,E2x],[0,E2y],Heigths,'y');
                elseif Schraffuren{k}(h,4)==1 || Schraffuren{k}(h,4)==4 %Laserlinie
                    plot3([E1x,Sx],[E1y,360],Heigths,'b');
                    plot3([Sx,E2x],[0,E2y],Heigths,'b');
                elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
                    plot3([E1x,Sx],[E1y,360],Heigths,'g');
                    plot3([Sx,E2x],[0,E2y],Heigths,'g');
                elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
                    plot3([E1x,Sx],[E1y,360],Heigths,'r');
                    plot3([Sx,E2x],[0,E2y],Heigths,'r');
                elseif Schraffuren{k}(h,4)==5 %Laserauslinie (Zwischenlinie)
                    plot3([E1x,Sx],[E1y,360],Heigths,'Color',[1,0.65,0]);
                    plot3([Sx,E2x],[0,E2y],Heigths,'Color',[1,0.65,0]);
                elseif Schraffuren{k}(h,4)==7 %Laserauslinie (Eilgang)
                    plot3([E1x,Sx],[E1y,360],Heigths,'Color',[1,0.9,0]);
                    plot3([Sx,E2x],[0,E2y],Heigths,'Color',[1,0.9,0]);
                end
            end
        end
        %if mod(h,round(SizeH/10))==0 %Ladebalken nicht bei jedem Schleifendurchlauf aktualisieren (Rechenleistung sparen)
        %    waitbar(h/SizeH); %Aktualisierung Ladebalken
        %end
    end  
    
%view([0 90]); %Set a nice view angle
%axis('image'); %Skalierung der Achsen fix
daspect([1 (360/(2*pi)) 1]); %Konstante Achsenskalierung von X- und Y-Achse
axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
set(gcf, 'visible', 'on');
%close(bar); %Ladebalken schliessen

end

end