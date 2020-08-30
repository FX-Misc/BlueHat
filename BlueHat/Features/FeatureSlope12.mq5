#include "FeatureSlope12.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureSlope12::FeatureSlope12(void)
{
    name="feSlope12";
}
FeatureSlope12::~FeatureSlope12(void)
{
}
Feature* FeatureSlope12::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureSlope12;
    return uniqueInstance;
}
void FeatureSlope12::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = 2*norm_d[1]-norm_d[2];
}

