function [u_r,wr_v_n,rd_n,enable,add_enable,res_enable,x_v_plus,x_v_minus,y_v_plus,y_v_minus] = FSM_fpt(x_in_plus, x_in_minus, y_in_plus, y_in_minus)
IDLE=0;
COMP=1;
REST=2;
unrolling = 8;
delta = 3;
persistent accum;
accum = 0;
persistent x_plus;
persistent x_minus;
persistent y_plus;
persistent y_minus;
persistent wr_n;
persistent state;
if isempty(state)
    state = IDLE;
end
persistent count;
if isempty(count)
    count = 0;
end

% in software, state can only be the current state
        if (count >= unrolling + delta)  % 64+3=67
            state = COMP;
        end
            
switch (state)
    % if (N = floor(P/U) == 0)
    case IDLE
%         if (count >= unrolling + delta)  % 64+3=67
%             state = COMP;
%             accum = accum + 1;
%             wr_n = 1;
%             count = 1;      % at 68th, start x[j][n=1][1:unrolling]
%         else
            count = count + 1;   % begin the current digit, not like the Verilog
            if (count > unrolling) && (count < unrolling + delta)
            	x_plus = 0;
                x_minus = 0;
                y_plus = 0;
                y_minus = 0;
            else
                x_plus = x_in_plus(count);
                x_minus = x_in_minus(count);
                y_plus = y_in_plus(count);
                y_minus = y_in_minus(count);
            end
            wr_n = 0;
        %end
        if(count >= unrolling + delta -1)
            refresh = 1;
        else
            refresh = 0;
        end
        
    case COMP        
        %state = REST; put it in the last line in software
        % the start condition of n =1
        if (count == unrolling + delta)  % 64+3=67
            accum = accum + 1;
            wr_n = 1;
            count = 0;      % at 68th, start x[j][n=1][1:unrolling]
        else
            wr_n = accum;
        end
        count = count + 1;
        x_plus = x_in_plus(count );
        x_minus = x_in_minus(count);
        y_plus = y_in_plus(count);
        y_minus = y_in_minus(count);
        if count >= unrolling
            accum = accum + 1;
            count = 1;      % next cycle begin n= n+1;
            refresh = 1;
        else
            refresh = 0;
        end
        %wr_n = wr_n - 1;
    case REST
        %count = count + 1;
        if wr_n ==0
            wr_n = accum;
        else 
            wr_n = wr_n -1;
        end
end
u_r=count;     
x_v_plus = x_plus;
x_v_minus = x_minus;
y_v_plus = y_plus;
y_v_minus = y_minus;
wr_v_n = wr_n;
switch (state)
    case IDLE
        add_enable = 0;
        enable = 1;
%         if(refresh == 1)
%              rd_n = 1;
%         else
%              rd_n = 0;
%         end
        rd_n = 0;
        res_enable = 1;
    case COMP
        add_enable = 1;
        enable = 1;
        %rd_n = wr_n - 1;
        rd_n = wr_n;
        res_enable = 1;
        state = REST;
    case REST
        enable = 0;
        res_enable = 1;
        if(wr_n == 0)
% during the iterative add, the carry should be enabled. NOT when iterative add is finished
            add_enable = 0;
            %add_enable = 1;
            if refresh == 1 
                rd_n = accum;
            else
                rd_n = accum;
            end
        else
            add_enable = 1;
            rd_n = accum - 1;
        end  
end
        
    