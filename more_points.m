function coord = more_points(x1, x2, y1, y2, cant)
    m = (y2-y1)/(x2-x1);
    if abs(y2-y1)<abs(x2-x1)
        x = linspace(x1, x2, cant);
        y = m*(x-x1) + y1;
    else
        y = linspace(y1, y2, cant);
        x = (y-y1)/m +x1;
    end
    
    coord = [x ; y];
end