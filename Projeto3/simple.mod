set Ops;	# type of operations
set Type;   # type of products
param Week;	# weeks

param opsRate{o in Ops, t in Type};	# rates of operations
param orders{t in Type, w in 1..Week};	# encomendas
param holdCost;	    # holding cost per week
param delayCost;    # cost of delay per week
param opsCost;  # cost of each operation per week
param M;

var holding{t in Type, w in 0..Week} >= 0;	# holding inventory earth
var delayed{t in Type, w in 0..Week} >= 0;  #product delayed
var production{t in Type, w in 1..Week} >= 0;	# production on earth
var sold{t in Type, w in 1..Week} >= 0;	# delivered in period t
var productionExists{t in Type, w in 1..Week} binary; # existance of production of certain type

minimize loss: sum {t in Type, w in 1..Week} (productionExists[t,w]*opsCost) +
               sum {t in Type, w in 1..Week} (delayed[t,w]*delayCost) +
               sum {t in Type, w in 1..Week} (holding[t,w]*holdCost);

Occupation {o in Ops, w in 1..Week}: sum {t in Type} production[t,w]/opsRate[o,t] <= 1;
BOM {t in Type, w in 1..Week}: production[t,w] + holding[t,w-1] + delayed[t,w] = orders[t,w] + delayed[t,w-1] + holding[t,w];
Operations {w in 1..Week}: sum {t in Type} productionExists[t,w] <= 2;
Produced {t in Type, w in 1..Week}: production[t,w] <= M*productionExists[t,w];
InitHold {t in Type}: holding[t,0] = 0;
NoDelays1 {t in Type}: delayed[t,0] = 0;
NoDelays2 {t in Type}: delayed[t,52] = 0;

end;
