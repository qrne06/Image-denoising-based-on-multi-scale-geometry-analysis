clear

X=imread('barbara.png');
X=double(X);
x=X+30*randn(size(X));



%С��ȥ��:

[thr,sorh,keepapp]=ddencmp('den','wv',x);%������ֵ,wvָ����ֵ����ʽΪʹ��С���ֽ⡣ddencmp�Զ�����С���������ֵѡȡ������sorh=hΪӲ��ֵ��sorh=sΪ����ֵ.
xd=wdencmp('gbl',x,'sym4',2,thr,sorh,keepapp);%wdencmp��С����ֵȥ��,gbl��ȫ����ֵ,ÿһ�㶼����ͬһ����ֵ���д���,�ֽ����㡣
%�򵥶��ԣ�С��������һ���˲���,sym4��һ��С����,����һ����symС��.����Ӧ�ò�ͬ��ѡ��С�����ķ���Ҳ������ͬ

%����С��ȥ��������
error1=X-xd;
mse1=((sum(sum(error1.^2)))/(length(X)^2))^0.5;
psnr1=20*log10(255/mse1)

X=uint8(X);
x=uint8(x);
xd=uint8(xd);


figure(1);
subplot(131),imshow(X);title('ԭʼͼ��');
subplot(132),imshow(x);title('�����ͼ��');
subplot(133),imshow(xd);title('С��ȥ���ͼ��');



