function [] = workspace(bot,q0)
workspace_points = [];
N=9;
th1 = bot.qlim(1, 1):abs((bot.qlim(1, 2)-bot.qlim(1, 1))/N): bot.qlim(1, 2); % Angulo 1
th2 = bot.qlim(2, 1):abs((bot.qlim(2, 2)-bot.qlim(2, 1))/N): bot.qlim(2, 2); % Angulo 2
th3 = bot.qlim(3, 1):abs((bot.qlim(3, 2)-bot.qlim(3, 1))/N): bot.qlim(3, 2); % Angulo 3
th4 = bot.qlim(4, 1):abs((bot.qlim(4, 2)-bot.qlim(4, 1))/N): bot.qlim(4, 2); % Angulo 4
th5 = bot.qlim(5, 1):abs((bot.qlim(5, 2)-bot.qlim(5, 1))/N): bot.qlim(5, 2); % Angulo 5
for i = 1:N
    for j = 1:N
        for k = 1:N
          for z = 1:N
              for l = 1:N
            
            qq = [th1(i), th2(j), th3(k), th4(z), th5(l)];
            T_qq = bot.fkine(qq); 
           
            if T_qq.t(3) > 0
                % Store the workspace point
                workspace_points = [workspace_points;T_qq.t(1), T_qq.t(2), T_qq.t(3)];
            end
              end
          end
          
        end
    end
end
% Plot de workspace
view(3)
plot3(workspace_points(:,1), workspace_points(:,2), workspace_points(:,3), 'b.','MarkerSize', 0.7);
xlabel('Posicion X');
ylabel('Posicion Y');
zlabel('Posicion Z');
title('Espacio de Trabajo');
grid on;
axis equal;
view(3)

end

