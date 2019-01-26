%% I. ��ջ���
clc
clear
py=[65.65 66.03 66.07 66.16 66.73];%Ͷ�ŵ㾭��
px=[18.33 18.22 18.44 18.40 18.47];%Ͷ�ŵ�γ��
R=6371;%����뾶
dx=R*pi/180;%γ�ȵ�λ����
dy=2*R*cosd(mean(px))*pi/360;%���ȵ�λ����
pc=[5 7 4 12 2];%Ͷ�ŵ����ʸ���
pc2=zeros(5,5);
dp=zeros(5,5);%Ͷ�ŵ�֮��ľ���
dis=@(x1,y1,x2,y2) sqrt(((x1-x2)*dx)^2+((y1-y2)*dy)^2);%������뺯��
for i=1:5
    for j=1:i
        dp(i,j)=dis(px(i),py(i),px(j),py(j));
        dp(j,i)=dp(i,j);
    end
end 
for i=1:4
    for j=i+1:5
        pc2(i,j)=pc(i)+pc(j);%������˻�Я�������ص������
    end
end
dm=[3.5 8 14 11 15 22 20];%�ɻ������
p1=[0 1 1 1 1 1 0];
p2=[0 0 1 0 1 1 0];
p3=[0 1 1 1 1 1 0];
p4=[0 0 1 0 1 1 0];
p5=[1 1 1 1 1 1 0];
p=[p1;p2;p3;p4;p5];%Ͷ�ŵ�����˻���ϵ
pp=[0 0 1 0 0 1 0
    0 0 1 1 0 1 0
    0 0 0 0 0 1 0
    0 1 1 1 0 1 0
    0 0 1 0 0 1 0
    0 0 0 0 0 1 0
    0 0 1 0 0 1 0
    0 0 0 0 0 1 0
    0 1 1 1 0 1 0
    0 0 1 0 0 1 0];
pp2=zeros(5,5,7);
for i=1:4
    for j=i+1:5
        if i==1
            pp2(i,j,:)=pp(j-i,:);
        else
            if i==2
                pp2(i,j,:)=pp(j-i+4,:);
            else if i==3
                     pp2(i,j,:)=pp(j-i+7,:);
                else if i==4
                         pp2(i,j,:)=pp(j-i+9,:);
                    end
                end
            end
        end
    end
end
py=[65.65 66.03 66.07 66.16 66.73];%Ͷ�ŵ㾭��
px=[18.33 18.22 18.44 18.40 18.47];%Ͷ�ŵ�γ��
% %% II. ����Ŀ�꺯������
% figure
% [x,y] = meshgrid(-5:0.1:5,-5:0.1:5);
% z = x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y) + 20;
% mesh(x,y,z)
% hold on

%% III. ������ʼ��
c1 = 1.49445;
c2 = 1.49445;

maxgen = 5000;   % ��������  
sizepop = 100;   %��Ⱥ��ģ

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
%% IV. ������ʼ���Ӻ��ٶ�
for i = 1:sizepop
    % �������һ����Ⱥ
    pop(i,1:3) = 0.3*rands(1,3)+18.2; 
    pop(i,4:6) = 0.8*rands(1,3)+66.4; %��ʼ��Ⱥ
    V(i,:) = rands(1,6);  %��ʼ���ٶ�
    % ������Ӧ��
    fitness(i) = fun2(pop(i,:),pc2,dm,pp2,dp);   %Ⱦɫ�����Ӧ��
end

%% V. ���弫ֵ��Ⱥ�弫ֵ
[bestfitness,bestindex] = max(fitness);
zbest = pop(bestindex,:);   %ȫ�����
gbest = pop;    %�������
fitnessgbest = fitness;   %���������Ӧ��ֵ
fitnesszbest = bestfitness;   %ȫ�������Ӧ��ֵ

%% VI. ����Ѱ��
for i = 1:maxgen
    w=ws - (ws-we)*(2*i/maxgen-(i/maxgen)^2);
    for j = 1:sizepop
        % �ٶȸ���
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,V(j,1:3)>Vxmax) = Vxmax;
        V(j,V(j,1:3)<Vxmin) = Vxmin;
        V(j,V(j,4:6)>Vymax) = Vymax;
        V(j,V(j,4:6)<Vymin) = Vymin;
        
        % ��Ⱥ����
        pop(j,:) = pop(j,:) + V(j,:);
        pop(j,pop(j,1:3)>popxmax) = popxmax;
        pop(j,pop(j,1:3)<popxmin) = popxmin;
        pop(j,pop(j,4:6)>popymax) = popymax;
        pop(j,pop(j,4:6)<popymin) = popymin;
        % ��Ӧ��ֵ����
        fitness(j) = fun2(pop(j,:),pc2,dm,pp2,dp); 
    end
    
    for j = 1:sizepop  
        % �������Ÿ���
        if fitness(j) > fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % Ⱥ�����Ÿ���
        if fitness(j) > fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
    yy(i) = fitnesszbest;            
end
%% VII.������
[fitnesszbest, zbest]
global pf
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
if sum(pf)==5
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


