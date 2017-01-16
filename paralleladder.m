% Parallel adder module with three inputs in signed representation
function [res1, res0, cout_one1, cout_one0, cout_two1, cout_two0,compare]=paralleladder(x1,x0,y1,y0,w1,w0,cin_one1,cin_one0,cin_two1,cin_two0)
    %res1=zeros(64); res0=zeros(64); 
    %z1_temp=zeros(64);z0_temp=zeros(64);
    
    [z1_temp,z0_temp,cout_one1,cout_one0] = fourbitadder(x1, x0, y1, y0, cin_one1, cin_one0);
    [res1,res0,cout_two1,cout_two0] = fourbitadder(z1_temp, z0_temp, w1, w0, cin_two1, cin_two0);
    
    if bin2dec(num2str(res1)) >= bin2dec(num2str(res0))
        compare = 0;
    else
        compare = 1;
    end
end
    
%add_control link cin12 and cout12




