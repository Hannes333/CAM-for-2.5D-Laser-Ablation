function [] = FDStlObjekt( DStlObjekt,fv )
%Funktion, die das Stl-objekt darstellt

if DStlObjekt==1;
    %figure %Darstellung des STL-Objekts in neuem Grafikfenster
    hold on %Schreibe folgende Grafikbefehle in das geöffnete Grafikfenster
    alpha(patch(fv,'FaceColor',[0.2 0.8 0.8],'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15),0.35)
    camlight('headlight'); %Add a camera light
    material('dull'); %Tone down the specular highlighting
    axis('image'); %Fix the axes scaling
    %view([-40 50]); %Set a nice view angle
end
    
end

