function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

% Compute features
n = size(X, 2);

% Compute hypothesis
h = sigmoid(X * theta);

s = 0;
for i = 1 : m
   s += -y(i) * log(h(i)) - (1 - y(i)) * log(1 - h(i)); 
end

sumOfTheta = 0;
for j = 2 : n
    sumOfTheta += theta(j) ^ 2;
end

J = s / m + lambda * sumOfTheta / 2 / m;

% Compute partial derivatives

% Compute theta 0
s = 0;
for i = 1 : m
    s += (h(i) - y(i)) * X(i, 1);
end
grad(1) = s / m;

% Compute theta 1 ~ n
for j = 2 : n
    s = 0;
    for i = 1 : m
       s += (h(i) - y(i)) * X(i, j); 
    end
    grad(j) = s / m + lambda * theta(j) / m;
end


% =============================================================

end
