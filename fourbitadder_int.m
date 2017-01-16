%[4-2] ADD
function [z1,z0,cout1,cout0] = fourbitadder_int(x1, x0, y1, y0, cin1, cin0)
	%cin_vec=zeros(5); cout_vec=zeros(5); carry=zeros(5); sum=zeros(5);
    z1=zeros(1,5); z0=zeros(1,5);
    z0(5) = cin0;             %Original t_j+3 = Z_j+3_minus
    cin_vec(5) = cin1;            %hj+3
%64-bit parallel online adder
	for i=5:-1:1
		[cout_vec(i), carry(i), sum(i)] = online_ADD(x1(i), x0(i), y1(i), y0(i), cin_vec(i));
        if(i>1)
            cin_vec(i-1)=cout_vec(i);
            z0(i-1)=~carry(i);
        end
        if(i==1)
            cout1 = cout_vec(i); 
            cout0 = ~carry(i);
        end
        z1(i)=sum(i);
    end
end

%online_ADD contain two FA
function [cout, carry_out, sum]=online_ADD(x1, x0, y1, y0, cin)
	%FA1 {cout,temp} = x1-x0+y1;
	temp = mod((x1 + (~x0) + y1),2);
	cout = fix((x1 + (~x0) + y1) / 2);
	%FA2 {sum, carry_out} = temp-y0+cin;
	carry_out = fix((temp + (~y0) + cin) / 2);
	sum = mod((temp + (~y0) + cin),2);
end