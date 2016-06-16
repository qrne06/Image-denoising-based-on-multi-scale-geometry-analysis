clear

X=imread('camera.jpg');
X=double(X);
x=X+30*randn(size(X));



%小波去噪:

[thr,sorh,keepapp]=ddencmp('den','wv',x);%生成阈值,wv指定阈值处理方式为使用小波分解。ddencmp自动生成小波处理的阈值选取方案，sorh=h为硬阈值，sorh=s为软阈值.
xd=wdencmp('gbl',x,'sym4',2,thr,sorh,keepapp);%wdencmp是小波阈值去噪,gbl是全局阈值,每一层都采用同一个阈值进行处理,分解两层。
%简单而言，小波基就是一个滤波器,sym4是一种小波基,消噪一般用sym小波.根据应用不同，选择小波基的方法也不尽相同

%脊波去噪:

X1=radon(x,0:179);%radon transform;X1是存储radon变换的值，它是一个矩阵，列数是0-179的个数，表示每一个角度生成一列，行数是被处理的矩阵x对角线的长度。radon变换：一个平面内沿不同的直线对图像做线积分
A=reshape(X1,66060,1);%把矩阵变成一列的   729*180=131220  367*180=66060
[ca,cd]=dwt(A,'db1');%使用小波'db1'对信号进行单层分解，求得的近似系数(低频分量)存放在数组ca中，细节（高频分量）放在cd中。
[thr,sorh,keepapp] = ddencmp('den','wv',cd);%ddencmp（）函数自动生成小波消噪或压缩的阈值选取方案。den为去噪。
cd1 = wdencmp('gbl',cd,'sym1',1,thr,sorh,keepapp);%对含噪比较多的高频分量进行阈值去噪。
A0=idwt(ca,cd1,'db1');  %对消噪后的分量进行逆小波变换重构图像列矩阵
A1=reshape(A0,367,180);%将列矩阵恢复为原矩阵
A2=iradon(A1,0:179,256);%逆radon变换恢复图像

%生成图像:

%计算小波去噪的信噪比
error1=X-xd;
mse1=((sum(sum(error1.^2)))/(length(X)^2))^0.5;
psnr1=20*log10(255/mse1)

%计算ridgelet去噪的信噪比
error2=X-A2;
mse2=((sum(sum(error2.^2)))/(length(X)^2))^0.5;
psnr2=20*log10(255/mse2)

X=uint8(X);
x=uint8(x);
xd=uint8(xd);
A2=uint8(A2);


figure(1);
subplot(221),imshow(X);title('原始图像');
subplot(222),imshow(x);title('加噪后图像');
subplot(223),imshow(xd);title('小波去噪后图像');
A2 = wiener2(A2,[3 3]);%维纳滤波
subplot(224),imshow(A2);title('脊波去噪后图像');



