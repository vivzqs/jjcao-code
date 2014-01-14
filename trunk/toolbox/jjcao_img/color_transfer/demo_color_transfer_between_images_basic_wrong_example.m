%%
source=imread('source.jpg');%��source��Labÿ��ͨ���ľ�ֵ�ͷ���
figure,subplot(131);imshow(source);title('Source');
cforms = makecform('srgb2lab'); 
labs = applycform(source, cforms);
ls=labs(:,:,1);
as=labs(:,:,2);
bs=labs(:,:,3);
muls=mean2(ls);
muas=mean2(as);
mubs=mean2(bs);
sigmals=std2(ls);
sigmaas=std2(as);
sigmabs=std2(bs);
%%
target=imread('target.jpg');%��target��Labÿ��ͨ���ľ�ֵ�ͷ���
subplot(132);imshow(target);title('Target');
cformt = makecform('srgb2lab'); 
labt = applycform(target, cformt);
lt=labt(:,:,1);
at=labt(:,:,2);
bt=labt(:,:,3);
mult=mean2(lt);
muat=mean2(at);
mubt=mean2(bt);
sigmalt=std2(lt);
sigmaat=std2(at);
sigmabt=std2(bt);
%%
l=(sigmalt/sigmals)*(ls-muls)+mult;
a=(sigmaat/sigmaas)*(as-muas)+muat;
b=(sigmabt/sigmabs)*(bs-mubs)+mubt;
lab(:,:,1)=l;
lab(:,:,2)=a;
lab(:,:,3)=b;
cform= makecform('lab2srgb'); 
LAB= applycform(lab, cform);
subplot(133);imshow(LAB);title('result')