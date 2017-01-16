%online_ADD contain two FA in P506
%cout: hj+2;
%temp: ~gj+3;
%carry_out:tj+2 = z^-_j+2;
%sum: z^+_j+3;
%function [cout, carry_out, sum]=online_ADD(x1, x0, y1, y0, cin)
function [cout,carry_out, sum]=online_ADD(x1, x0, y1, y0, cin)
	%FA1 {cout,temp} = x1-x0+y1;
	temp = mod((x1 + (~x0) + y1),2);    %sum
	cout = fix((x1 + (~x0) + y1) / 2);  %carry
    
    %next all/cycle
	%FA2 {sum, carry_out} = temp-y0+cin;
	carry_out = fix((temp + (~y0) + cin) / 2);  %carry
	sum = mod((temp + (~y0) + cin),2);   %sum
end