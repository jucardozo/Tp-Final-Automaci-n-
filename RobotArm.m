%% Creacion del Modelo del brazo �TROSSEN � WidowX MK-II� 
%https://docs.trossenrobotics.com/interbotix_xsarms_docs/specifications/rx200.html
%Inspirado en el codigo de Puma560.

function [Robot, Links] = RobotArm(tol)

clear all
deg = pi/180;


%TODO => ver bien distancia de d del link 1 . Hay 130cm del link 2 a mesa,
%         Tolerancia 
%pero del link 2 al link 1 considero despreciable, entonces no se como
%poner los 130 cm de distancia.


% Para el end effector se concidera un marcador de 11,5cm, restándole el
% agarre y dando un margen para que el marcador pueda ser agarrado
% correctamente:

Lgrip = 0.020; % 2cm de agarre del marcador
Lmarker = 0.020; % 2cm margen de agarre
Ltool =0.115;%-Lgrip-Lmarker; % offset x marcador (11,5cm aprox base - agarre del robot - margen del marcador )



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

Links = L;
Gripper=transl([0, 0, -Ltool]);



%
% some useful poses
%

qz = [0 0 0 0 0 ]; % Posicion de home , en la cual me apoya para el parametro DH 
%Home
qs = [0 pi -2.6180 0.5236 0 ]; % Posicion Inicial .
%qs = [0 0 -pi/2 0 0 ];  % creo que seria la misma que qr

qn=[0 pi/4 pi 0 pi/4  ];



bot = SerialLink(L,'tool', Gripper, 'name', 'WidowX MK-II', ...
    'configs', {'qz', qz, 'qs', qs, 'qn', qn}, ...
    'manufacturer', 'Unimation', 'ikine', 'viscous friction; params of 8/95');
Robot=bot;

bot.plot(qs)
%bot.teach(qs)

end

