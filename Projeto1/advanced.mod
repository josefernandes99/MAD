set O;		# operations
set P;		# products
set C;		# planets
param T;	# periods

param r{o in O, p in P};	# production rates (inverse)
param v{c in C, p in P, t in 1..T};	# sales prices per country/product/period
param S;        # shuttles' capacity
param h;	# unit inventory cost per period

var s{p in P, t in 0..T} >= 0;	# inventory
var z{p in P, t in 1..T} >= 0;	# production
var x{c in C, p in P, t in 1..T} >= 0;	# delivery for country c, period t

maximize profit: sum {c in C, p in P, t in 1..T} x[c,p,t]*v[c,p,t] - sum {p in P, t in 1..T} h*s[p,t];

Occupation {o in O, t in 1..T}:
  sum {p in P} z[p,t]/r[o,p] <= 1;

BOM {p in P, t in 1..T}:
  z[p,t] + s[p,t-1] = (sum {c in C} x[c,p,t]) + s[p,t];

Delivery {c in C, t in 1..T}:
  sum {p in P} x[c,p,t] <= S;

Inits {p in P}:
  s[p,0] = 0;

end;
