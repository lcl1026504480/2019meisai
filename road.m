%% I. 清空环境
clc
clear
Road=imread('p1.bmp');
Road=logical(Road);
x1=[67.05 66.90 66.74 66.47 66.33 66.25 65.93];%南边的插值
y1=[17.97 17.95 17.99 17.99 17.98 17.93 17.98];
xi1=67.05:-0.01:65.93;
yi1 = interp1(x1,y1,xi1, 'cubic');
y4=[18.38 18.35 18.29 18.23 18.19 18.06 17.98];%东边的插值
x4=[65.62 65.64 65.64 65.59 65.73 65.81 65.91];
yi4=17.98:0.01:18.38;
xi4 = interp1(y4,x4,yi4, 'cubic');
x7=[67.12 66.9 66.71 66.46 66.17 66.09];%北面的一号段插值
y7=[18.51 18.48 18.48 18.47 18.45 18.44];
xi7=66.09:0.01:67.12;
yi7 = interp1(x7,y7,xi7, 'cubic');
x8=[66.13 66.02 65.98 65.82 65.67 65.62];%北面的二号段插值
y8=[18.47 18.45 18.46 18.41 18.36 18.38];
xi8=65.62:0.01:66.13;
yi8 = interp1(x8,y8,xi8, 'cubic');
y10=[18.51 18.48 18.42 18.36 18.3 18.29 18.2 18.04 17.97];%西面的插值
x10=[67.12 67.17 67.16 67.27 67.24 67.19 67.15 67.21 67.18];
yi10=18.51:-0.01:17.97;
xi10 = interp1(y10,x10,yi10, 'cubic');
x11=[67.18 67.05];%西面和南面接壤的插值
y11=[17.97 17.97];
xi11=67.18:0.01:67.05;
yi11 = interp1(x11,y11,xi11, 'cubic');
x5=[65.65 66.13 66.567];
y5=[18.33 18.292 18.43];
jindu=-[xi1,xi4,xi8,xi7,xi10,67.05];
weidu=[yi1,yi4,yi8,yi7,yi10,17.97];

py=-[65.65 66.03 66.07 66.16 66.73];%投放点经度
px=[18.33 18.22 18.44 18.40 18.47];%投放点纬度
pc=[5 7 4 12 2];%投放点物资负重
dm=[3.5 8 14 11 15 22 20];%飞机最大负重
p1=[0 1 1 1 1 1 0];
p2=[0 0 1 0 1 1 0];
p3=[0 1 1 1 1 1 0];
p4=[0 0 1 0 1 1 0];
p5=[1 1 1 1 1 1 0];
p=[p1;p2;p3;p4;p5];%投放点和无人机关系
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
popymin=-67.2;
popymax=-65.6;
ws=0.9;
we=0.4;
%% IV. 产生初始粒子和速度
for i = 1:sizepop
    % 随机产生一个种群
    pop(i,1:3) = 0.3*rands(1,3)+18.2; 
    pop(i,4:6) = -(0.8*rands(1,3)+66.4); %初始种群
    V(i,:) = rands(1,6);  %初始化速度
    % 计算适应度
    [fitness(i),pf,dt] = roadfun(pop(i,:),pc,dm,p,jindu,weidu,Road);   %染色体的适应度
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
        [fitness(j),pf,dt] = roadfun(pop(j,:),pc,dm,p,jindu,weidu,Road); 
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
plot(jindu,weidu);
xlabel('Latitude','fontsize',12);ylabel('Longitude','fontsize',12);
hold on
dt
zx=zbest(1:3);
zy=zbest(4:6);
scatter(py,px,'filled')
xlabel('Latitude','fontsize',12);ylabel('Longitude','fontsize',12);
if sum(pf)==5 && fitnesszbest>0
    for i=1:3
        if sum(dt(i,:))~=0
            hold on
            scatter(zy(i),zx(i),'filled')
            hold on
        end
    end
    grid
end
for i=1:5
    text(py(i)+0.01,px(i)+0.01,['p',num2str(i)])
end
if sum(pf)==5 && fitnesszbest>0
    for i=1:3
        for j=1:5
             if dt(i,j)~=0
                 ri=mod(dt(i,j),10);
                 hold on
                 plot([zy(i),py(j),zy(ri)],[zx(i),px(j),zx(ri)])
            end
        end
    end
    legend('borders','Delivery Locations','cargo container1','cargo container2','cargo container3',...
       'route 1','route 2','route 3','route 4','route 5')
end



