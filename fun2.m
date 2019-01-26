function y = fun(x,pc2,dm,pp2)
global px
global py
py=[65.65 66.03 66.07 66.16 66.73];%Ͷ�ŵ㾭��
px=[18.33 18.22 18.44 18.40 18.47];%Ͷ�ŵ�γ��
dd=[70/3 158/3 112/3 18 15 158/5 17.07];%���˻������о���
R=6371;%����뾶
dx=R*pi/180;%γ�ȵ�λ����
dy=R*cosd(mean(px))*pi/360;%���ȵ�λ����
f=@(od,ml,p,cl) od*(1-cl*p/ml);%���ض��ڷ��о���Ӱ��ĺ���
dis=@(x1,y1,x2,y2) sqrt(((x1-x2)*dx)^2+((y1-y2)*dy)^2);%������뺯��
dp=zeros(5,5);%Ͷ�ŵ�֮��ľ���
sod=0;%�ܷ��о���
pid=zeros(3,5);%Ͷ�ŵ��ISO�����
dis=@(x1,y1,x2,y2) sqrt(((x1-x2)*dx)^2+((y1-y2)*dy)^2);%������뺯��
for i=1:3
    for j=1:5
        pid(i,j)=dis(x(i),x(i+3),px(j),py(j));
    end
end
pf=zeros(1,5);%Ͷ�ŵ��־
global dt
dt=zeros(3,5);%ISO�����˻����͵Ĺ�ϵ
for i=1:5
    for j=1:i
        dp(i,j)=dis(px(i),py(i),px(j),py(j));
        dp(j,i)=dp(i,j);
    end
end 
    for i=1:3
        for j=1:4
            for n=j+1:5
                for k=1:7
                    %������ȷ�j�ٷ�n
                    if pp2(j,n,k)==1 && pid(i,j)+dp(j,n)<f(dd(k),dm(k),pc2(j,n),0.4)
                        [m,mi]=min(pid(:,n));
                        if pid(i,j)+dp(j,n)<f(dd(k),dm(k),pc2(j,n),0.4)
                            if pf(j)==0 && pf(n)==0
                                dt(i,j)=k;
                                sod=sod+m+pid(i,j)+dp(j,n);
                                pf(j)=1;
                                pf(n)=1;
                            end
                        end
                    else
                        if pp2(j,n,k)==1 && pid(i,n)+dp(j,n)<f(dd(k),dm(k),pc2(j,n),0.4)
                            [m,mi]=min(pid(:,j));
                            if pid(i,n)+dp(j,n)<f(dd(k),dm(k),pc2(j,n),0.4)
                                if pf(j)==0 && pf(n)==0
                                    dt(i,n)=k;
                                    sod=sod+m+pid(i,n)+dp(j,n);
                                    pf(j)=1;
                                    pf(n)=1;
                                end
                        end
                    end
                end
            end
        end
    end
    if sum(pf)==5
        y=1/sod;
    else
        y=0;
    end
end
%             
% scatter(px,py,'filled')
% for i=1:5
%     text(px(i)+0.01,py(i)+0.01,['p',num2str(i)])
% end
% y = x(1).^2 + x(2).^2 - 10*cos(2*pi*x(1)) - 10*cos(2*pi*x(2)) + 20;



