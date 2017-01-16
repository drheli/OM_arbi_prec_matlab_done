function [w1, w0, shift_o1, shift_o0] = V_frac(res1,res0,rd_addr,wr_addr,ite_input_count,res_enable)     %V_frac1, V_frac2;
unrolling = 8;
%persistent shift_out1;
%persistent shift_out0;
persistent residue1;
persistent residue0;
    if(isempty(residue1)&& isempty(residue0))
        residue1=zeros(256,unrolling);  % 64*4
        residue0=zeros(256,unrolling);
    end
%residue1 = zeros(256, 16); residue0 = zeros(256, 16);
persistent shift_out1;
persistent shift_out0;
    if(isempty(shift_out1)&& isempty(shift_out0))
        %shift_out1=zeros(256,1);  % 64*4
        %shift_out0=zeros(256,1);
        shift_out1=0;  % 64*4
        shift_out0=0;
    end
%shift_out1 = zeros(256,1); shift_out0 = zeros(256,1);
%shift_o1 = zeros(256,1); shift_o0 = zeros(256,1);
if (res_enable) 
	if (wr_addr == 0) 
        %first read, then write
        %w1 = residue1(pairing(rd_addr, ite_input_count),:);
		%w0 = residue0(pairing(rd_addr, ite_input_count),:);
		shift_in1 = 0;
        shift_in0 = 0;
        %w1 = zeros(64); w0 = zeros(64);
		residue1(pairing(wr_addr, ite_input_count),1:unrolling-1) = res1(2:unrolling);
        residue1(pairing(wr_addr, ite_input_count),unrolling) = shift_in1;
		residue0(pairing(wr_addr, ite_input_count),1:unrolling-1) = res0(2:unrolling);
        residue0(pairing(wr_addr, ite_input_count),unrolling) = shift_in0;
        w1 = residue1(pairing(rd_addr, ite_input_count),:);
		w0 = residue0(pairing(rd_addr, ite_input_count),:);
		%shift_out1(pairing(wr_addr, ite_input_count),:) = res1(1); 
        %shift_out0(pairing(wr_addr, ite_input_count),:) = res0(1);
        shift_out1 = res1(1); 
        shift_out0 = res0(1);
    else
        %first read, then write
        %w1 = residue1(pairing(rd_addr, ite_input_count),:);
		%w0 = residue0(pairing(rd_addr, ite_input_count),:);
        %shift_in1 = shift_out1(pairing(rd_addr, ite_input_count),:); 
        %shift_in0 = shift_out0(pairing(rd_addr, ite_input_count),:); 
        shift_in1 = shift_out1; 
        shift_in0 = shift_out0; 
		residue1(pairing(wr_addr, ite_input_count),1:unrolling-1) = res1(2:unrolling);
        residue1(pairing(wr_addr, ite_input_count),unrolling) = shift_in1;
		residue0(pairing(wr_addr, ite_input_count),1:unrolling-1) = res0(2:unrolling);
        residue0(pairing(wr_addr, ite_input_count),unrolling) = shift_in0;
 		w1 = residue1(pairing(rd_addr, ite_input_count),:);
 		w0 = residue0(pairing(rd_addr, ite_input_count),:);
		%shift_out1(pairing(wr_addr, ite_input_count),:) = res1(1); 
        %shift_out0(pairing(wr_addr, ite_input_count),:) = res0(1);
        shift_out1 = res1(1); 
        shift_out0 = res0(1);
    end
end
    %shift_o1(pairing(wr_addr, ite_input_count),:) = res1(64);  %Not need RAM
    %shift_o0(pairing(wr_addr, ite_input_count),:) = res0(64);
    shift_o1 = res1(1);  %Not need RAM
    shift_o0 = res0(1);
end
           

%w_addr rd_addr?????? need a control unit!!!```