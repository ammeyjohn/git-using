
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
