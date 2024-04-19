%%PTV

addpath('ptv codes');
%% read in images
path='R:\ENG_Breuer_Shared\group\Eva\experimental_fluids_PTV\fluid2pix'; %folder of images
cd(path)
framenum= 500;
step=1/25; %sec
pos=[0 0 0];
for frame= 1:framenum
fname = ['fluid 2_', num2str(frame,'%05.0f'), '.tif'];
a = imread(fname);
b=im2gray(a);
c=bpass(b,1,5);
pk=pkfnd(c,20,5);
cnt=cntrd(c,pk,15);
leng=size(cnt,1);
pos(end+1:end+leng,:)= [cnt(:,1:2) frame*step*ones(leng,1)];
%  imshow(c,[])
% hold on;
% scatter(cnt(:,1),cnt(:,2),'*','r')
end
%%
param.mem=25;
param.good=0;
param.quiet=0;
param.dim=3;
tr=track(pos,5,param);
% %%
% for step=1:500
% 
% fname = ['group 4 1 um 25 hz fluid 2_', num2str(step,'%05.0f'), '.tif'];
% a = imread(fname);
% imshow(a);
% hold on;
% scatter(tr(9972+step,1),tr(9972+step,2));
% drawnow()
% 
% end

%% only keep trajectoryies of at least 400 out of 500 frames

  A = tr(:,4);
   x = unique(A);
   N = numel(x);
   count = zeros(N,1);
   for k = 1:N
      count(k) = sum(A==x(k));
   end
   traj=nonzeros(x(:).*(count>300));
   temp_tr=tr.*ismember(tr(:,4),traj);
   good_tr=[nonzeros(temp_tr(:,1)) nonzeros(temp_tr(:,2)) nonzeros(temp_tr(:,3)) nonzeros(temp_tr(:,4))];
%%