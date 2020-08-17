#include "Axon.mqh"
Axon::Axon(INode* pn, int n_id, float deg_r, float gr_r, float m) : degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn), node_id(n_id), min(m)
{
    gain = m;
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
    if(gain<min)
        gain = min;
}
void Axon::GainDegrade(void)
{
    gain *= degradaion_rate;
    if(gain<min)
        gain = min;
}
float Axon::GetGainedValue() const
{
    return pnode.GetNode()*gain;
}
float Axon::GetGain()
{
    return gain;
}