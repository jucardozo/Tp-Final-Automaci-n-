function filtered_im = filter_rg(im, color)
% Filtra la imagen im por verde o rojo
    if strcmp(color, 'green')
        rg = [255, 0];
    elseif strcmp(color, 'red')
        rg=[0, 255];
    end

    %Queda con escala de grises respecto del color que filtra
    im_color = colordistance(im, rg);
    im_color=im_color/1e4; %Acomodo la escala del colordistance()
    if show_figures(2)
        figure
        idisp(im_color);        
    end
    
    im_thres=(im_color>6.486);
    if show_figures(2)
        figure
        idisp(im_thres);        
    end
    
    S = kcircle(3);
    opened = iopen(im_thres, S);
    filtered_im = iclose(opened, S);
end