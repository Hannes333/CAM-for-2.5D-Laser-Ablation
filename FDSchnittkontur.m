function []=FDSchnittkontur(D,d,Konturen)
%Funktion, die die Konturen darstellt

if D==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    %for k=1:size(Konturen,1)
    k=d;
    for i=1:size(Konturen,2)
        if ~isempty(Konturen{k,i})
            plot3([Konturen{k,i}(:,1);Konturen{k,i}(1,1)],[Konturen{k,i}(:,2);Konturen{k,i}(1,2)],[Konturen{k,i}(:,3);Konturen{k,i}(1,3)],'k')
        end
    end
    %end
    axis('image'); %Skalierung der Achsen fix
    set(gcf, 'visible', 'on')
end

end

