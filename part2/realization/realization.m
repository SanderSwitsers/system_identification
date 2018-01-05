Y = hankel(1:10,10:19);
[A, C] = HankToSys(Y)
Y = hankel([0 4 6 2 3 3 9 0 4 6 2 3 3 9 0 4 6 2 3 3 9],[9 0 4 6 2 3 3 9 0 4 6 2 3 3 9 0 4 6 2 3 3]);
[A, C] = HankToSys(Y)
X = transpose(sym('X',[1 7]));
eqns = [C*X == 0, C*A*X == 4, C*A^2*X == 6, C*A^3*X == 2, C*A^4*X == 3, C*A^5*X == 3, C*A^6*X == 9];
sol = solve(eqns,X);
x_0 = [sol.X1,sol.X2,sol.X3,sol.X4,sol.X5,sol.X6,sol.X7];
x_0 = transpose(double(x_0));
y_1000 = C*A^999*x_0