#include "FeatureBiasPositive.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureBiasPositive::FeatureBiasPositive(void)
{
    name="feBiasP";
}
FeatureBiasPositive::~FeatureBiasPositive(void)
{
}
Feature* FeatureBiasPositive::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureBiasPositive;
    return uniqueInstance;
}
void FeatureBiasPositive::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = (double)0.1;
}

