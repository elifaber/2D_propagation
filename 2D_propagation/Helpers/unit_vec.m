function fin = unit_vec(start,endp)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    tan = endp-start;
    fin = tan./norm(tan);
end