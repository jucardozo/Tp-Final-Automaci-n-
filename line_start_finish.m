function p = line_start_finish(rho, theta, im)
% A partir de la línea definida por rho y theta, encuentra las coordenadas
% de una línea continua en la imagen im, considerando el grosor de la
% linea.
%% inicio
m = -sin(theta) / cos(theta);
b = rho(1) / cos(theta);

% Obtengo blob de la línea, excluyendo el fondo
blob = iblobs(im, 'area', [100, 1000000]);
[~,s] = size(blob);
if s~=1     % Si detecto, más de un blob, hay un error
    error('Blob error');
end

% Recorro la línea hasta que arranca la línea
x = blob(1).umin;
while im(round(x*m + b), x) == 0
   x = x + 1;
end
sel_x = x;
sel_y = round(x*m + b);

% Compenso por grosor de marcador.
% Estimo el grosor a partir los bordes del blob generado y las coordenadas donde
% encontró la linea
if theta<=0
    avg_grosor = round((sel_x-blob(1).umin) + (sel_y - blob(1).vmin));
else
    avg_grosor = round((sel_x-blob(1).umin) + (blob(1).vmax - sel_y));
end
x1 = sel_x + avg_grosor;
y1 = round(x1*m + b);
% fprintf('grosor estimado:%g\n', avg_grosor);

%% final
x = blob(1).umax;
while im(round(x*m + b), x) == 0
   x = x - 1;
end
sel_x = x;
sel_y = round(x*m + b);

% Compenso por grosor de marcador
% Estimo el grosor a partir los bordes del blob generado y las coordenadas donde
% encontró la linea
if theta<=0
    avg_grosor = round((blob(1).umax-sel_x) + (blob(1).vmax - sel_y));
else
    avg_grosor = round((blob(1).umax-sel_x) + (sel_y - blob(1).vmin));
end

x2 = sel_x - avg_grosor;
y2 = round(x2*m + b);

%%
p = [x1, y1; x2, y2]; 
end