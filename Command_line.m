% arbitrary OA command
a = [1,1,0,0,1,0,0,1];
b = [0,0,0,1,0,0,1,0];
c = [1,0,1,0,0,1,1,0];
d = [0,0,0,1,1,0,0,0];
e=zeros(1,256);
x1=[a,e];
x0=[b,e];
y1=[c,e];
y0=[d,e];

[i,x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,CAx_plus,CAx_minus,CAy_plus,CAy_minus,CAx_plus_sel, CAx_minus_sel,CAy_plus_sel, CAy_minus_sel, cout_one_plus, cout_one_minus, cout_two_plus, cout_two_minus, shift_o_plus, shift_o_minus,u_r,wr_n,rd_n,enable,res_enable,compare_frac,v_int_plus, v_int_minus,v_frac_plus, v_frac_minus,w_int_plus,w_int_minus,w_frac_plus, w_frac_minus,p_plus,p_minus,p1_out,p0_out,count] = OM_FPT_ALG(x1, x0, y1, y0, 1);

% Traditional OA command
% data input
a = [1,1,0,0,1,0,0,1,1,1,0,0,1];
b = [0,0,0,1,0,0,1,0,0,0,1,1,0];
c = [1,0,1,0,0,1,1,0,1,1,1,1,1];
d = [0,0,0,1,1,0,0,0,1,1,1,1,1];
e=zeros(1,256);
x1=[a,e];
x0=[b,e];
y1=[c,e];
y0=[d,e];
[call,v_int1, v_int0,v_frac1, v_frac0,wt1,wt0,wc1,wc0,w_int1,w_int0,w_frac1, w_frac0, shift_o1, shift_o0, cout_one1, cout_one0, cout_two1, cout_two0,compare_frac,CAx1_sel, CAx0_sel,CAy1_sel, CAy0_sel,CAx1,CAx0,CAy1,CAy0,u_r,wr_addr,rd_addr,enable,add_enable,res_enable,x1_value,x0_value,y1_value,y0_value,p_value1,p_value0,p1_out,p0_out]=digit_comp_OM_vector_(x1,x0,y1,y0,0,0)