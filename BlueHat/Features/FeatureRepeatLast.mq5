#include "FeatureRepeatLast.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureRepeatLast::FeatureRepeatLast(void)
{
    name="feRepeatL";
}
FeatureRepeatLast::~FeatureRepeatLast(void)
{
}
Feature* FeatureRepeatLast::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureRepeatLast;
    return uniqueInstance;
}
void FeatureRepeatLast::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = norm_d[1];
}

