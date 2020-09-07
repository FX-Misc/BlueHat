#include "NeuronSUM.mqh"

void NeuronSUM::NeuronSUM(string nname)
{
    name = nname;
}

double NeuronSUM::GetNode()
{
    double ret=0;
    for(int i=0; i<axons.Count(); i++)
        ret += axons.at(i).GetGainedValueN();
    return ret;
}

void NeuronSUM::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
