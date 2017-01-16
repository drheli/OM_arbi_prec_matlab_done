function [cin_one1,cin_one0,cin_two1,cin_two0]=adder_control(add_enable,cout_one1,cout_one0,cout_two1,cout_two0)
if add_enable==1
    cin_one1 = cout_one1;
    cin_one0 = cout_one0;
    cin_two1 = cout_two1;
    cin_two0 = cout_two0;
else
    cin_one1 = 0;
    cin_one0 = 0;
    cin_two1 = 0;
    cin_two0 = 0;
end
end