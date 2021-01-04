#include "FeatureRSIsmooth.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureRSIsmooth::FeatureRSIsmooth(void)
{
    name="fiRSIsm";
    ArrayResize(rsi,TIMESERIES_DEPTH);
    ArraySetAsSeries(rsi,true);
    handle = iRSI(NULL,0,14,PRICE_CLOSE);
    assert(handle>=0,"RSI14 failed to init");
}
FeatureRSIsmooth::~FeatureRSIsmooth(void)
{
}
Feature* FeatureRSIsmooth::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureRSIsmooth;
    return uniqueInstance;
}
void FeatureRSIsmooth::Update(const double& raw_close[], const double& norm_d[], int len)
{
    market.GetIndicators(handle, 0, rsi);
    updated_value = 0;
    if(rsi[1]<rsi[2])
        if((rsi[2]>70) || (rsi[2]<rsi[3] && rsi[3]>70) || (rsi[2]<rsi[3] && rsi[3]<rsi[4] && rsi[4]>70) )
            updated_value = -0.5;
    if(rsi[1]>rsi[2])
        if((rsi[2]<30) || (rsi[2]>rsi[3] && rsi[3]<30) || (rsi[2]>rsi[3] && rsi[3]>rsi[4] && rsi[4]<30) )
            updated_value = +0.5;
}

