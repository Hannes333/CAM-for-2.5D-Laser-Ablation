function []=FDSchraffur(DSchraffur,d,Schraffuren)
%Funktion, die die Schraffuren darstellt

if DSchraffur==1
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    for h=1:size(Schraffuren{k},1)-1
        if Schraffuren{k}(h,4)==0 %Eilgang
            plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'y')
        elseif Schraffuren{k}(h,4)==1 || Schraffuren{k}(h,4)==4 %Lasering
            plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'b')
        elseif Schraffuren{k}(h,4)==2 %SkywriteStartLength
            plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'g')
        elseif Schraffuren{k}(h,4)==3 %SkywriteEndLength
            plot3(Schraffuren{k}(h:h+1,1),Schraffuren{k}(h:h+1,2),Schraffuren{k}(h:h+1,3),'r')
        end
    end
%view([0 90]); %Set a nice view angle
axis('image'); %Skalierung der Achsen fix
set(gcf, 'visible', 'on')
end

end

