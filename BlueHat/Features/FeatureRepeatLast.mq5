#include "FeatureRepeatLast.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureRepeatLast::FeatureRepeatLast(void)
{
    name="feRepeatL";
}
FeatureRepeatLast::~FeatureRepeatLast(void)
{
}
void FeatureRepeatLast::Update(const float& raw_close[], const float& d[], int len)
{
    updated_value = d[1];
}

