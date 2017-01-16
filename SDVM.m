% SDVM in Verilog
% Diagonal COMP with (n, k, u)    
function [CAx1_sel, CAx0_sel]=SDVM(y1_value,y0_value, CAx1,CAx0)
unrolling = 8;
%     CAx1=zeros(256,256);  % 64*4
%     CAx0=zeros(256,256);
%     CAy1=zeros(256,256);
%     CAy0=zeros(256,256);
% 	CAx1(pairing(N_depth, ite_input_count),u) = xin1;
% 	CAx0(pairing(N_depth, ite_input_count),u) = xin0;
% 	CAy1(pairing(N_depth, ite_input_count),u) = yin1;
% 	CAy0(pairing(N_depth, ite_input_count),u) = yin0;
% 
%     CAy1_sel=zeros(64);
%     CAy0_sel=zeros(64);
%     CAx1_sel=zeros(64);
%     CAx0_sel=zeros(64);

% Calculation v
%y[j+1]*xj+4
check=y1_value-y0_value;
if check >0
	CAx1_sel = CAx1;  %(:,1:u)
	CAx0_sel = CAx0;
end
if check <0
    CAx1_sel = ~CAx1;  %(:,O:u)
	CAx0_sel = ~CAx0;
end
if check ==0
    CAx1_sel = 0*CAx1;  %(:,O:u)
	CAx0_sel = 0*CAx0;
end
    %x[j]*yj+4

end