#include "FeatureReverseLast.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureReverseLast::FeatureReverseLast(void)
{
    name="feReverseL";
}
FeatureReverseLast::~FeatureReverseLast(void)
{
}
Feature* FeatureReverseLast::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureReverseLast;
    return uniqueInstance;
}
void FeatureReverseLast::Update(const float& raw_close[], const float& norm_d[], int len)
{
    updated_value = -norm_d[1];
}

