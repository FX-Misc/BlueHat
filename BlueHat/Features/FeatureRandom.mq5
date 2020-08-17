#include "FeatureRandom.mqh"
FeatureRandom::FeatureRandom(void)
{
    name="feRandom";
    MathSrand(GetTickCount());
}
FeatureRandom::~FeatureRandom(void)
{
}
void FeatureRandom::Update(int index, int history_index)
{   
    updated_value = (float)MathRand()/16384-1;
}

