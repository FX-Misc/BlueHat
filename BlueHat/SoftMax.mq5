#include "SoftMax.mqh"
float SoftMax::GetNode()
{
    float sum=0;
    for(int i=0; i<axons.Count(); i++)
        sum += axons.at(i).GetGainedValue();
    return OutputCurve(sum);
}
float SoftMax::OutputCurve(float raw) const
{
    return SOFT_NORMAL(raw);
}
void SoftMax::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
