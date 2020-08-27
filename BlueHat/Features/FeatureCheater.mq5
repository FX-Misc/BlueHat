#include "FeatureCheater.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
FeatureCheater::FeatureCheater(void)
{
    name="feCheater";
}
FeatureCheater::~FeatureCheater(void)
{
}
Feature* FeatureCheater::Instance()
{
    if(!CheckPointer(uniqueInstance))
        uniqueInstance=new FeatureCheater;
    return uniqueInstance;
}
void FeatureCheater::Update(const float& raw_close[], const float& norm_d[], int len)
{   //returns the future value; this "cheating" is only to test the converging speed of NN
    //don't use it in real training
//    updated_value = test_in[index-1];   //TODO: find a way to skip access restriction and get and return the future value
    updated_value = norm_d[0];
}
