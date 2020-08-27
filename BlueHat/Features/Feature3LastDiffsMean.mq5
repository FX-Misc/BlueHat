#include "Feature3LastDiffsMean.mqh"
//Note: buf[index] is the correct one to use normally. Cheater uses index-1 which is the future value in script or the last tick (incomplete) in live trading
Feature3LastDiffsMean::Feature3LastDiffsMean(void)
{
    name="fe3DiffMean";
}
Feature3LastDiffsMean::~Feature3LastDiffsMean(void)
{
}
void Feature3LastDiffsMean::Update(const float& raw_close[], const float& norm_d[], int len)
{
    updated_value = norm_d[1]+norm_d[2]+norm_d[3];
}

