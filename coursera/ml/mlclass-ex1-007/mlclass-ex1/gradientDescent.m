function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
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
    %       of the cost function (computeCost) and gradient here.
    %

	s1 = 0; s2 = 0;
	for i = 1 : m
		h = theta(1) + theta(2) * X(i, 2);
		d = h - y(i);

		s1 += d;
		s2 += d * X(i, 2);
	end
	theta(1) -= alpha * s1 / m;
	theta(2) -= alpha * s2 / m;

	% fprintf('it=%d, theta1=%f, theta2=%f \n', iter, theta(1), theta(2));

    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta);

end

end
