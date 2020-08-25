#include "NeuronSUM.mqh"

void NeuronSUM::NeuronSUM()
{
    name = "neSum";
}

float NeuronSUM::GetNode()
{
    float ret=0;
    for(int i=0; i<axons.Count(); i++)
        ret += axons.at(i).GetGainedValueN();
//    ret = SOFT_NORMAL(ret);
    return ret;
}

void NeuronSUM::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
