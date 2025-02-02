clear all
close all
clc
%% Prueba de angulo de línea
% pos_flatline = get_line_coord('imagenes/prueba1.jpg')
% pos_pend = get_line_coord('imagenes/prueba2.jpg')
% pos_pend_neg = get_line_coord('imagenes/prueba3.jpg')
%% Prueba de angulo de camara
pos_real = [ 23 136 ; 162 86];
pos_recto = get_line_coord('imagenes/prueba10.jpg');
pos_izq = get_line_coord('imagenes/prueba11.jpg');
pos_arriba = get_line_coord('imagenes/prueba12.jpg');
pos_der = get_line_coord('imagenes/prueba13.jpg');
pos_abajo = get_line_coord('imagenes/prueba14.jpg');

err_recto = abs(pos_recto-pos_real)./pos_real .*100
err_izq = abs(pos_izq-pos_real)./pos_real .*100
err_arriba = abs(pos_arriba-pos_real)./pos_real .*100
err_abajo = abs(pos_abajo-pos_real)./pos_real .*100
err_der = abs(pos_der-pos_real)./pos_real .*100
err_max = max([err_recto;err_izq;err_abajo;err_arriba;err_der], [], "all");
fprintf('Error por coordenada es menor al %g%%\n',round(err_max, 2)+0.1);