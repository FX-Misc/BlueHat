#include "Axon.mqh"
Axon::Axon(INode* pn, int n_id, bool neg, bool f, double init, double deg_r, double gr_r, double m, double M) : negate(neg), freeze(f),degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn), node_id(n_id), min(m), max(M)
{
    gain = init;
    hist_sum = 0;
    hist_cnt = 1;
    profit_accumulated = 0;
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
    double ret = SOFT_NORMAL( pnode.GetNode()*gain );
    if(negate)
        return -ret;
    else 
    return ret;
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
void Axon::RecordProfit(double profit)
{
    profit_accumulated += profit;
}
