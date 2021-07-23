#----------------------------------
#  Declaração de Parametros
#----------------------------------
set Product:= 1..3;					# set of products: 1-Regular, 2-Classical, 3-Intense
set Operations:= 1..3;				# set of operations: 1-Cleaning, 2- Cooking, 3-Packing
set Month:= 1..12;

param SLimit:= 1000;			# maximum quantity that can be sent per planet/period
param HoldEarth:= 1;				# monthly cost for usage of storage, in solarcoins
param HoldSpace:= 2;				# monthly cost for usage of storage, in solarcoins
param Shipping:= 10000;				# cost, in solarcoins, per shipment

param ValVen{Month, Product} >= 0;	# value in Venus of product p in month m
param ValMar{Month, Product} >= 0;	# value in Mars of product p in month m
param ValMer{Month, Product} >= 0;	# value in Mercury of product p in month m

param Rate{Operations, Product} >= 0;	# production rate for P in operation O


#---------------------------------
#  Declaração de Variaveis
#---------------------------------
var Prod{Month, Product} >= 0;		# quantiry of product P produced in month M

var SellVen{Month, Product} >= 0;	# quantity of product P to sell to Venus in month M
var SellMar{Month, Product} >= 0;	# quantity of product P to sell to Mars in month M
var SellMer{Month, Product} >= 0;	# quantity of product P to sell to Mercury in month M

var StoreEarth{0..12, Product} >= 0;	# quantity of product P kept in storage on Earth at the end of the month
var StoreVen{0..12, Product} >= 0;		# quantity of product P kept in storage on Venus at the end of the month
var StoreMar{0..12, Product} >= 0;		# quantity of product P kept in storage on Mars at the end of the month
var StoreMer{0..12, Product} >= 0;		# quantity of product P kept in storage on Mercury at the end of the month

var SentVen{Month, Product} >= 0;  # quantity of product P sent to Venus in month M
var SentMar{Month, Product} >= 0;  # quantity of product P sent to Mars in month M
var SentMer{Month, Product} >= 0;  # quantity of product P sent to Mercury in month M

var Ven{Month} binary;			# 1 if a shippment is sent to Venus in that month, 0 if not
var Mar{Month} binary;			# 1 if a shippment is sent to Mars in that month, 0 if not
var Mer{Month} binary;			# 1 if a shippment is sent to Mercury in that month, 0 if not


#-------------------------------
#   Declaração de Restrições
#-------------------------------
subj to
Prod_Rate{o in Operations, m in Month}:
	sum{p in Product} (Prod[m,p]/Rate[o,p]) <= 1;

Inventory{p in Product, m in Month}:Prod[m,p] + StoreEarth[m-1,p] =
										SentVen[m,p] + SentMar[m,p] +
										SentMer[m,p] + StoreEarth[m,p];

ShipVen{m in Month}: sum{p in Product} SentVen[m,p] <= SLimit*Ven[m];
ShipMar{m in Month}: sum{p in Product} SentMar[m,p] <= SLimit*Mar[m];
ShipMer{m in Month}: sum{p in Product} SentMer[m,p] <= SLimit*Mer[m];

SVen{m in Month, p in Product}:
	SentVen[m,p] + StoreVen[m-1,p] = SellVen[m,p] + StoreVen[m,p];
SMar{m in Month, p in Product}:
	SentMar[m,p] + StoreMar[m-1,p] = SellMar[m,p] + StoreMar[m,p];
SMer{m in Month, p in Product}:
	SentMer[m,p] + StoreMer[m-1,p] = SellMer[m,p] + StoreMer[m,p];

EmptyEarth{p in Product}: StoreEarth[0,p] = 0;
EmptyVen{p in Product}: StoreVen[0,p] = 0;
EmptyMar{p in Product}: StoreMar[0,p] = 0;
EmptyMer{p in Product}: StoreMer[0,p] = 0;


#----------------------------------
#   Declaração de Função Objetivo
#----------------------------------
maximize Profit: sum{m in Month}(sum{p in Product} (
						SellVen[m,p]*ValVen[m,p] +
						SellMar[m,p]*ValMar[m,p] +
						SellMer[m,p]*ValMer[m,p] -
						HoldEarth*StoreEarth[m,p] -
						HoldSpace*StoreVen[m,p] -
						HoldSpace*StoreMar[m,p] -
						HoldSpace*StoreMer[m,p] -
						Shipping*(Ven[m] + Mar[m] + Mer[m])
				 ));

end;
