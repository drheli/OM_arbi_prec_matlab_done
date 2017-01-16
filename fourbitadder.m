%[4-2] ADD
%Verilog [7:0], Matlab [1:8]
function [z1,z0,cout1,cout0] = fourbitadder(x1, x0, y1, y0, cin1, cin0)
unrolling = 8;
	%cin_vec=zeros(16); cout_vec=zeros(16); carry=zeros(16); sum=zeros(16);
    z1=zeros(1,unrolling); z0=zeros(1,unrolling);
    z0(unrolling) = cin0;             %Original t_j+3 = Z_j+3_minus
    cin_vec(unrolling) = cin1;            %hj+3
%64-bit parallel online adder
% 	for i=1:16 
% 		[cout_vec(i), carry(i), sum(i)] = online_ADD(x1(i), x0(i), y1(i), y0(i), cin_vec(i));
%         z1(i)=sum(i);            %w
%         if i<=15
%             z0(i+1)=~carry(i);      %t
%             cin_vec(i+1)=cout_vec(i);   %h
%         else
%             cout1 = cout_vec(i);     %hj P506<digital arithmetic>
%             cout0 = ~carry(i);       %tj
%         end
%     end

	for i=unrolling:-1:1
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
%     for i=1:8
%         z1(i)=sum(i);            %w
%     end
%     for i=1:7
%         z0(i+1)=~carry(i);      %t
%         %cin_vec(i+1)=cout_vec(i);   %h
%     end
%         cout1 = cout_vec(8);     %hj P506<digital arithmetic>
%         cout0 = ~carry(8);       %tj
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