#include "FeatureMACD.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureMACD::FeatureMACD(void)
{
    name="fiMACD";
    ArrayResize(macd_main,TIMESERIES_DEPTH);
    ArrayResize(macd_signal,TIMESERIES_DEPTH);
    ArraySetAsSeries(macd_main,true);
    ArraySetAsSeries(macd_signal,true);
    handle = iMACD(NULL,0,12,26,9,PRICE_CLOSE);
    assert(handle>=0,"IMA failed to init");
}
FeatureMACD::~FeatureMACD(void)
{
}
Feature* FeatureMACD::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureMACD;
    return uniqueInstance;
}
void FeatureMACD::Update(const double& raw_close[], const double& norm_d[], int len)
{
    market.GetIndicators(handle, 0, macd_main);
    market.GetIndicators(handle, 1, macd_signal);   //the histogram
    updated_value = 10 * market.diff_norm_factor * 2*( macd_signal[1]-macd_signal[2] ) +2*( macd_main[1]-macd_main[2] ) +1*( macd_main[1]-macd_signal[1] );
}

