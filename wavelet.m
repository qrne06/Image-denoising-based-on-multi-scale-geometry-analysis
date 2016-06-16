clear

X=imread('barbara.png');
X=double(X);
x=X+30*randn(size(X));



%小波去噪:

[thr,sorh,keepapp]=ddencmp('den','wv',x);%生成阈值,wv指定阈值处理方式为使用小波分解。ddencmp自动生成小波处理的阈值选取方案，sorh=h为硬阈值，sorh=s为软阈值.
xd=wdencmp('gbl',x,'sym4',2,thr,sorh,keepapp);%wdencmp是小波阈值去噪,gbl是全局阈值,每一层都采用同一个阈值进行处理,分解两层。
%简单而言，小波基就是一个滤波器,sym4是一种小波基,消噪一般用sym小波.根据应用不同，选择小波基的方法也不尽相同

%计算小波去噪的信噪比
error1=X-xd;
mse1=((sum(sum(error1.^2)))/(length(X)^2))^0.5;
psnr1=20*log10(255/mse1)

X=uint8(X);
x=uint8(x);
xd=uint8(xd);


figure(1);
subplot(131),imshow(X);title('原始图像');
subplot(132),imshow(x);title('加噪后图像');
subplot(133),imshow(xd);title('小波去噪后图像');



