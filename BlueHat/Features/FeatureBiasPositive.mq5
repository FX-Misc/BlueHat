#include "FeatureBiasPositive.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureBiasPositive::FeatureBiasPositive(void)
{
    name="feBiasP";
}
FeatureBiasPositive::~FeatureBiasPositive(void)
{
}
void FeatureBiasPositive::Update(int index, int history_index)
{
    updated_value = (float)0.5;
}

