clear
clc
RGB = imread('������.jpg'); %�̹��� load
imshow(RGB); 
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);
[height,width]=size(R)
for i = 1:height
    for j = 1:width
       Y(i,j) = R(i,j)*0.299 + G(i,j)*0.587 + R(i,j)*0.144;
    end
end
imshow(Y)
Y = Y(1:256,1:256); %�̹��� �ڸ���
imshow(Y)
imwrite(Y,'Y.jpeg')

%DCT 
c0 = sqrt(2)/2;
c1 = 1;
F = zeros(256,256);
for u=0:31
    for v=0:31
        %�Ѻ�� ���� 
        block = zeros(8,8);
        for k = 1:8
            for p = 1:8
                block(k,p) = Y((u*8)+k,(v*8)+p);
            end
        end
        %�Ѻ�� DCT
        for k = 1:8
            for p = 1:8
               sum = 0; 
               for i=0:7
                   for j=0:7
                       sum = sum + cos(((2*i+1)*(k-1)*pi)/16)*cos(((2*j+1)*(p-1)*pi)/16)*block(i+1,j+1);
                   end
               end
               if k-1==0 && p-1==0
                  sum = (c0*c0/4)*sum;
               elseif k-1~=0 && p-1~=0
                  sum = (c1*c1/4)*sum;
               else
                  sum = (c0*c1/4)*sum;
               end
               F((u*8)+k,(v*8)+p) = sum;
            end
        end
        %�Ѻ��DCT �Ϸ�
    end
end
%2���� DCT �Ϸ�
F = int32(F); %int type
figure(2)
imshow(F)
save('DCT_result.mat','F')

%IDCT 
f = zeros(256,256);
for i=0:31
    for j=0:31
        %�Ѻ�� ���� 
        block = zeros(8,8);
        for k = 1:8
            for p = 1:8
                block(k,p) = F((i*8)+k,(j*8)+p);
            end
        end
        %�Ѻ�� IDCT
        for k = 1:8
            for p = 1:8
               sum = 0;
               for u=0:7
                   for v=0:7
                       if u==0 && v==0
                           c = c0*c0;
                       elseif u~=0 && v~=0
                           c = c1*c1;
                       else
                           c = c0*c1;
                       end
                       sum = sum + c/4*cos(((2*(k-1)+1)*u*pi)/16)*cos(((2*(p-1)+1)*v*pi)/16)*block(u+1,v+1);
                   end
               end
               if sum>255 %clipping
                   sum = 255;
               elseif sum<0
                   sum = 0;
               end
               f((i*8)+k,(j*8)+p) = sum;
            end
        end
        %�Ѻ�� IDCT �Ϸ�
    end
end
%2���� IDCT �Ϸ�
f = uint8(f); %unsigned char type
figure(3)
imshow(f)
save('IDCT_result.mat','f')
imwrite(f,'IDCT.jpeg')
