% Pairing Function
function addr = pairing(N_depth, ite_input_count)
	addr = (N_depth + (ite_input_count + 1))*(N_depth + (ite_input_count + 1) + 1) / 2 + ite_input_count + 1;  %K=iter+1 [1, ...], N=[0,...]
end