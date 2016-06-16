function denoisedemo

% ����
pfilt = '9-7';                                                % ������(pyramidal)�ֽ���˲�������
dfilt = 'pkva';                                               % ����ֽ���˲�������
nlevs = [3,4,4,5,5];    % Number of levels for DFB at each pyramidal levelÿ�����������ķ����˲����鼶��
th = 3;                     % lead to 3*sigma threshold denoising  ����Ӳ��ֵΪ3�ĵ���ֵ����

im = imread('barbara.png');
im = double(im);%����ͼ��תΪ˫�����ͱ��ڴ���

sigma = 20;
nim = im + sigma * randn(size(im));
%��Ӿ�ֵΪ0������Ϊsigma^2����̬�ֲ��������,�༴��˹����


%%%%% contourlet���� %%%%%
y = pdfbdec(nim, pfilt, dfilt, nlevs);%pdfbdec=���η����˲����ֽ�=contourlet�ֽ�
[c, s] = pdfb2vec(y);%��contourletϵ��ת����ʸ��ϵ��


% ������ֵ

% ������Ҫ����PDFB���������׼��
nvar = pdfb_nest(size(im,1), size(im, 2), pfilt, dfilt, nlevs);                      % ��������

cth = th * sigma * sqrt(nvar);%��ֵ            PDFB���������׼���Ǧ�*nvar       Ӳ��ֵΪ3*�ģ�PDFB��


% Slightly different thresholds for the finest scaleϸ�߶��ϵ���ֵ����΢�Ĳ�ͬ
fs = s(end, 1);
fssize = sum(prod(s(find(s(:, 1) == fs), 3:4), 2));                  %����һ���ж���s(end,1)=s(:,1)��ϵ��                            
cth(end-fssize+1:end) = (4/3) * cth(end-fssize+1:end);%����ϸ�߶��ϵ���ֵ

%������ϵ������ͳһ��ֵ����
c = c .* (abs(c) > cth);

% contourlet�ع�
y = vec2pdfb(c, s);%�ָ�contourletϵ��
cim = pdfbrec(y, pfilt, dfilt);%contourlet�ع�



%�����ֵ�����
error=im-cim;
mse=((sum(sum(error.^2)))/(length(im)^2))^0.5;
psnr=20*log10(255/mse)

%תΪ�޷��Ű�λ����,������imshow������ʾͼ��.
im=uint8(im);
cim=uint8(cim);
nim=uint8(nim);

%��ͼ
subplot(2,2,1),imshow(im);title('ԭʼͼ��'); 

subplot(2,2,2),imshow(nim);title('����ͼ��'); 

subplot(2,2,3),imshow(cim);title('Contourletȥ��');                                      
colormap('gray');          



