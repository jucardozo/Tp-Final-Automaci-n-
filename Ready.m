%%Widow_MK_II se pone en posicion de preparacion, lista para trabajar.
function [move] = Ready(bot)
% 
% t = [0:.1:0.5]'; % pasos para jtraj
% X_Home=0.105 ; 
% Y_Home=0 ;
% Z_Home=0.130;
% qs = [0 pi -2.6180 0.5236 0 ]; % Posicion Inicial .
% 
% T_p1 = [ 1  0  0 (X_Home)   
%        0  1  0 (Y_Home) 
%        0  0  1 Z_Home
%        0  0  0 1];
%    
% Tp1 = SE3(T_p1);
% 
% qp1 = bot.ikine(Tp1, 'mask', [0 1 1 1 1 1]);
% 
% qp1_d=(qp1)*90/(pi/2) %fin => chequear. 

t = [0:.1:0.5]'; % pasos para jtraj
qs = [0 pi -2.6180 0.5236 0 ]; % Posicion Inicial .
qp_start=[0 0 0 0 0];


move = jtraj(qs, qp_start,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 

bot.plot(move)

end

