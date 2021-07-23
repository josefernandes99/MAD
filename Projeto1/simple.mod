set MONTH;

param priceRVenus {MONTH};
param priceCVenus {MONTH};
param priceIVenus {MONTH};
param priceRMars {MONTH};
param priceCMars {MONTH};
param priceIMars {MONTH};
param priceRMercury {MONTH};
param priceCMercury {MONTH};
param priceIMercury {MONTH};

var RVenus {MONTH} >= 0;
var CVenus {MONTH} >= 0;
var IVenus {MONTH} >= 0;
var RMars {MONTH} >= 0;
var CMars {MONTH} >= 0;
var IMars {MONTH} >= 0;
var RMercury {MONTH} >= 0;
var CMercury {MONTH} >= 0;
var IMercury {MONTH} >= 0;

maximize revenue :
    sum {i in MONTH} (priceRVenus[i]*RVenus[i] + priceCVenus[i]*CVenus[i] + priceIVenus[i]*IVenus[i] + priceRMars[i]*RMars[i] + priceCMars[i]*CMars[i] + priceIMars[i]*IMars[i] + priceRMercury[i]*RMercury[i] + priceCMercury[i]*CMercury[i] + priceIMercury[i]*IMercury[i]);

Cleaning {i in MONTH}: (RVenus[i] + RMars[i] + RMercury[i])/1000 + (CVenus[i] + CMars[i] + CMercury[i])/1535 + (IVenus[i] + IMars[i] + IMercury[i])/1750 <= 1;
Cooking {i in MONTH}: (RVenus[i] + RMars[i] + RMercury[i])/1850 + (CVenus[i] + CMars[i] + CMercury[i])/850 + (IVenus[i] + IMars[i] + IMercury[i])/1200 <= 1;
Packing {i in MONTH}: (RVenus[i] + RMars[i] + RMercury[i])/750 + (CVenus[i] + CMars[i] + CMercury[i])/1500 + (IVenus[i] + IMars[i] + IMercury[i])/2000 <= 1;

VenusMQ {i in MONTH}: RVenus[i] + CVenus[i] + IVenus[i] <= 1000;
MarsMQ {i in MONTH}: RMars[i] + CMars[i] + IMars[i] <= 1000;
MercuryMQ {i in MONTH}: RMercury[i] + CMercury[i] + IMercury[i] <= 1000;

end;
