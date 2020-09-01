#include "FeatureRandom.mqh"
FeatureRandom::FeatureRandom(void)
{
    name="feRandom";
}
FeatureRandom::~FeatureRandom(void)
{
}
Feature* FeatureRandom::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureRandom;
    return uniqueInstance;
}
void FeatureRandom::Update(const double& raw_close[], const double& norm_d[], int len)
{   
    updated_value = NOISE(-1,1);
}

