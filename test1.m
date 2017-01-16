%function [N_w,u,addr_w]=test1()
function [N_w,u,addr_w,CAx1,CAx0]=test1(x1,x0)
persistent ite_output_count;     %call function once, ite_output_count add one. FUNCTION as Counter
    if(isempty(ite_output_count))
        ite_output_count=1;
    else
        ite_output_count=ite_output_count+1;
    end

persistent ite_count;
persistent ite_input_count;  
    if(isempty(ite_count))
        ite_count=0;
    end
    if(isempty(ite_input_count))
        ite_input_count=0;
    end
    if ite_output_count == (1 + (ite_count + 1)*ite_count / 2)  % 
		ite_count=ite_count+1;    % Diagonal Count, next one
        ite_input_count = 0;      % Iteration Count  
	else
		ite_input_count = ite_input_count + 1;
    end
	N_w=floor((ite_count-ite_input_count)/64);
	%u = 63 - (ite_count-N_depth*64) + ite_input_count;
    u = (ite_count-N_w*64) - ite_input_count;        %begin from 1 to 64
%CA_register    
    addr_w=pairing(N_w, ite_input_count);
    CAx1=zeros(10,4);  % 64*4
    CAx0=zeros(10,4);
	CAx1(addr_w,u) = x1;
	CAx0(addr_w,u) = x0;
end