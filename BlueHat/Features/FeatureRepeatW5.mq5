#include "FeatureRepeatW5.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureRepeatW5::FeatureRepeatW5(void)
{
    name="feRepeatW5";
}
FeatureRepeatW5::~FeatureRepeatW5(void)
{
}
Feature* FeatureRepeatW5::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureRepeatW5;
    return uniqueInstance;
}
void FeatureRepeatW5::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = ( 5*norm_d[1] + 4*norm_d[2] + 3*norm_d[3] + 2*norm_d[4] + 1*norm_d[5] ) / 15 ;
}

