function coord = get_line_coord(path)
% Encuentra los puntos inicial y final de una imagen con una línea roja dentro de una box de 15cmx20cm
    %% CARGA DE IMAGEN
    im=iread(path);
    im_d=idouble(im); 
    if show_figures(1)
        figure
        idisp(im_d);
    end

    %% FILTRO DE COLOR DE LA IMAGEN
    clean = filter_rg(im_d, 'green');
    %% DETECCION DE LINEAS PARA EL BOX
    imlin=Hough(clean, 'suppress', 30);

    if show_figures(2)
        figure
        idisp(clean);
        imlin.plot
        
        figure
        imlin.lines
    end

    rhos = imlin.lines.rho;
    thetas = imlin.lines.theta;

    [a, nlines] = size(rhos);
    if nlines ~= 4
        error('Problemas para detectar el box, intente con una nueva foto');
    end

    %% LOCALIZO LAS ESQUINAS DEL BOX
    [y_max, x_max, ~] = size(im);
    posi = find_corners(rhos, thetas, [y_max, x_max]);

    %% WARPING PARA PONER LA IMAGEN DERECHA
    posf = [0, 0; x_max, 0 ; x_max, y_max; 0, y_max];

    H = homography(posi', posf');
    warped = homwarp(H, im_d, 'size', im);
    if show_figures(2)
        figure
        idisp(warped);
    end

    %% FILTRAR COLOR ROJO
    im_red_line = filter_rg(warped, 'red');
    %% DETECTAR INICIO Y FIN DE LA LÍNEA
    redline=Hough(im_red_line, 'suppress', 20);
    [a, nlines] = size(redline.lines.rho);
    if nlines ~= 1
        error('Problemas con la ínea roja, intente con una nueva foto');
    end
    if show_figures(2)
        figure
        idisp(im_red_line);
        redline.plot
    end
    
    pix_pos = line_start_finish(redline.lines.rho, redline.lines.theta, im_red_line);

    x_pos_mm = 200*(pix_pos(:, 1)/x_max);
    y_pos_mm = 150*(1-pix_pos(:, 2)/y_max);
    coord = [x_pos_mm y_pos_mm];
    
    if show_figures(1)
        figure
        idisp(warped);
        line(pix_pos(:, 1), pix_pos(:, 2),'Color','blue', 'LineWidth', 1.5);
    end


end