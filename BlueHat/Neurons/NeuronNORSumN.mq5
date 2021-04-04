#include "NeuronNORSumN.mqh"

void NeuronNORSumN::NeuronNORSumN(string nname)
{
    name = nname;
}

double NeuronNORSumN::GetNode()
{
    double ret=0;
    for(int i=0; i<axons.Count(); i++)    
        if(axons.at(i).GetGainedValueN()<0)
            ret+=axons.at(i).GetGainedValueN();
    return ret;
}

void NeuronNORSumN::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
