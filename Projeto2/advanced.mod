set O;		# type of operations
set P;		# type of products
set C;		# name of planets
param T;	# months

param r{o in O, p in P};	# rates of operations
param v{c in C, p in P, t in 1..T};	# prices per month per planet per type of product
param S;        # earth shuttles capacity
param SCost;      # shuttle cost
param h;	    # holding cost per month
param hInter;    #holding cost inter per month

var sEarth{p in P, t in 0..T} >= 0;	# holding inventory earth
var sInter{c in C, p in P, t in 0..T} >= 0;
var z{p in P, t in 1..T} >= 0;	# production on earth
var xEarth{c in C, p in P, t in 1..T} >= 0;	# delivery from earth for country c, period t
var xInter{c in C, p in P, t in 1..T} >= 0;
var shuttles{c in C, t in 1..T} binary; # number of shuttles for each month

maximize profit: sum {c in C, p in P, t in 1..T} (xInter[c,p,t]*v[c,p,t]) -
                 sum {c in C, t in 1..T} (shuttles[c,t]*SCost) -
                 sum {p in P, t in 1..T} (h*sEarth[p,t]) -
                 sum {c in C, p in P, t in 1..T} (hInter*sInter[c,p,t]);

Occupation {o in O, t in 1..T}: sum {p in P} z[p,t]/r[o,p] <= 1;
BOM {p in P, t in 1..T}: z[p,t] + sEarth[p,t-1] = (sum {c in C} xEarth[c,p,t]) + sEarth[p,t];
BOMInter {c in C, p in P, t in 1..T}: sInter[c,p,t-1] + xEarth[c,p,t] = xInter[c,p,t] + sInter[c,p,t];
Delivery {c in C, t in 1..T}: sum {p in P} xEarth[c,p,t] <= S*shuttles[c,t];
Inits {p in P}: sEarth[p,0] = 0;
InitsInter {c in C, p in P}: sInter[c,p,0] = 0;

end;
