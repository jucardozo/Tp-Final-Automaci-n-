function corners = find_corners(rhos, thetas, size)
% encuentra las esquinas a partir de las intersecciones de las lineas de
% Hough. Devuelve las esquinas en formato [sup_izq, sup_der, inf_der,
% inf_izq]
    y_max = size(1);
    x_max = size(2);
    
    %% CALCULO DE INTERSECCIONES
    lines = [rhos; thetas];
    intersections = [];

    % Calcular intersecciones de líneas dos a dos con sus ecuaciones
    % lineales
    for i = 1:length(lines)
        for j = (i+1):length(lines)
            rho1 = lines(1, i);
            theta1 = lines(2, i);
            rho2 = lines(1, j);
            theta2 = lines(2, j);

            % Calcular la intersección
            y = (rho1*sin(theta2) - rho2*sin(theta1)) / sin(theta2 - theta1);
            x = (rho2*cos(theta1) - rho1*cos(theta2)) / sin(theta2 - theta1);

            % Verificar si las coordenadas del pixel están dentro de la imagen
            if (x >= 1 && x <= x_max && y >= 1 && y <= y_max)
                    intersections = [intersections; x, y];
            end
        end
    end

    %% ASIGNO CADA ESQUINA
    top = [ones(4, 1), zeros(4, 1)];
    bot_r = [ones(4, 1).*y_max, ones(4, 1)*x_max];
    bot_l = [zeros(4, 1), ones(4, 1)*x_max, ];

    dis = point_distance(top.*0, intersections);
    top_left = find(dis == min(dis));

    dis = point_distance(top.*x_max, intersections);
    top_right = find(dis == min(dis));

    dis = point_distance(bot_r, intersections);
    bot_right = find(dis == min(dis));

    dis = point_distance(bot_l, intersections);
    bot_left = find(dis == min(dis));

    corners = round([intersections(top_left, :); intersections(top_right, :); intersections(bot_right, :); intersections(bot_left, :)]);
end