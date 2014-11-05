function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% fprintf('Number of labels = %d \n', num_labels);

% unroll vector y
Y = zeros(m, num_labels);
for i = 1 : m
    l = y(i);
    Y(i, l) = 1;
end

% Add x0 = 1 to matrix X
a1 = [ones(m, 1), X];

% Compute hypothesis
z2 = Theta1 * a1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2'];

z3 = Theta2 * a2';
a3 = sigmoid(z3);

h = a3';

% Compute cost function
s = 0;
for i = 1 : m
    for k = 1 : num_labels
        s += -Y(i, k) * log(h(i, k)) - (1 - Y(i, k)) * log(1 - h(i, k));
    end
end
J = s / m;

% fprintf('J = %f \n', J);

if lambda != 0

    % Compute regularized cost function

    % Theta1
    s1 = 0;
    for j = 1 : hidden_layer_size
        for k = 2 : input_layer_size + 1
            s1 += Theta1(j, k) ^ 2;  
        end
    end

    % Theta2
    s2 = 0;
    for j = 1 : num_labels 
        for k = 2 : hidden_layer_size + 1
            s2 += Theta2(j, k) ^ 2;  
        end
    end

    J += lambda * (s1 + s2) / 2 / m;

    % fprintf('regularized J = %f \n', J);

end

% Implement backpropagation

% sigma3
sigma3 = a3' - Y;

% sigma2
g = [ones(m, 1) sigmoidGradient(z2)'];
sigma2 = (Theta2' * sigma3')' .* g;

% delta
Theta2_grad = (Theta2_grad + sigma3' * a2) ./ m;

grad1 = sigma2' * a1;
grad1 = grad1(2:end,:);
Theta1_grad = (Theta1_grad + grad1) ./ m;

% Regularized gradient

% Theta1
s1 = 0;
for j = 1 : hidden_layer_size
    for k = 2 : input_layer_size + 1
        s1 += Theta1(j, k);  
    end
end
s1 = lambd

% Theta2
s2 = 0;
for j = 1 : num_labels 
    for k = 2 : hidden_layer_size + 1
        s2 += Theta2(j, k) ^ 2;  
    end
end


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
