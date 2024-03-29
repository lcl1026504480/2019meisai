function [y,pf,dt] = roadfun(x,pc,dm,p,jindu,weidu,Rin)
                                    global b
                                    global y1
                                    global x1
                                    global x2
                                    global y2
                                    global w
py=-[65.65 66.03 66.07 66.16 66.73];%投放点经度
px=[18.33 18.22 18.44 18.40 18.47];%投放点纬度
dd=[70/3 158/3 112/3 18 15 158/5 17.07];%无人机最大飞行距离
R=6371;%地球半径
dx=R*pi/180;%纬度单位距离
dy=2*R*cosd(mean(px))*pi/360;%经度单位距离
f=@(od,ml,p,cl) od*(1-cl*p/ml);%负重对于飞行距离影响的函数
dis=@(x1,y1,x2,y2) sqrt(((x1-x2)*dx)^2+((y1-y2)*dy)^2);%计算距离函数
% dp=zeros(5,5);%投放点之间的距离
sop=0;%重合像素个数
pid=zeros(3,5);%投放点和ISO点距离
dis=@(x1,y1,x2,y2) sqrt(((x1-x2)*dx).^2+((y1-y2)*dy).^2);%计算距离函数f
fx=@(x1) (284.505-260.84)/(-67.15+67.19)*(x1+67.19)+260.84;
fy=@(y1) (162.4-560.583)/(18.5-17.93)*(y1-17.93)+560.583;
fx1=@(x1) (284.505-260.84)\(-67.15+67.19)*(x1-260.84)-67.19;
fy1=@(y1) (162.4-560.583)\(18.5-17.93)*(y1-560.583)+17.93;
for i=1:3
    for j=1:5
        pid(i,j)=dis(x(i),x(i+3),px(j),py(j));
    end
end
pf=zeros(1,5);%投放点标志
dt=zeros(3,5);%ISO和无人机类型的关系
xp=round(fy(x(1:3)));
yp=round(fx(x(4:6)));
pxp=round(fy(px));
pyp=round(fx(py));
% for i=1:5
%     for j=1:i
%         dp(i,j)=dis(px(i),py(i),px(j),py(j));
%         dp(j,i)=dp(i,j);
%     end
% end 
    for i=1:3
        for j=1:5
            for k=1:7
                if p(j,k)==1 && pid(i,j)<f(dd(k),dm(k),pc(j),0.4)
                    for n=1:3
                        if pid(n,j)+pid(i,j)<f(dd(k),dm(k),pc(j),0.4)
                            if pf(j)==0
                                dt(i,j)=k*10+n;
                                pf(j)=1;
                                if k~=6
                                    b=false(size(Rin));
                                    w=zeros(size(Rin));
                                    if pxp(j)~=xp(i) && pxp(j)~=xp(n)
                                        x1=xp(i):sign(pxp(j)-xp(i)):pxp(j);
                                        y1=round((yp(i)-pyp(j))/(xp(i)-pxp(j))*(x1-xp(i))+yp(i));
                                        x2=xp(n):sign(pxp(j)-xp(n)):pxp(j);
                                        y2=round((yp(n)-pyp(j))/(xp(n)-pxp(j))*(x2-xp(n))+yp(n));
                                         for l=1:length(x1)
                                            b(x1(l),y1(l))=1;
                                            w(x1(l),y1(l))=sum(exp(-dis(fx1(x1(l)),fy1(y1(l)),px,py)));
                                         end
                                        for l=1:length(x2)
                                            b(x2(l),y2(l))=1;
                                            w(x2(l),y2(l))=sum(exp(-dis(fx1(x2(l)),fy1(y2(l)),px,py)));
                                        end
                                    else
                                        if pxp(j)==xp(i) && pxp(j)~=xp(n)
                                            x1=xp(i);
                                            y1=yp(i):sign(pyp(j)-yp(i)):pyp(j);
                                            x2=xp(n):sign(pxp(j)-xp(n)):pxp(j);
                                            y2=round((yp(n)-pyp(j))/(xp(n)-pxp(j))*(x2-xp(n))+yp(n));
                                            b(x1,y1)=1;
                                        else
                                            if  pxp(j)==xp(n) && pxp(j)~=xp(i)
                                                x1=xp(i):sign(pxp(j)-xp(i)):pxp(j);
                                                y1=round((yp(i)-pyp(j))/(xp(i)-pxp(j))*(x1-xp(i))+yp(i));
                                                x2=xp(n);
                                                y2=yp(n):sign(pyp(j)-yp(n)):pyp(j);
                                                b(x2,y2)=1;
                                            end
                                        end
                                    end

                                    Road1=Rin & b;
                                    sop=sop+sum(sum(Road1.*w));
                                end
                            end
                        end
                    end
                end
            end
        end
    end
zx=x(1:3);
zy=x(4:6);
ip=inpolygon(zy,zx,jindu,weidu);
if min(min(pid))>3
    y=sop*fix(sum(pf)/5)*fix(sum((ip/3)));
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




