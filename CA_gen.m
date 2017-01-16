%when call =j
%CAx1,CAx0 first read then write because x[j] will be used
%CAy1,CAy0 first write then read because y[j+1] will be used

function [CAx1,CAx0,CAy1,CAy0] = CA_gen(x1,x0,y1,y0,wr_addr,rd_addr,u_r,ite_input_r,enable)%,refresh)
unrolling = 8;
% persistent ite_output_count;     %call function once, ite_output_count add one. FUNCTION as Counter
%     if(isempty(ite_output_count))
%         ite_output_count=1;
%     else
%         ite_output_count=ite_output_count+1;
%     end
% 
% persistent ite_count;
% persistent ite_input_count;  
%     if(isempty(ite_count))
%         ite_count=0;
%     end
%     if(isempty(ite_input_count))
%         ite_input_count=0;
%     end
%     if ite_output_count == (1 + (ite_count + 1)*ite_count / 2)  % 
% 		ite_count=ite_count+1;    % Diagonal Count, next one
%         ite_input_count = 0;      % Iteration Count  
% 	else
% 		ite_input_count = ite_input_count + 1;
%     end
% 	N_w=floor((ite_count-ite_input_count)/64);
% 	%u = 63 - (ite_count-N_depth*64) + ite_input_count;
%     u_w = (ite_count-N_w*64) - ite_input_count;        %begin from 1 to 64
% %CA_register    

persistent CA_x1;
persistent CA_x0;
% persistent CA_x1_sel;
% persistent CA_x0_sel;
    if(isempty(CA_x1)&&isempty(CA_x0))
        CA_x1=zeros(256,unrolling);  % 64*4
        CA_x0=zeros(256,unrolling);
%         CA_x1_sel=zeros(256,17);  
%         CA_x0_sel=zeros(256,17);
    end
persistent CA_y1;
persistent CA_y0;
    if(isempty(CA_y1)&& isempty(CA_y0))
        CA_y1=zeros(256,unrolling);  % 64*4
        CA_y0=zeros(256,unrolling);
    end
    if(enable == 1)
% refresh is not needed in our function coz every time we take a nre digit
% for computation.this case can be considered as "always refresh"
        %if(redresh==1 && rd_addr==0)    
% x, this step can be easily implemented with "Register", but in Matlab, it can be implemented as below  
% x,first read, then write.      
            addr_r=pairing(rd_addr,ite_input_r);
            CAx1 = CA_x1(addr_r,1:unrolling);
            CAx0 = CA_x0(addr_r,1:unrolling);
            addr_w=pairing(wr_addr, ite_input_r);
            CA_x1(addr_w,u_r) = x1;    %x[j+1]=>x[j]; initial x1=0,x2=xin1;
            CA_x0(addr_w,u_r) = x0;      
            CA_y1(addr_w,u_r) = y1;    %y[j+1];
            CA_y0(addr_w,u_r) = y0;
        %y,first write, then read    
            CAy1 = CA_y1(addr_r,1:unrolling);
            CAy0 = CA_y0(addr_r,1:unrolling);

    else
            addr_r=pairing(rd_addr,ite_input_r);
            CAx1 = CA_x1(addr_r,1:unrolling);
            CAx0 = CA_x0(addr_r,1:unrolling);
            CAy1 = CA_y1(addr_r,1:unrolling);
            CAy0 = CA_y0(addr_r,1:unrolling);
    end
        
%     %x[j+1]=>x[j]; initial x1=0,x2=xin1; only n =0;
%     if(enable==1)
%         if(u_r==1)
%             CAx1 = zeros(1,16);
%             CAx0 = zeros(1,16);
%         else
%             CAx1(1:(u_r-1)) = CAx1_rev(1:(u_r-1)); 
%             CAx1(u_r:16) = zeros(1,(16-u_r+1));
%             CAx0(1:(u_r-1)) = CAx0_rev(1:(u_r-1));
%             CAx0(u_r:16) = zeros(1,(16-u_r+1));
%         end
%     end
end
        
            
