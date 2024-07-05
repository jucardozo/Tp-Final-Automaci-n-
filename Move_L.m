%% Movimiento Vertical de la punta Z_off => Z_on
%Con la posicion generada, se toca el papel con el fibron. 

function [qt_p1_on] = Move_L(q_status,X,Y,Z,bot)

t = [0:.1:0.5]'; % pasos para jtraj

T_p1_on = [ 1  0  0 (X)   
       0  1  0 (Y) 
       0  0  1 Z
       0  0  0 1];
   
Tp1_on = SE3(T_p1_on);

qp1_on = bot.ikine(Tp1_on, 'mask', [1 1 1 0 0 0]);

qp1on_d=(qp1_on)*90/(pi/2); %fin => chequear. 

qt_p1_on = jtraj(q_status, qp1_on,t); %Generacion de Trayectoria desde el estado estacionario , al estado ready 
bot.plot(qt_p1_on)

end

