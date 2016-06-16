%利用小曲线阈值规律进行图像去噪


%matlab中读取图像的数据类型是uint8，而矩阵中使用的数据类型是double，所以要进行数据转换
img = imread('camera.jpg');
img=double(img);

%定义n、sigma、is_real的大小
n = size(img,1);%第一维的长度
sigma = 20;%噪声的标准差是sigma
is_real = 1;

%定义noisy_img为引入随机噪声后的图像数据，噪声的方差是sigma，可以调节方差的大小而控制噪声
noisy_img = img + sigma*randn(n);

%noisy_img=imnoise(img,'salt & pepper',0.01); %加入方差为0.05的椒盐噪声

%计算随机噪声的所有阈值

%定义X的值
X = randn(n);
%调用fdct_usfft函数，通过快速傅氏变换算法，获得噪声的曲波变换系数，其中tic和tic函数计算获取C值所需的时间
tic; C = fdct_usfft(X,is_real); toc; 
%C是噪声的曲波变换系数集,自己理解为相当于6个cell型二维数组。


%计算噪声水平,得到阈值
E = cell(size(C));%定义E为元胞数组类型,其内部元素可以是属于不同的数据类型
 for s=1:length(C)
   E{s} = cell(size(C{s}));
   for w=1:length(C{s})
     A = C{s}{w};
     E{s}{w} = median(abs(A(:) - median(A(:))))/.6745; %对每个系数矩阵E{s}{w}估计噪声水平,前半部分是不同尺度下curvelet变换系数的中值，0.6745是阈值估计函数中的经验值。
   end%median 函数：返回给定数值的中值,abs绝对值函数
 end

%调用fdct_usfft函数，对含噪图像进行Curvelet变换
disp(' ');
tic; C = fdct_usfft(noisy_img,is_real); toc;
Ct = C;

%对每个子带的变换系数做硬阈值处理
for s = 2:length(C)                                                                                                              
  thresh = 3*sigma + sigma*(s == length(C));                                 
  
%在阈值的选取上,是保留较大的系数,舍弃较小的系数, 因为根据Curvelet变换理论, 较大的Curvelet系数对应于较强的边缘,反之为噪声
  for w = 1:length(C{s})
    Ct{s}{w} = C{s}{w}.* (abs(C{s}{w}) > thresh*E{s}{w});           %阈值为3δ§
  end
end



%调用ifdct_usfft函数，进行Curvelet逆变换得到去噪后的图像
restored_img = ifdct_usfft(Ct,is_real);

%调用函数PNSR，求峰值信噪比,mse为均方误差
error=img-restored_img;
mse=((sum(sum(error.^2)))/(length(img)^2))^0.5;
psnr=20*log10(255/mse)

img=uint8(img);
noisy_img=uint8(noisy_img);
restored_img=uint8(restored_img);

figure; 
%输出原图像 
subplot(2,2,1); imshow(img);title('原来的图像');
%输出带有带有噪声的图像
subplot(2,2,2); imshow(noisy_img);title('引入噪声后的图像');
%输出去噪后的图像
subplot(2,2,3); imshow(restored_img);title('Curvelet变换去噪后的图像');
%subplot(1,3,3); imagesc(restored_img); colormap gray;axis('image');title('Curvelet变换去噪后的图像');
                        

