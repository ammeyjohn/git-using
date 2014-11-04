function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %

    % Get feature count
    n = size(X, 2);

    % To temperary store the new theta values
    tt = zeros(n, 1);

    for f = 1 : n
        s = 0;
        for i = 1 : m
            h = computeHypothesis(X(i,:), theta, m, n);
            d = h - y(i);
            s += d * X(i,f);
        end
        tt(f) = theta(f) - alpha * s / m;
    end

    theta = tt;

    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCostMulti(X, y, theta);

end

end


function h = computeHypothesis(rx, theta, m, n)
    
    h = 0;
    for f = 1 : n
        h += theta(f) * rx(f);
    end 

end
