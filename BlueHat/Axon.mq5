#include "Axon.mqh"
Axon::Axon(INode* pn, int n_id, bool f, double init, double deg_r, double gr_r, double m, double M) : freeze(f),degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn), node_id(n_id), min(m), max(M)
{
    gain = init;
    hist_sum = 0;
    hist_cnt = 1;
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
void Axon::ResetGain()
{
    gain = min;
}
double Axon::GetAve()
{
    return hist_sum/hist_cnt;
}
void Axon::UpdateAve()
{
    hist_cnt++;
    hist_sum += gain;
}
