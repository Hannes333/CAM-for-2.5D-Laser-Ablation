function []=FD2Schnittkontur(D,d,Konturen)
%Funktion, die die Konturen darstellt

if D==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    %for k=1:size(Konturen,1)
    k=d;
    for i=1:size(Konturen,2)
        if ~isempty(Konturen{k,i})
            plot3(Konturen{k,i}(:,1),Konturen{k,i}(:,2),Konturen{k,i}(:,3),'k')
        end
    end
    %end
    %axis('image'); %Skalierung der Achsen fix
    daspect([1 (360/(2*pi)) 1]) %Konstante Achsenskalierung von X- und Y-Achse
    axis tight %DarstellungsFeld so nahe am 3d Objekt wie möglich
    set(gcf, 'visible', 'on')
end

end

