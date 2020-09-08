#include "NeuronORSumP.mqh"

void NeuronORSumP::NeuronORSumP(string nname)
{
    name = nname;
}

double NeuronORSumP::GetNode()
{
    double ret=0;
    for(int i=0; i<axons.Count(); i++)    
        if(axons.at(i).GetGainedValueN()>0)
            ret+=axons.at(i).GetGainedValueN();
    return ret;
}

void NeuronORSumP::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
