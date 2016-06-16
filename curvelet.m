%����С������ֵ���ɽ���ͼ��ȥ��


%matlab�ж�ȡͼ�������������uint8����������ʹ�õ�����������double������Ҫ��������ת��
img = imread('camera.jpg');
img=double(img);

%����n��sigma��is_real�Ĵ�С
n = size(img,1);%��һά�ĳ���
sigma = 20;%�����ı�׼����sigma
is_real = 1;

%����noisy_imgΪ��������������ͼ�����ݣ������ķ�����sigma�����Ե��ڷ���Ĵ�С����������
noisy_img = img + sigma*randn(n);

%noisy_img=imnoise(img,'salt & pepper',0.01); %���뷽��Ϊ0.05�Ľ�������

%�������������������ֵ

%����X��ֵ
X = randn(n);
%����fdct_usfft������ͨ�����ٸ��ϱ任�㷨����������������任ϵ��������tic��tic���������ȡCֵ�����ʱ��
tic; C = fdct_usfft(X,is_real); toc; 
%C�������������任ϵ����,�Լ����Ϊ�൱��6��cell�Ͷ�ά���顣


%��������ˮƽ,�õ���ֵ
E = cell(size(C));%����EΪԪ����������,���ڲ�Ԫ�ؿ��������ڲ�ͬ����������
 for s=1:length(C)
   E{s} = cell(size(C{s}));
   for w=1:length(C{s})
     A = C{s}{w};
     E{s}{w} = median(abs(A(:) - median(A(:))))/.6745; %��ÿ��ϵ������E{s}{w}��������ˮƽ,ǰ�벿���ǲ�ͬ�߶���curvelet�任ϵ������ֵ��0.6745����ֵ���ƺ����еľ���ֵ��
   end%median ���������ظ�����ֵ����ֵ,abs����ֵ����
 end

%����fdct_usfft�������Ժ���ͼ�����Curvelet�任
disp(' ');
tic; C = fdct_usfft(noisy_img,is_real); toc;
Ct = C;

%��ÿ���Ӵ��ı任ϵ����Ӳ��ֵ����
for s = 2:length(C)                                                                                                              
  thresh = 3*sigma + sigma*(s == length(C));                                 
  
%����ֵ��ѡȡ��,�Ǳ����ϴ��ϵ��,������С��ϵ��, ��Ϊ����Curvelet�任����, �ϴ��Curveletϵ����Ӧ�ڽ�ǿ�ı�Ե,��֮Ϊ����
  for w = 1:length(C{s})
    Ct{s}{w} = C{s}{w}.* (abs(C{s}{w}) > thresh*E{s}{w});           %��ֵΪ3�ġ�
  end
end



%����ifdct_usfft����������Curvelet��任�õ�ȥ����ͼ��
restored_img = ifdct_usfft(Ct,is_real);

%���ú���PNSR�����ֵ�����,mseΪ�������
error=img-restored_img;
mse=((sum(sum(error.^2)))/(length(img)^2))^0.5;
psnr=20*log10(255/mse)

img=uint8(img);
noisy_img=uint8(noisy_img);
restored_img=uint8(restored_img);

figure; 
%���ԭͼ�� 
subplot(2,2,1); imshow(img);title('ԭ����ͼ��');
%������д���������ͼ��
subplot(2,2,2); imshow(noisy_img);title('�����������ͼ��');
%���ȥ����ͼ��
subplot(2,2,3); imshow(restored_img);title('Curvelet�任ȥ����ͼ��');
%subplot(1,3,3); imagesc(restored_img); colormap gray;axis('image');title('Curvelet�任ȥ����ͼ��');
                        

