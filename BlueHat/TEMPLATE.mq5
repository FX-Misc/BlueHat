#include "Axon.mqh"
Axon::Axon(INode* pn, double deg_r, double gr_r) : degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn)
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
