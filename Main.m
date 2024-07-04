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

tol = input('Ingrese un número entre 0 y 100 para definir la tolerancia de los actuadores.\nSe recomienda utilizar valores menores a 20:\n');

% Se comprueba que se ingresó un parámetro válido
if tol > 100
    tol = 100;
elseif tol < 0
    tol = 0;
end

%Zona de trabajo
%Dimensiones de la X e Y de una hoja A4

X_Hoja=0.21; %ancho
Y_hoja=0.297; %largo
Z_off=0.10; %punta levantada
Z_on=0.05; %punta apoyada

% Genero el robot
[WidowX_MKII, Links] = RobotArm(tol);
q_status=Ready(WidowX_MKII); %despierto mi robot. 
%Continuar?

%Pedir Puntos => Dima
%Provisorios
X_1=0.28 ; 
Y_1=0 ; 

%Paso 1, nos acercamos o aproximamos a la estacion de trabajo.
q_status=Move(q_status(6,:),X_1,Y_1,Z_off,WidowX_MKII) 
%Paso 2
%Bajo end_effector. Movimiento unicamente en eje Z. 
q_status=Move_L(q_status(6,:),X_1,Y_1,Z_on,WidowX_MKII)

%Pedir Puntos => Dima
%Provisorios
X_2=0.2;
Y_2=0.1;

%Paso 3
%nos traslado hacia el otro punto con punta acentada.
q_status=Move(q_status(6,:),X_2,Y_2,Z_on,WidowX_MKII)

%Paso 4
%Levanto end_effector
q_status=Move_L(q_status(6,:),X_2,Y_2,Z_off,WidowX_MKII)


%workspace de todo el brazo robotico
q_status=Ready(WidowX_MKII); %despierto mi robot. 

workspace(WidowX_MKII,q_status)




