#include "Axon.mqh"
Axon::Axon(INode* pn, int n_id, double deg_r, double gr_r, double m, double M) : degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn), node_id(n_id), min(m), max(M)
{
    gain = m;
    active = true;
}
void Axon::GainGrow(void)
{
    gain += growth_rate;
    if(gain>max)
        gain = max;
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
double Axon::GetGainedValueN() const
{
    return SOFT_NORMAL( pnode.GetNode()*gain );
}
double Axon::GetGain()
{
    return gain;
}