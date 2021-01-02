#include "FeatureReverse5ave.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureReverse5ave::FeatureReverse5ave(void)
{
    name="feReverse5ave";
}
FeatureReverse5ave::~FeatureReverse5ave(void)
{
}
Feature* FeatureReverse5ave::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureReverse5ave;
    return uniqueInstance;
}
void FeatureReverse5ave::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = -( norm_d[1] + norm_d[2] + norm_d[3] + norm_d[4] + norm_d[5] ) / 5 ;
}

