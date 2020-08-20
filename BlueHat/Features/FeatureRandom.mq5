#include "FeatureRandom.mqh"
FeatureRandom::FeatureRandom(void)
{
    name="feRandom";
}
FeatureRandom::~FeatureRandom(void)
{
}
void FeatureRandom::Update(int index, int history_index)
{   
    updated_value = NOISE(-1,1);
}

