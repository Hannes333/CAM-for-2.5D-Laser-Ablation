function [] = FD2StlObjekt( DStlObjekt,fv,farben )
%Funktion, die das Stl-objekt darstellt

if DStlObjekt==1;
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    alpha(patch(fv,'FaceColor',farben,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15),0.35)
    set (gca,'Ydir','reverse');
    %camlight(0,180); %Lichtquelle hinzufügen
    material('dull'); %Obeflächen matt
    daspect([1 (360/(2*pi)) 1]) %Konstante Achsenskalierung von X- und Y-Achse
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
end
    
end

