function denoisedemo

% 参数
pfilt = '9-7';                                                % 金字塔(pyramidal)分解的滤波器名称
dfilt = 'pkva';                                               % 方向分解的滤波器名称
nlevs = [3,4,4,5,5];    % Number of levels for DFB at each pyramidal level每个金字塔级的方向滤波器组级数
th = 3;                     % lead to 3*sigma threshold denoising  设置硬阈值为3δ的阈值降噪

im = imread('barbara.png');
im = double(im);%读入图像并转为双精度型便于处理

sigma = 20;
nim = im + sigma * randn(size(im));
%添加均值为0，方差为sigma^2的正态分布随机噪声,亦即高斯噪声


%%%%% contourlet降噪 %%%%%
y = pdfbdec(nim, pfilt, dfilt, nlevs);%pdfbdec=塔形方向滤波器分解=contourlet分解
[c, s] = pdfb2vec(y);%把contourlet系数转换成矢量系数


% 设置阈值

% 首先需要估计PDFB域的噪声标准差
nvar = pdfb_nest(size(im,1), size(im, 2), pfilt, dfilt, nlevs);                      % 噪声方差

cth = th * sigma * sqrt(nvar);%阈值            PDFB域的噪声标准差是δ*nvar       硬阈值为3*δ（PDFB）


% Slightly different thresholds for the finest scale细尺度上的阈值有轻微的不同
fs = s(end, 1);
fssize = sum(prod(s(find(s(:, 1) == fs), 3:4), 2));                  %计算一共有多少s(end,1)=s(:,1)的系数                            
cth(end-fssize+1:end) = (4/3) * cth(end-fssize+1:end);%生成细尺度上的阈值

%对曲波系数进行统一阈值处理
c = c .* (abs(c) > cth);

% contourlet重构
y = vec2pdfb(c, s);%恢复contourlet系数
cim = pdfbrec(y, pfilt, dfilt);%contourlet重构



%计算峰值信噪比
error=im-cim;
mse=((sum(sum(error.^2)))/(length(im)^2))^0.5;
psnr=20*log10(255/mse)

%转为无符号八位整型,便于用imshow函数显示图像.
im=uint8(im);
cim=uint8(cim);
nim=uint8(nim);

%画图
subplot(2,2,1),imshow(im);title('原始图像'); 

subplot(2,2,2),imshow(nim);title('加噪图像'); 

subplot(2,2,3),imshow(cim);title('Contourlet去噪');                                      
colormap('gray');          



