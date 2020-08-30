#include "FeatureIMAFast.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureIMAFast::FeatureIMAFast(void)
{
    name="fiIMAFast";
    ArrayResize(IMA,TIMESERIES_DEPTH);
    ArraySetAsSeries(IMA,true);
    IMA_handle = iMA(NULL,0,21,0,MODE_EMA,PRICE_CLOSE);
    assert(IMA_handle>=0,"IMA failed to init");
}
FeatureIMAFast::~FeatureIMAFast(void)
{
}
Feature* FeatureIMAFast::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureIMAFast;
    return uniqueInstance;
}
void FeatureIMAFast::Update(const double& raw_close[], const double& norm_d[], int len)
{
//    int temp;
    market.GetIndicators(IMA_handle,IMA);
//    temp = CopyBuffer(IMA_handle,0,0,3,IMA);
//    assert(temp>0,"CopyBuffer failed");
    updated_value = IMA[1];
}

