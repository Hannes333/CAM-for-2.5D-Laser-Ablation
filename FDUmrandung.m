function []=FDUmrandung(DUmrandung,d,UmrandungKonturen)
%Darstellung der Umrandungskonturen in neuem Grafikfenster

if DUmrandung==1
    hold on %Schreibe folgende Grafikbefehle in das ge�ffnete Grafikfenster
    k=d; %Von dieser Ebene werden die Konturen dargestellt
    for i=1:size(UmrandungKonturen,2)
        if ~isempty(UmrandungKonturen{k,i})
            for h=1:size(UmrandungKonturen{k,i},1)-1
                if UmrandungKonturen{k,i}(h,4)==0 %Eilgang
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'y')
                elseif UmrandungKonturen{k,i}(h,4)==1 || UmrandungKonturen{k,i}(h,4)==4 %Lasering
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'b')
                elseif UmrandungKonturen{k,i}(h,4)==2 %SkywriteStartLength
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'g')
                elseif UmrandungKonturen{k,i}(h,4)==3 %SkywriteEndLength
                    plot3(UmrandungKonturen{k,i}(h:h+1,1),UmrandungKonturen{k,i}(h:h+1,2),UmrandungKonturen{k,i}(h:h+1,3),'r')
                end
            end
        end
    end
%view([0 90]); %Set a nice view angle
axis('image'); %Skalierung der Achsen fix
set(gcf, 'visible', 'on')
end

end

