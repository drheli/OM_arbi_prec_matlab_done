function [CAx1,CAx0,ite_input_r,N_r,u_r,x_o1,x_o0]=digitreuse(operand1,operand0,x1,x0)
%function [test1,test_r,test3,ite_input_r,u_r,CAx1,CAx0,N_w,N_r,addr_w,addr_r,x_o1,x_o0]=digitreuse(operand1,operand0,x1,x0)
%function [test1,test_r,test3,test4,u_r,CAx1,CAx0,N_w,N_r,addr_w,addr_r,x_o1,x_o0]=digitreuse(operand1,operand0,x1,x0)
% 1  2  |3  4  5  |6  7  8  9  10 |11 12 13 14 15 16 17 |18 19 20 21 22 23 24 25 26 |27 28  
% x01x02|x03x11x12|x04x21x13   x22|x05x31x14   x23   x32|x06x41x15   x24   x33   x42|x07x51
%       |x11x12   |x21x13   x22   |x31x14   x23   x32   |x41x15   x24   x33   x42   |x51x16 
%        1  2      3  4     5      6   7     8     9     10  11
% 1  2  |3  4  5  |6  7  8  9  10 |11 12 13 14 15 16 17 |18 19 20 21 22 23 24 25 26 |27 28  
% x01x02|x03x11x12|x04   x13x21x22|x05   x14   x23x31x32|x06   x15   x24   x33x41x42|x07
%       |x11x12   |x21x13   x22   |x31x14   x23   x32   |x41x15   x24   x33   x42   |x51x16 

%Write Step
%diagnal write
% persistent ite_output_count;     %call function once, ite_output_count add one. FUNCTION as Counter
%     if(isempty(ite_output_count))
%         ite_output_count=1;
%     else
%         ite_output_count=ite_output_count+1;
%     end

persistent ite_output_count;     %call function once, ite_output_count add one. FUNCTION as Counter
    if(isempty(ite_output_count))
        ite_output_count=0;
    end
    
persistent ite_count;
persistent ite_input_count;  
    if(isempty(ite_count))
        ite_count=0;
    end
    if(isempty(ite_input_count))
        ite_input_count=0;
    end
persistent CA_x1;
persistent CA_x0;
    if(isempty(CA_x1)||isempty(CA_x0))
        CA_x1=zeros(16,16);  % 64*4
        CA_x0=zeros(16,16);
    end
    
%if(x0 ~=0 || x1~=0)
    ite_output_count=ite_output_count+1;
    
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
	CA_x1(addr_w,u) = x1;
	CA_x0(addr_w,u) = x0;
%     CAx_0 = CA_x0;
%     CAx0 = CAx_0;
%end
    CAx1 = CA_x1;
    CAx0 = CA_x0;
    
% Read Step
persistent ite_output_count_r;
    if(isempty(ite_output_count_r))
        ite_output_count_r=1;    %=3
    else 
        ite_output_count_r=ite_output_count_r+1;
    end
persistent ite_count_r;
persistent ite_input_count_r;  
    if(isempty(ite_count_r))
        ite_count_r=0;
    end
    if(isempty(ite_input_count_r))
        ite_input_count_r=0;
    end
% the first two digits x01, x02 to generate x11
persistent ori;
    if(isempty(ori))
        ori=0;
    end
%     if((ite_output_count_r==1))
%         ori=ori+1;             %shift of original input
%         x_o1=operand1(ori);
%         x_o0=operand0(ori);
%     end
%     if((ite_output_count_r==2))
%         ori=ori+1;
%         x_o1=operand1(ori);
%         x_o0=operand0(ori);
%     end
% 1  2  |3  4  5  |6     7  8  9  |10    11    12 13 14 |15    16    17    18 19 20 |21   
% 1  2  |3  4  5  |6  7  8  9  10 |11 12 13 14 15 16 17 |18 19 20 21 22 23 24 25 26 |27 28  
% x01x02|x03x11x12|x04   x13x21x22|x05   x14   x23x31x32|x06   x15   x24   x33x41x42|x07
%       |x11x12   |x21x13   x22   |x31x14   x23   x32   |x41x15   x24   x33   x42   |x51x16   
%        1  2      3  4     5      6   7     8     9     10  11

% 1  2  |3  4  5  |6  7  8  9  10 |11 12 13 14 15 16 17 |18 19 20 21 22 23 24 25 26 |27 28  
% x01x02|x03x11x12|x04x21x13   x22|x05x31x14   x23   x32|x06x41x15   x24   x33   x42|x07x51
%       |x11x12   |x21x13   x22   |x31x14   x23   x32   |x41x15   x24   x33   x42   |x51x16  
%        1  2      3  4     5      6   7     8     9     10  11

%     if(ite_output_count_r==(ite_count_r+1)*(ite_count_r+1) + 2)   % clock: k^2+2 assign Orign data
%         ori=ori+1;
%         x_o1=operand1(ori);
%         x_o0=operand0(ori);
%         ite_count_r = ite_count_r + 1;     % next cycle input x11->x21->x31->x41...
%         ite_input_count_r = 0;
%     else
%         ite_input_count_r = ite_input_count_r + 1;
%     end
    N_r=0;
    u_r=0;
    addr_r=0;
%     if(ite_output_count_r==0)   %online delay =3, so wait for 3rd input generate 1st output
%         ori=ori+1;
%         x_o1=operand1(ori);
%         x_o0=operand0(ori);
%     else

    if(ite_output_count_r==(ite_count_r)*(ite_count_r+1)/2 + 1)  % No.1,2,4,7,11 == x_ori
        ori=ori+1;
        x_o1=operand1(ori);
        x_o0=operand0(ori);
        ite_count_r = ite_count_r + 1;     % next cycle input x11->x21->x31->x41...
    %end
    %begin from 3, ite_count always larger 1 than normal.
    else if(ite_output_count_r==ite_count_r*(ite_count_r-1)/2 + 2)  %No.3,5,8,12 = x11,x12,x13.x14
        %ite_count_r = ite_count_r + 1;    
        ite_input_count_r = 1;    % not 0, coz ite_count always larger 1 than normal
        
        N_r=floor((ite_count_r-ite_input_count_r)/64);
        %u = 63 - (ite_count-N_depth*64) + ite_input_count;
        u_r = (ite_count_r-N_r*64) - ite_input_count_r;       
        %begin from 1 to 64, ite_count always larger 1 than normal.      
%CA_register    
        addr_r=pairing(N_r, (ite_input_count_r -1));
        x_o1 = CA_x1(addr_r,u_r);  %global 
        x_o0 = CA_x0(addr_r,u_r);  %global
        else if(ite_output_count_r ~=(ite_count_r)*(ite_count_r-1)/2 + 1)  %Ori line invalid
            ite_input_count_r = ite_input_count_r + 1;
            N_r=floor((ite_count_r-ite_input_count_r)/64);
             %u = 63 - (ite_count-N_depth*64) + ite_input_count;
            u_r = (ite_count_r-N_r*64) - ite_input_count_r;       
            %begin from 1 to 64, ite_count always larger 1 than normal.
        
        %CA_register    
            addr_r=pairing(N_r, (ite_input_count_r -1));
            x_o1 = CA_x1(addr_r,u_r);  %global 
            x_o0 = CA_x0(addr_r,u_r);  %global
            end
        end
    end
     
%          test1=ite_output_count;
%          test_r=ite_output_count_r;
%          test3=ite_count_r;
         ite_input_r=ite_input_count_r;
end
    

    
