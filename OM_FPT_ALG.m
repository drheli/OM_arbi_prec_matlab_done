% Digit-vector: x[P] = x_in(1,2,...,P); y[P] = y_in(1,2,...,P);
% x(j) = x(j)_plus - x(j)_minus; y(j) = y(j)_plus - y(j)_minus 
% if j > delta
% p = p(j-delta)

function [i,x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,CAx_plus,CAx_minus,CAy_plus,CAy_minus,CAx_plus_sel, CAx_minus_sel,CAy_plus_sel, CAy_minus_sel, cout_one_plus, cout_one_minus, cout_two_plus, cout_two_minus, shift_o_plus, shift_o_minus,u_r,wr_n,rd_n,enable,res_enable,compare_frac,v_int_plus, v_int_minus,v_frac_plus, v_frac_minus,w_int_plus,w_int_minus,w_frac_plus, w_frac_minus,p_plus,p_minus,p1_out,p0_out,count] = OM_FPT_ALG(x_in_plus, x_in_minus, y_in_plus, y_in_minus, k)
% initialization step
% time_step: j
unrolling = 8;
persistent j;
if isempty(j)
	j = 0;
end
persistent flag;
persistent p_count;
% BRAM: w_frac
persistent w_plus_wr_frac;
persistent w_minus_wr_frac;
    if(isempty(w_plus_wr_frac)&& isempty(w_minus_wr_frac))
        w_plus_wr_frac=zeros(1024,unrolling);  
        w_minus_wr_frac=zeros(1024,unrolling);
    end
% BRAM: w_int
persistent w_plus_wr_int;
persistent w_minus_wr_int;
    if(isempty(w_plus_wr_int)&& isempty(w_minus_wr_int))
        w_plus_wr_int=zeros(1024,5);  
        w_minus_wr_int=zeros(1024,5);
    end
persistent cin_one_plus; persistent cin_one_minus; persistent cin_two_plus; persistent cin_two_minus;
persistent CAw_frac_plus; persistent CAw_frac_minus;
persistent CAw_plus_int; persistent CAw_minus_int;
persistent p_out_plus; persistent p_out_minus;
persistent p_v_plus; persistent p_v_minus;

x_int_plus=zeros(1,5);
x_int_minus=zeros(1,5);
y_int_plus=zeros(1,5);
y_int_minus=zeros(1,5);

for j = 1:18
        %j = j + 1;

            % recall function digit_comp_OM			
			% State Machine: iterative addition start from N to 0;
			    %[u_r,wr_n,rd_n,enable,add_enable,res_enable,x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev] = FSM_fpt_v2(x_in_plus, x_in_minus, y_in_plus, y_in_minus); 
			    % BRAM to store/write x[j] & y[j], generate/read x[j-1], y[j];
		x_plus_rev = x_in_plus(j);
        x_minus_rev = x_in_minus(j);
        y_plus_rev = y_in_plus(j);
        y_minus_rev = y_in_minus(j);
        enable = 1; % only valid when a new digit valid
        res_enable = 1;
        wr_n = ceil(j/unrolling) - 1; rd_n = ceil(j/unrolling)-1;
        if mod (j,unrolling)==0
            u_r = unrolling;
        else
            u_r = mod (j,unrolling);
        end
        %[CAx_plus,CAx_minus,CAy_plus,CAy_minus] = CA_gen(x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,wr_n,rd_n,u_r,k,enable);        
        
        for i = (ceil(j/unrolling)-1):-1:0
            if i == (ceil(j/unrolling)-1)
                enable = 1;
            else
                enable = 0;
            end
                % enable =1, write/read new digit, enable =0, read other chunk digits 
                [CAx_plus,CAx_minus,CAy_plus,CAy_minus] = CA_gen(x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,i,i,u_r,k,enable);        
			    % Algorithm: CAx_sel = x[j]*y(j); CAy_sel = y[j+1]*x(j) 
			    [CAx_plus_sel, CAx_minus_sel]=SDVM(y_plus_rev,y_minus_rev,CAx_plus,CAx_minus);
			    [CAy_plus_sel, CAy_minus_sel]=SDVM(x_plus_rev,x_minus_rev,CAy_plus,CAy_minus);
                
                if isempty(flag)
                    cin_one_plus = 0; cin_one_minus = 0; cin_two_plus = 0; cin_two_minus = 0; CAw_frac_plus=zeros(1,unrolling); CAw_frac_minus=zeros(1,unrolling);
                    p_out_plus = zeros(1,4*unrolling); p_out_minus = zeros(1,4*unrolling); 
                    flag = 0;p_count = 0;
                end
                    % BRAM: w_frac read
                    % Algorithm: 2*w_frac[j-1]
                CAw_frac_plus = w_plus_wr_frac(pairing(i,k),:);
                CAw_frac_minus = w_minus_wr_frac(pairing(i,k),:);
			    % [6:2] iterative adder 
			    [v_frac_plus, v_frac_minus, cout_one_plus, cout_one_minus, cout_two_plus, cout_two_minus, compare_frac] = paralleladder(CAx_plus_sel,CAx_minus_sel,CAy_plus_sel,CAy_minus_sel,CAw_frac_plus,CAw_frac_minus,cin_one_plus,cin_one_minus,cin_two_plus,cin_two_minus);
                
                
                % adder_control only valid when n>1; so cin_one & cin_two also need BRAM
                % adder_control
                if i>=1  % n > 0
                    cin_one_plus = cout_one_plus;  
                    cin_one_minus = cout_one_minus;
                    cin_two_plus = cout_two_plus;
                    cin_two_minus = cout_two_minus;
                else
                    cin_one_plus = 0;
                    cin_one_minus = 0;
                    cin_two_plus = 0;
                    cin_two_minus = 0;
                end
                 % Algorithm: 2*w_frac[j]; % BRAM_frac write: 
                [w_frac_plus, w_frac_minus, shift_o_plus, shift_o_minus] = V_frac(v_frac_plus,v_frac_minus,rd_n,wr_n,k,res_enable);   
                %CAw_frac_plus = w_frac_plus;
                %CAw_frac_minus = w_frac_minus;
                w_plus_wr_frac(pairing(i,k),:)=w_frac_plus;
                w_minus_wr_frac(pairing(i,k),:)=w_frac_minus;
                
            if i == 0
                % MSD adder
                % BRAM: w_int read
                % Algorithm: w_int[j-1]
                CAw_plus_int=w_plus_wr_int(pairing(i,k),:);
                CAw_minus_int=w_minus_wr_int(pairing(i,k),:);              
                [v_int_plus, v_int_minus, ~, ~, ~, ~,~] = paralleladder_int(x_int_plus,x_int_minus,y_int_plus,y_int_minus,CAw_plus_int,CAw_minus_int,cout_one_plus,cout_one_minus, cout_two_plus, cout_two_minus);             
                % p = SELM(vj)
                %[p_v_plus,p_v_minus,w_int_plus,w_int_minus] = V_upper(compare_frac,v_int_plus,v_int_minus,shift_o_plus,shift_o_minus,wr_n,rd_n, k);
                [p_v_plus,p_v_minus,w_int_plus,w_int_minus] = V_upper(compare_frac,v_int_plus,v_int_minus,shift_o_plus,shift_o_minus,i,i, k);
                p_count = p_count +1;
                % BRAM_int write
                w_plus_wr_int(pairing(i,k),:)=w_int_plus;
                w_minus_wr_int(pairing(i,k),:)=w_int_minus;
            else
                w_int_plus = 0;                
                w_int_minus = 0;
            end
        end
                
                flag = flag + 1;
                count = flag;
%                 p_out_plus(1,p_count)=p_v_plus;
%                 p_out_minus(1,p_count)=p_v_minus;
%                 p_plus=p_v_plus;
%                 p_minus=p_v_minus;
%                 p1_out=p_out_plus;
%                 p0_out=p_out_minus;
                p_out_plus(1,j)=p_v_plus;
                p_out_minus(1,j)=p_v_minus;
                p_plus=p_v_plus;
                p_minus=p_v_minus;
                p1_out=p_out_plus;
                p0_out=p_out_minus;

end
    %end
end
			

