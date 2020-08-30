#include "FeatureBiasNegative.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureBiasNegative::FeatureBiasNegative(void)
{
    name="feBiasN";
}
FeatureBiasNegative::~FeatureBiasNegative(void)
{
}
Feature* FeatureBiasNegative::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureBiasNegative;
    return uniqueInstance;
}
void FeatureBiasNegative::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = (double)-0.5;
}

