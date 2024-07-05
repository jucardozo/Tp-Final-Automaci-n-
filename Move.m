%% Movimiento hacia los punto deseado ,punta levantada
function [qt_p1_off] = Move(q_status,X,Y,Z,bot)

t = [0:.1:0.5]'; % pasos para jtraj
Tp1 = [ 1  0  0 (X)   
       0  1  0 (Y) 
       0  0  1 Z
       0  0  0 1];
   
%Tp1 = SE3(T_p1);

qp1 = bot.ikine(Tp1, 'mask', [1 1 1 0 0 0]);

qp1_d=(qp1)*90/(pi/2); %fin => chequear. 

qt_p1_off = jtraj(q_status, qp1,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 

bot.plot(qt_p1_off)
end

