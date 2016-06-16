clear

X=imread('camera.jpg');
X=double(X);
x=X+30*randn(size(X));



%С��ȥ��:

[thr,sorh,keepapp]=ddencmp('den','wv',x);%������ֵ,wvָ����ֵ����ʽΪʹ��С���ֽ⡣ddencmp�Զ�����С���������ֵѡȡ������sorh=hΪӲ��ֵ��sorh=sΪ����ֵ.
xd=wdencmp('gbl',x,'sym4',2,thr,sorh,keepapp);%wdencmp��С����ֵȥ��,gbl��ȫ����ֵ,ÿһ�㶼����ͬһ����ֵ���д���,�ֽ����㡣
%�򵥶��ԣ�С��������һ���˲���,sym4��һ��С����,����һ����symС��.����Ӧ�ò�ͬ��ѡ��С�����ķ���Ҳ������ͬ

%����ȥ��:

X1=radon(x,0:179);%radon transform;X1�Ǵ洢radon�任��ֵ������һ������������0-179�ĸ�������ʾÿһ���Ƕ�����һ�У������Ǳ�����ľ���x�Խ��ߵĳ��ȡ�radon�任��һ��ƽ�����ز�ͬ��ֱ�߶�ͼ�����߻���
A=reshape(X1,66060,1);%�Ѿ�����һ�е�   729*180=131220  367*180=66060
[ca,cd]=dwt(A,'db1');%ʹ��С��'db1'���źŽ��е���ֽ⣬��õĽ���ϵ��(��Ƶ����)���������ca�У�ϸ�ڣ���Ƶ����������cd�С�
[thr,sorh,keepapp] = ddencmp('den','wv',cd);%ddencmp���������Զ�����С�������ѹ������ֵѡȡ������denΪȥ�롣
cd1 = wdencmp('gbl',cd,'sym1',1,thr,sorh,keepapp);%�Ժ���Ƚ϶�ĸ�Ƶ����������ֵȥ�롣
A0=idwt(ca,cd1,'db1');  %�������ķ���������С���任�ع�ͼ���о���
A1=reshape(A0,367,180);%���о���ָ�Ϊԭ����
A2=iradon(A1,0:179,256);%��radon�任�ָ�ͼ��

%����ͼ��:

%����С��ȥ��������
error1=X-xd;
mse1=((sum(sum(error1.^2)))/(length(X)^2))^0.5;
psnr1=20*log10(255/mse1)

%����ridgeletȥ��������
error2=X-A2;
mse2=((sum(sum(error2.^2)))/(length(X)^2))^0.5;
psnr2=20*log10(255/mse2)

X=uint8(X);
x=uint8(x);
xd=uint8(xd);
A2=uint8(A2);


figure(1);
subplot(221),imshow(X);title('ԭʼͼ��');
subplot(222),imshow(x);title('�����ͼ��');
subplot(223),imshow(xd);title('С��ȥ���ͼ��');
A2 = wiener2(A2,[3 3]);%ά���˲�
subplot(224),imshow(A2);title('����ȥ���ͼ��');



