set O;		# type of operations
set P;		# type of products
set C;		# name of planets
param T;	# months

param r{o in O, p in P};	# rates of operations
param v{c in C, p in P, t in 1..T};	# prices per month per planet per type of product
param S;        # earth shuttles capacity
param SCost;      # shuttle cost
param h;	    # holding cost per month

var s{p in P, t in 0..T} >= 0;	# holding inventory earth
var z{p in P, t in 1..T} >= 0;	# production on earth
var x{c in C, p in P, t in 1..T} >= 0;	# delivery from earth for country c, period t
var shuttles{c in C, t in 1..T} binary; # number of shuttles for each month

maximize profit: sum {c in C, p in P, t in 1..T} (x[c,p,t]*v[c,p,t]) -
                 sum {p in P, t in 1..T} (h*s[p,t]) -
                 sum {c in C, t in 1..T} shuttles[c,t]*SCost;

Occupation {o in O, t in 1..T}: sum {p in P} z[p,t]/r[o,p] <= 1;
BOM {p in P, t in 1..T}: z[p,t] + s[p,t-1] = (sum {c in C} x[c,p,t]) + s[p,t];
Delivery {c in C, t in 1..T}: sum {p in P} x[c,p,t] <= S*shuttles[c,t];
Inits {p in P}: s[p,0] = 0;

end;
