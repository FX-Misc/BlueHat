#include "Axon.mqh"
Axon::Axon(INode* pn, float deg_r, float gr_r) : degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn)
{
    gain = 0;
    active = true;
}
void Axon::GainGrow(void)
{
    gain += growth_rate;
    if(gain>1)
        gain = 1;
}
void Axon::GainDeGrow(void)
{
    gain -= growth_rate;
    if(gain<-1)
        gain = -1;
}
void Axon::GainDegrade(void)
{
    gain *= degradaion_rate;
}
float Axon::GetGainedValue() const
{
    return pnode.GetNode();
}
