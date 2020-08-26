#include "FeatureBiasNegative.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureBiasZero::FeatureBiasZero(void)
{
    name="feBiasZ";
}
FeatureBiasZero::~FeatureBiasZero(void)
{
}
void FeatureBiasZero::Update(const float& raw_close[], const float& norm_d[], int len)
{
    updated_value = (float)0;
}

