%% I. 清空环境
clc
clear
global px
global py
pc=[5 7 4 12 2];%投放点物资负重
dm=[3.5 8 14 11 15 22 20];%飞机最大负重
p1=[0 1 1 1 1 1 0];
p2=[0 0 1 0 1 1 0];
p3=[0 1 1 1 1 1 0];
p4=[0 0 1 0 1 1 0];
p5=[1 1 1 1 1 1 0];
p=[p1;p2;p3;p4;p5];%投放点和无人机关系
py=[65.65 66.03 66.07 66.16 66.73];%投放点经度
px=[18.33 18.22 18.44 18.40 18.47];%投放点纬度
% %% II. 绘制目标函数曲线
% figure
% [x,y] = meshgrid(-5:0.1:5,-5:0.1:5);
% z = x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y) + 20;
% mesh(x,y,z)
% hold on

%% III. 参数初始化
c1 = 1.49445;
c2 = 1.49445;

maxgen = 5000;   % 进化次数  
sizepop = 100;   %种群规模

Vxmax = 0.2;
Vxmin = -0.2;
Vymax=0.8;
Vymin=-0.8;
popxmax = 18.5;
popxmin = 17.9;
popymax=67.2;
popymin=65.6;
ws=0.9;
we=0.4;
%% IV. 产生初始粒子和速度
for i = 1:sizepop
    % 随机产生一个种群
    pop(i,1:3) = 0.3*rands(1,3)+18.2; 
    pop(i,4:6) = 0.8*rands(1,3)+66.4; %初始种群
    V(i,:) = rands(1,6);  %初始化速度
    % 计算适应度
    fitness(i) = fun(pop(i,:),pc,dm,p);   %染色体的适应度
end

%% V. 个体极值和群体极值
[bestfitness,bestindex] = max(fitness);
zbest = pop(bestindex,:);   %全局最佳
gbest = pop;    %个体最佳
fitnessgbest = fitness;   %个体最佳适应度值
fitnesszbest = bestfitness;   %全局最佳适应度值

%% VI. 迭代寻优
for i = 1:maxgen
    w=ws - (ws-we)*(2*i/maxgen-(i/maxgen)^2);
    for j = 1:sizepop
        % 速度更新
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,V(j,1:3)>Vxmax) = Vxmax;
        V(j,V(j,1:3)<Vxmin) = Vxmin;
        V(j,V(j,4:6)>Vymax) = Vymax;
        V(j,V(j,4:6)<Vymin) = Vymin;
        
        % 种群更新
        pop(j,:) = pop(j,:) + V(j,:);
        pop(j,pop(j,1:3)>popxmax) = popxmax;
        pop(j,pop(j,1:3)<popxmin) = popxmin;
        pop(j,pop(j,4:6)>popymax) = popymax;
        pop(j,pop(j,4:6)<popymin) = popymin;
        % 适应度值更新
        fitness(j) = fun(pop(j,:),pc,dm,p); 
    end
    
    for j = 1:sizepop  
        % 个体最优更新
        if fitness(j) > fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % 群体最优更新
        if fitness(j) > fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
    yy(i) = fitnesszbest;            
end
%% VII.输出结果
[fitnesszbest, zbest]
figure
plot(yy)
title('Optimal Individual Fitness','fontsize',12);
xlabel('iterations','fontsize',12);ylabel('fitness','fontsize',12);
figure
global dt
dt
zx=zbest(1:3);
zy=zbest(4:6);
scatter(py,px,'filled')
xlabel('Latitude','fontsize',12);ylabel('Longitude','fontsize',12);
if sum(ref)==5
    for i=1:3
        if sum(dt(i,:))~=0
            hold on
            scatter(zy(i),zx(i),'filled')
        end
    end
    grid
    legend('Delivery Locations','cargo container1','cargo container2','cargo container3')
end
for i=1:5
    text(py(i)+0.01,px(i)+0.01,['p',num2str(i)])
end


