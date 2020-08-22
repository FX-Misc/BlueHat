#include "NeuronSUM.mqh"

void NeuronSUM::NeuronSUM()
{
    name = "neSum";
}

float NeuronSUM::GetNode()
{
    float ret=0;
    for(int i=0; i<axons.Count(); i++)
        ret += axons.at(i).GetGainedValue();
    ret = ret/axons.Count();
    return ret;
}

void NeuronSUM::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
