/*#include "Feature .mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
Feature::Feature(void)
{
    name="fe";
}
Feature::~Feature(void)
{
}
Feature* Feature::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new Feature;
    return uniqueInstance;
}
void FeatureReverseLast::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = -norm_d[1];
}

*/