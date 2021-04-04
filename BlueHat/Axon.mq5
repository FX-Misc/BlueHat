#include "Axon.mqh"
Axon::Axon(INode* pn, int n_id, bool neg, bool f, double init, double deg_r, double gr_r, double m, double M, axon_value_t meth) : negate(neg), freeze(f),degradaion_rate(deg_r), growth_rate(gr_r), pnode(pn), node_id(n_id), min(m), max(M), value_method(meth)
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
    double ret;
    switch(value_method)
    {
        case AXON_METHOD_GAIN:
            ret = pnode.GetNode()*gain;
            break;
        case AXON_METHOD_MIX:
            ret = pnode.GetNode()*gain*MathMax(profit_accumulated, 0.01);
            break;
        default:
            ret = 0;
            assert(false, "unknown axon method");
            break;
    }
    ret = SOFT_NORMAL( ret );
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
double Axon::GetProfit(void)
{
    return profit_accumulated;
}