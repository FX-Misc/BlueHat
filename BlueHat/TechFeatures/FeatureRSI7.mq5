#include "FeatureRSI7.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureRSI7::FeatureRSI7(void)
{
    name="fiRSI7";
    ArrayResize(rsi,TIMESERIES_DEPTH);
    ArraySetAsSeries(rsi,true);
    handle = iRSI(NULL,0,7,PRICE_CLOSE);
    assert(handle>=0,"RSI failed to init");
}
FeatureRSI7::~FeatureRSI7(void)
{
}
Feature* FeatureRSI7::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureRSI7;
    return uniqueInstance;
}
void FeatureRSI7::Update(const double& raw_close[], const double& norm_d[], int len)
{
    market.GetIndicators(handle, 0, rsi);
    updated_value = 0;
    if(rsi[1]>70)
        updated_value = -0.5;
    if(rsi[1]<30)
        updated_value = +0.5;
}

