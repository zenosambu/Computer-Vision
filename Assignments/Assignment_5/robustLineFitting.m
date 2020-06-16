load('points.mat','x','y');
punti = load('points.mat','x','y');
N = 300;
T = 5;
valfit = zeros(N, 1);
valfitmax = 0;
pairo = [];
for i = 1 : N
    pos1 = randi([1, 130]);
    pos2 = randi([1, 130]);
    while pos1 == pos2
        pos2 = randi([1, 130]);
    end
    ax = x(pos1);
    ay = y(pos1);
    bx = x(pos2);
    by = y(pos2);
    
    m = (by - ay)/(bx - ax);
    q = y(pos1) - m*(x(pos1));
    for j = 1:130
        d(j) = (abs(q+m*x(j)-y(j)))/(sqrt(1+m*m));
        if d(j) <= T
            valfit(i) = valfit(i) + 1; 
            pairo = [pairo; j]; 
        end
    end
    if valfitmax <= valfit(i)
        valfitmax = valfit(i);
        posmax1 = pos1;
        posmax2 = pos2;
        mmax = m;
        qmax = q;
        pairmax = pairo;
    end
    pairo = [];
end

[n,~] = size(pairmax);
sommax = 0;
sommay = 0;
for i = 1:n
    sommax = sommax + x(pairmax(i));
end
for i = 1:n
    sommay = sommay + y(pairmax(i));
end
mediax = sommax/n;
mediay = sommay/n;

U = zeros(n,2);

for j = 1:n
    U(j,1) = x(pairmax(j)) - mediax;
    U(j,2) = y(pairmax(j)) - mediay;
end


U2 = transpose(U)*U;

[V,D] = eig(U2);

if(D(1,1) < D(2,2))
    eig_index = 1;
else
    eig_index = 2;
end

theta = atan(V(2,eig_index)/V(1,eig_index));
r = mediax * V(1,eig_index) + mediay * V(2,eig_index);

MMM = -1/tan(theta); 
BBB = r/sin(theta);

figure;
sksk = linspace(-10, 110);
plot(sksk, sksk*MMM + BBB, 'r');

hold on;



plot(sksk,mmax*sksk+qmax,'b');
hold on;
plot(x,y,'kx');
axis equal