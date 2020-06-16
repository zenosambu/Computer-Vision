function [m,loc]=maxinterp(v)

a=0.5*v(1)-v(2)+0.5*v(3);
b=-0.5*v(1)+0.5*v(3);
c=v(2);

loc=-b/2/a;

m=[a b c]*[loc^2 loc 1]';

