#include "FeatureCheater.mqh"
FeatureCheater::FeatureCheater(void)
{
}
FeatureCheater::~FeatureCheater(void)
{
}
float FeatureCheater::GetNode(void)
{   //returns the future value; this "cheating" is only to test the diverging speed of NN
    //don't use it in real training
    return 0;   //TODO: find a way to skip access restriction and get and return the future value
}
