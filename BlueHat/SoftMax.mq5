#include "SoftMax.mqh"
#include "INode.mqh"
//SoftMax::SoftMax(CXArrayList<Axon*> *ax) : axons(ax)
//{
//}
float SoftMax::GetNode()
{
    return 0;
/*    float ave=0;
    Axon *ax;
    for(int i=0; i<axons.Count(); i++)
    {
        axons.TryGetValue(i,ax);
        ave += ax.GetGainedValue();
    }
    ave = ave/axons.Count();
    return OutputCurve(ave);
*/
}
float SoftMax::OutputCurve(float raw) const
{
    return raw;   //TODO: the optimum curve from simulations must be imported here
}
void SoftMax::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
