set FOOD;
set PLANET;
set OPERATION;

param month >= 0;

param montlyMaxTransport;
param transportationCost;

param planetInvtCostPerUnit;

param productionSteps {OPERATION, FOOD} >= 0;
param sellPrice {1..month, PLANET, FOOD} >= 0;

/* Food production per month*/
var make {1..month, FOOD} >= 0;

/* Quantity of food sold in each planet per month*/
var sell {1..month, PLANET, FOOD} >= 0;

/* Quantity of food stored on earth per month*/
var invt {1..month+1, FOOD} >= 0;

/* Amount of food transported out of earth per month*/
var transportOut{1..month, PLANET, FOOD} >= 0, <= montlyMaxTransport;
/* Amount of food transported in to each planet per month*/
var transportIn{1..month, PLANET, FOOD} >= 0, <= montlyMaxTransport;
/* trans = { 1 if transportOut > 0, otherwise 0*/
var trans {1..month, PLANET} binary;

## Restrict production of food, to our production capabilities
subject to line {t in 1..month, o in OPERATION}:
    0 <= sum {f in FOOD} make[t, f] / productionSteps[o, f] <= 1;

## Standard Inventory starts at 0
subject to invtStart:
    sum {f in FOOD} invt[1, f] = 0;

## Calculate stantard inventory quantity.
## The inventory quantity for the NEXT month is equal to inventory
## and production quantity of the PREVIOUS mounth minus
## the quantity we transport out.
subject to earthInvtQuantity {t in 1..month, f in FOOD}:
    invt[t+1, f] = invt[t, f] + make[t, f] - sum {p in PLANET} transportOut[t, p, f];

/* NOTE: In the context of the problem the following two restriction are redundant.*/

## If for some reason, transportation is not instantaneous, then we can change the
## the transportation time here. In this current exercise we consider that the
## transportation takes LESS than a month. Its considered instantaneous
subject to transportTime {t in 1..month, p in PLANET, f in FOOD}:
    transportOut[t, p, f] = transportIn[t, p, f];

## In the context of the problem there isn't a local inventory, meaning all the
## food arriving NEEDS to be sold.
subject to sellQuantity {t in 1..month, p in PLANET, f in FOOD}:
    sell[t, p, f] = transportIn[t, p, f];

## Calculate transport cost
## If in a given month we transport something to a planet,
## that incurs a fixed transportation cost
subject to transportMinCost {t in 1..month, p in PLANET}:
    sum {f in FOOD} transportOut[t, p, f] <= montlyMaxTransport * trans[t, p];

maximize profit:
    sum {t in 1..month, p in PLANET, f in FOOD} sell[t, p, f] * sellPrice[t, p, f]
    - sum {t in 1..month, f in FOOD} invt[t+1, f]
    - sum {t in 1..month, p in PLANET} trans[t, p] * transportationCost;
