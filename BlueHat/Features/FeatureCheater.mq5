#include "FeatureCheater.mqh"
FeatureCheater::FeatureCheater(void)
{
}
FeatureCheater::~FeatureCheater(void)
{
}
void FeatureCheater::Update(int index, int history_index)
{   //returns the future value; this "cheating" is only to test the diverging speed of NN
    //don't use it in real training
    updated_value = 0.1;   //TODO: find a way to skip access restriction and get and return the future value
}

