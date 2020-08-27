#include "FeatureRandom.mqh"
FeatureRandom::FeatureRandom(void)
{
    name="feRandom";
}
FeatureRandom::~FeatureRandom(void)
{
}
void FeatureRandom::Update(const float& raw_close[], const float& norm_d[], int len)
{   
    updated_value = NOISE(-1,1);
}

