#include "FeatureMACDDigital.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureMACDDigital::FeatureMACDDigital(void)
{
    name="fiMACDdig";
    ArrayResize(macd_main,TIMESERIES_DEPTH);
    ArrayResize(macd_signal,TIMESERIES_DEPTH);
    ArraySetAsSeries(macd_main,true);
    ArraySetAsSeries(macd_signal,true);
    handle = iMACD(NULL,0,12,26,9,PRICE_CLOSE);
    assert(handle>=0,"IMA failed to init");
}
FeatureMACDDigital::~FeatureMACDDigital(void)
{
}
Feature* FeatureMACDDigital::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureMACDDigital;
    return uniqueInstance;
}
void FeatureMACDDigital::Update(const double& raw_close[], const double& norm_d[], int len)
{
    Print("MACDhndl:",handle);
    market.GetIndicators(handle, 1, macd_signal);   //the histogram (A)
    market.GetIndicators(handle, 0, macd_main);
    int score=0;
    score += (macd_signal[1]>macd_signal[2])? +4:-4;
    score += (macd_main[1]>macd_signal[1])? +2:-2;
    score += (macd_main[1]>macd_main[2])? +4:-4;
    score += (macd_main[1]>0)? +1:-1;
    updated_value = (double)score/11;
}

