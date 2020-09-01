#include "FeatureBiasNegative.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureBiasZero::FeatureBiasZero(void)
{
    name="feBiasZ";
}
FeatureBiasZero::~FeatureBiasZero(void)
{
}
Feature* FeatureBiasZero::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureBiasZero;
    return uniqueInstance;
}
void FeatureBiasZero::Update(const double& raw_close[], const double& norm_d[], int len)
{
    updated_value = (double)0;
}

