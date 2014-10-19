function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

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
%
% Note: grad should have the same dimensions as theta
%

n = size(X, 2);

iter = 1000;
alpha = 0.03;

for it = 1 : iter

    %fprintf('Iteration: %d \n', it);
    
    h = X * theta;
    fprintf('h = %f \n', h(1:10,:));

    % Compute H
    H = sigmoid(X * theta);
    fprintf('H = %f \n', H(1:10,:));

    % Shink theta
    theta_updated = zeros(size(theta));
    for f = 1 : n
        s = 0;
        for i = 1 : m
            s += (H(i) - y(i)) * X(i, f);
        end
        grad(f) = s / m;

        theta_updated(f) = theta(f) - alpha * grad(f);
    end

    %fprintf('grad = %f \n', grad);
    
    % Compute J
    s = 0;
    for i = 1 : m
        s += -y(i) * log(H(i)) - (1 - y(i)) * log(1 - H(i));
    end
    J = s / m;

    fprintf('s = %f, m = %d, J = %f \n', s, m, J);

    % Update theta simultaneously
    theta = theta_updated;

    fprintf('theta = %f \n', theta);
    pause;

end

% =============================================================

end

