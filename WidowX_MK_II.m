%% Creacion del Modelo del brazo ‘TROSSEN – WidowX MK-II’ 

%https://docs.trossenrobotics.com/interbotix_xsarms_docs/specifications/rx200.html
%Inspirado en el codigo de Puma560.

clear all
deg = pi/180;


%TODO => ver bien distancia de d del link 1 . Hay 130cm del link 2 a mesa,
%pero del link 2 al link 1 considero despreciable, entonces no se como
%poner los 130 cm de distancia.


%Diseño del tool , TODO Chequear Como se diseña una Herramienta?
Lgrip = 0.020; % 2cm de agarre del marcador
Lmarker = 0.020; % 2cm margen de agarre
Ltool =0.072 %0.115;%-Lgrip-Lmarker; % offset x marcador (11,5cm aprox base - agarre del robot - margen del marcador )

% Diseño del brazo=> Parametros DH MODIFICADOS

% all parameters are in SI units: m, radians, kg, kg.m2, N.m, N.m.s etc.

%Waist
L(1) = Revolute('d', 0.13, ...   % link length (Dennavit-Hartenberg notation)
    'a', 0, ...               % link offset (Dennavit-Hartenberg notation)
    'alpha', 0,'modified', ...        % link twist (Dennavit-Hartenberg notation)
    'I', [0, 0.35, 0, 0, 0, 0], ... % inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
    'r', [0, 0, 0], ...       % distance of ith origin to center of mass [x,y,z] in link reference frame
    'm', 0, ...               % mass of link
    'Jm', 200e-6, ...         % actuator inertia 
    'G', -62.6111, ...        % gear ratio
    'B', 1.48e-3, ...         % actuator viscous friction coefficient (measured at the motor)
    'Tc', [0.395 -0.435], ... % actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
    'qlim', [-180 180]*deg ); % minimum and maximum joint angle (ESPECIFICACIONES)

%Shoulder
L(2) = Revolute('d', 0, 'a',0, 'alpha', pi/2,'modified', ...
    'I', [0.13, 0.524, 0.539, 0, 0, 0], ...
    'r', [-0.3638, 0.006, 0.2275], ...
    'm', 17.4, ...
    'Jm', 200e-6, ...
    'G', 107.815, ...
    'B', .817e-3, ...
    'Tc', [0.126 -0.071], ...
    'qlim', [-180 180]*deg ); %-108 113 => No se de donde saque esas restricciones TODO

%Elbow
L(3) = Revolute('d', 0, 'a', 0.144, 'alpha', 0,'modified',  ...
    'I', [0.066, 0.086, 0.0125, 0, 0, 0], ...
    'r', [-0.0203, -0.0141, 0.070], ...
    'm', 4.8, ...
    'Jm', 200e-6, ...
    'G', -53.7063, ...
    'B', 1.38e-3, ...
    'Tc', [0.132, -0.105], ...
    'qlim', [-180 180]*deg ); %-108 93

%Wrist Angle
L(4) = Revolute('d', 0, 'a', 0.144, 'alpha', 0,'modified',  ...
    'I', [1.8e-3, 1.3e-3, 1.8e-3, 0, 0, 0], ...
    'r', [0, 0.019, 0], ...
    'm', 0.82, ...
    'Jm', 33e-6, ...
    'G', 76.0364, ...
    'B', 71.2e-6, ...
    'Tc', [11.2e-3, -16.9e-3], ...
    'qlim', [-180 180]*deg); %-100 123

%Wrist Rotate
L(5) = Revolute('d', -0.072, 'a', 0, 'alpha', -pi/2,'modified',  ...
    'I', [0.3e-3, 0.4e-3, 0.3e-3, 0, 0, 0], ...
    'r', [0, 0, 0], ...
    'm', 0.34, ...
    'Jm', 33e-6, ...
    'G', 71.923, ...
    'B', 82.6e-6, ...
    'Tc', [9.26e-3, -14.5e-3], ...
    'qlim', [-180 180]*deg );

%
% some useful poses
%

qz = [0 0 0 0 0 ]; % Posicion de home , en la cual me apoya para el parametro DH 
qs = [0 0 0 pi/2 0 ]; % Posicion Inicial . 
%qs = [0 0 -pi/2 0 0 ];  % creo que seria la misma que qr

qn=[0 pi/4 pi 0 pi/4  ];

%Tool = transl([0, 0, Ltool]);
%Tool = transl([Ltool, 0, 0])
Tool=transl([0, 0, -Ltool])

bot = SerialLink(L,'tool', Tool, 'name', 'WidowX MK-II', ...
    'configs', {'qz', qz, 'qs', qs, 'qn', qn}, ...
    'manufacturer', 'Unimation', 'ikine', 'viscous friction; params of 8/95');

bot.teach()

%% Cinematica
%Dimensiones de la X e Y de una hoja A4

X_Hoja=0.21; %ancho
Y_hoja=0.297; %largo
Z_off=0.10; %punta levantada
Z_on=0.05; %punta apoyada

%Busco Posicionar el end effector en la hoja .
%Pensamiento: Acomodar la hoja en una zona de trabajo determinada para que
%el end effector no modifique su posicion inicial.
%la punta no esta acentada (Z_off).

% Busco Graficar el primer punto . El moviemiento seria , posicionar el end
% effector en dicho punto y luego moverlo el eje z pa hacer contacto

t = [0:.1:0.5]'; % pasos para jtraj


%TODO => Buscar como restringir dichas dimensiones ,para que no se pueda
%escribir fuera de la hoja.

%Coordenadas objetivo
X_1=0.2 ; 
Y_1=0.1 ; 

X_2=0.1;
Y_2=-0.1;

%% Movimiento hacia los punto deseado ,punta levantada
T_p1 = [ 1  0  0 (X_1)   
       0  1  0 (Y_1) 
       0  0  1 Z_off
       0  0  0 1];
   
Tp1 = SE3(T_p1);

qp1 = bot.ikine(Tp1, 'mask', [0 1 1 1 1 1]);

qp1_d=(qp1)*90/(pi/2) %fin => chequear. 

qt_p1_off = jtraj(qs, qp1,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 

bot.plot(qt_p1_off)
%% Movimiento Vertical de la punta Z_off => Z_on
%Con la posicion generada, se toca el papel con el fibron. 

T_p1_on = [ 1  0  0 (X_1)   
       0  1  0 (Y_1) 
       0  0  1 Z_on
       0  0  0 1];
   
Tp1_on = SE3(T_p1_on);

qp1_on = bot.ikine(Tp1_on, 'mask', [0 1 1 1 1 1]);

qp1on_d=(qp1_on)*90/(pi/2) %fin => chequear. 

qt_p1_on = jtraj(qp1, qp1_on,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 
bot.plot(qt_p1_on)
%% Movimento hacia el punto 2 con la punta acentada
T_p2 = [ 1  0  0 (X_2)   
       0  1  0 (Y_2) 
       0  0  1 Z_on
       0  0  0 1];
   
Tp2 = SE3(T_p2);

qp2_on = bot.ikine(Tp2, 'mask', [0 1 1 1 1 1]);

qp2_d=(qp2_on)*90/(pi/2) %fin => chequear. 

qt_p2_on = jtraj(qp1_on, qp2_on,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 
bot.plot(qt_p2_on)
%% Movimiento Vertical de la punta Z_on => Z_off
T_p2_off = [ 1  0  0 (X_2)   
       0  1  0 (Y_2) 
       0  0  1 Z_off
       0  0  0 1];
   
Tp2_off = SE3(T_p2_off);

qp2_off = bot.ikine(Tp2_off, 'mask', [0 1 1 1 1 1]);

qp2_d=(qp2_off)*90/(pi/2) %fin => chequear. 

qt_p2_on = jtraj(qp2_on, qp2_off,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 
bot.plot(qt_p2_on)
%% Workspace 
step = [0:1:50]'; % pasos para jtraj
j1_min=[-17.53 0 0 90 0];
j1_max=[17.53 0 0 90 0];
j2_min=[0 -108 0 0 0];
j2_max=[0 113 0 0 0];

joint_1=jtraj(j1_min,j1_max,step);
joint_2=jtraj(j2_min,j2_max,step);
%grid on
hold on
for i =(1:length(joint_1))
    T= bot.fkine(joint_1(i,:));
    %for j=( 1:length(joint_2))
    %    T2=bot.fkine(joint_2(i,:));
    %    plot3(T.t(1),T.t(2),T2.t(3),'.')
    %end
    plot(T.t(1),T.t(2),'.')
end 

%plot3(workspace_points(:,1), workspace_points(:,2), workspace_points(:,3), 'b.','MarkerSize', 0.7);
 hold on
 T= bot.fkine([0 0 0 0 0 ]);
 for j=( 1:length(joint_2))
     T2=bot.fkine(joint_2(j,:));
     plot3(T.t(1),T.t(2),T2.t(3),'.')
 end
 hold on 
 grid on
 T= bot.fkine(joint_1(15,:));
 plot(T.t(1),T.t(2),'.')