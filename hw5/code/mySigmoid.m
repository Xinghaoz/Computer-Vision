function result = mySigmoid(z)
  result = zeros(size(z));

  result = 1.0 ./ ( 1.0 + exp(-z)); % For Matlab

end
