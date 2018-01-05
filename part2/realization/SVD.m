A = imread('selfie.jpg');
A = rgb2gray(A);
A = im2double(A);
[U,S,V] = svd(A);
S_1=zeros(size(A));S_2=zeros(size(A));S_5=zeros(size(A));S_10=zeros(size(A));S_20=zeros(size(A));S_r=zeros(size(A));
S_1(1,1) = S(1,1);
S_2(1:2,1:2) = S(1:2,1:2);
S_5(1:5,1:5) = S(1:5,1:5);
S_10(1:10,1:10) = S(1:10,1:10);
S_20(1:20,1:20) = S(1:20,1:20);
A_1 = U*S_1*transpose(V);A_2 = U*S_2*transpose(V);A_5 = U*S_5*transpose(V);A_10 = U*S_10*transpose(V);
A_20 = U*S_20*transpose(V);;
figure;imshow(A);
figure;imshow(A_1);
figure;imshow(A_2);
figure;imshow(A_5);
figure;imshow(A_10);
figure;imshow(A_20);
r = 1;
e = 1e-3;
while S(r,r)/S(1,1) > e
    S_r(r,r) = S(r,r);
    r = r + 1;
end
r
A_r = U*S_r*transpose(V);;
figure;imshow(A_r);