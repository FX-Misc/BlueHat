#include "SoftMax.mqh"
#include "INode.mqh"
float SoftMax::GetNode()
{
    float ave=0;
    for(int i=0; i<axons.Count(); i++)
        ave += axons.at(i).GetGainedValue();
    ave = ave/axons.Count();
    return OutputCurve(ave);
}
float SoftMax::OutputCurve(float raw) const
{
    return raw;   //TODO: the optimum curve from simulations must be imported here
}
void SoftMax::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
