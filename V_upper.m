function [p_value1,p_value0,w1_int,w0_int] = V_upper(compare_frac,v_int1,v_int0,shift_in1,shift_in0,wr_addr,rd_addr, ite_input_count)
    %v_upper = zeros(5);
    %num2str:[] to string, then bin2dec, then minus, then dec2bin;
    v_upper = bin2dec(num2str(v_int1)) - bin2dec(num2str(v_int0)) -compare_frac;
    %v_upper = bin2dec(num2str(v_int1-v_int0))-compare_frac; 
    if(v_upper >=0)
        v_sample=fix(v_upper/4);
    end
    if(v_upper <= -1 && v_upper >=-4) %-1:11111,-2:11110,-3:11101,-4:11100
        v_sample = 7;
    end
    if(v_upper <= -5 && v_upper >=-8) %-5:11011,-6:11010;-7:11001,-8:11000
        v_sample = 6;
    end
    if(v_upper <= -9 && v_upper >=-12)%-9:10111,10110,10101,10100
        v_sample = 5;
    end        
    if(v_upper <= -13 &&v_upper >=-16)%-13:10011, -16:10000
        v_sample = 4;
    end
%     % Since v_upper > 0 ,p=10; v_upper < 0, p =01;
%     if(v_upper <= -17)
%         p_value1 = 0; p_value0 = 1;   
%     end
        
    switch (v_sample)
        case 3% '011'
            p_value1 = 1; p_value0 = 0;
        case 2% '010'
            p_value1 = 1; p_value0 = 0;
        case 1%'001'
            p_value1 = 1; p_value0 = 0;
        case 0% '000'
            p_value1 = 0; p_value0 = 0;
        case 7%'111'
            p_value1 = 0; p_value0 = 0;
        case 6%'110'
            p_value1 = 0; p_value0 = 1;
        case 5%'101'
            p_value1 = 0; p_value0 = 1;
        case 4%'100'
            p_value1 = 0; p_value0 = 1;       
    end
    p1 = zeros(256,1); p0 = zeros(256,1);
    p1(pairing(wr_addr, ite_input_count),1)=p_value1;
    p0(pairing(wr_addr, ite_input_count),1)=p_value0;
    
persistent w_int1;
persistent w_int0;
    if(isempty(w_int1)&& isempty(w_int0))
        w_int1=zeros(256,5);  % 64*4
        w_int0=zeros(256,5);
    end
    if(rd_addr == 0)
        if(bitxor(bitxor(v_int1(2),p_value1),bitxor(v_int0(2),p_value0)))
            w_int1(pairing(wr_addr, ite_input_count),1)=bitxor(v_int1(2),p_value1);
            w_int0(pairing(wr_addr, ite_input_count),1)=bitxor(v_int0(2),p_value0);
            %w_int1(pairing(wr_addr, ite_input_count),(1))=bitxor(v_int1(2),p1(pairing(rd_addr, ite_input_count),1));
            %w_int0(pairing(wr_addr, ite_input_count),(1))=bitxor(v_int0(2),p0(pairing(rd_addr, ite_input_count),1));
        else
            w_int1(pairing(wr_addr, ite_input_count),1)=0;
            w_int0(pairing(wr_addr, ite_input_count),1)=0;
        end
        w_int1(pairing(wr_addr, ite_input_count),2:4) = v_int1(3:5);
        w_int0(pairing(wr_addr, ite_input_count),2:4) = v_int0(3:5);
        w_int1(pairing(wr_addr, ite_input_count),5) = shift_in1;
        w_int0(pairing(wr_addr, ite_input_count),5) = shift_in0;
        w1_int = w_int1(pairing(wr_addr, ite_input_count),:);
        w0_int = w_int0(pairing(wr_addr, ite_input_count),:);
    end
            
end
    
    
%     v_sample = num2str(v_upper(1:3));
%     switch (v_sample)
%         case [0,1,1]
%             p_value1 = 1; p_value0 = 0;
%         case [0,1,0]
%             p_value1 = 1; p_value0 = 0;
%         case [0,0,1]
%             p_value1 = 1; p_value0 = 0;
%         case [0,0,0]
%             p_value1 = 0; p_value0 = 0;
%         case [1,1,1]
%             p_value1 = 0; p_value0 = 0;
%         case [1,1,0]
%             p_value1 = 0; p_value0 = 1;
%         case [1,0,1]
%             p_value1 = 0; p_value0 = 1;
%         case [1,0,0]
%             p_value1 = 0; p_value0 = 1;       
%     end