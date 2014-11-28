
% Load X, y, Xval, yval
load('ex6data3.mat');

% Try different SVM Parameters here
[C, sigma] = dataset3Params(X, y, Xval, yval);

fprintf('C = %f, sigma = %f \n', C, sigma);
