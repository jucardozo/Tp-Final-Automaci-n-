%Trabajo Final Automacion Industrial 
%En el siguiente codigo se modelo un brazo robotico de 5 DOF, con  la
%salvedad de que el gripper esta unido al �ltimo joint. Se trabaja con un
%gripper tipo pinza el cual se utilizara para agarra un fibron.

% Para la resolucion del mismo, se considero que el TCP del gripper se
% encuentra entre las pinzas y el payload con el que se trabaja es
% despreciable. 

%WidowX_MKII, tendra programados 4 pasos de los cuales uno tiene la
%caracteristica de moverse solo verticalmente, haciendo un movimiento
%lineal(Move_L), mientras que el segundo podra moverse libremente(Move)

clear
close all
clc

% tol = input('Ingrese un número entre 0 y 100 para definir la tolerancia de los actuadores.\nSe recomienda utilizar valores menores a 20:\n');
% 
% % Se comprueba que se ingresó un parámetro válido
% if tol > 100
%     tol = 100;
% elseif tol < 0
%     tol = 0;
% end

%Zona de trabajo
% Coordenadas de la hoja
X_Hoja=0.2; %ancho
Y_Hoja=0; %largo

Z_off=0.10; %punta levantada
Z_on=0; %punta apoyada

image_path = input('Ingrese la imagen de referencia (tiene que estar dentro de la carpeta "imagenes"):\n', 's');
image_path = strcat('imagenes/', image_path);
puntos = get_line_coord(image_path);
disp(puntos)

% Punto inicial
X_1 = puntos(1, 1)*0.001+X_Hoja;
Y_1 = puntos(1, 2)*0.001;
% Punto final
X_2 = puntos(2, 1)*0.001 + X_Hoja;
Y_2 = puntos(2, 2)*0.001;

% Genero puntos intermedios, como m�ximo quedan pasos de 1cm
points = more_points(X_1, X_2, Y_1, Y_2, 20);

% Genero el robot
[WidowX_MKII, Links] = RobotArm(100);

% Limito el workspace
WidowX_MKII.qlim(1, :) = [ deg2rad(-14) deg2rad(60)];
WidowX_MKII.qlim(2, :) = [ deg2rad(16.3) deg2rad(30)];
WidowX_MKII.qlim(3, :) = [ deg2rad(-30) deg2rad(0)];
WidowX_MKII.qlim(4, :) = [ deg2rad(-20) deg2rad(90)];
% Ploteo la hoja
plot3(points(1, :), points(2, :), zeros(size(points)), 'b', 'LineWidth', 1);
H1 = rectangle('Position', [X_Hoja Y_Hoja 0.2 0.15], 'FaceColor','w');
q_status=Ready(WidowX_MKII); %despierto mi robot. 
%Continuar?

cont = input('Input any key to continue, ''n'' to exit program:', 's');
if (cont=='n' || cont=='N')
    error('Program terminated');
end

% Paso 1, nos acercamos al punto inicial con la punta levantada.
q_status=Move(q_status(6,:),X_1,Y_1,Z_off,WidowX_MKII);
% Paso 2
% Bajo end_effector. Movimiento unicamente en eje Z. 
q_status=Move_L(q_status(6,:),X_1,Y_1,Z_on,WidowX_MKII);
% Paso 3
% Muevo el end-effector punto a punto
[~, fora] = size(points);
for i = 2:(fora-1)
    q_status=Move(q_status(6,:), points(1, i), points(2, i), Z_on, WidowX_MKII);
end
% Traslado hacia el ultimo punto con punta acentada.
q_status=Move(q_status(6,:),X_2,Y_2,Z_on,WidowX_MKII);
%Paso 4
%Levanto end_effector
q_status=Move_L(q_status(6,:),X_2,Y_2,Z_off,WidowX_MKII);

% cont = input('Input any key to continue to plot workspace, ''n'' to exit program:', 's');
% if (cont=='n' || cont=='N')
%     error('Program terminated');
% end

% %workspace de todo el brazo robotico
% workspace(WidowX_MKII, 9)




