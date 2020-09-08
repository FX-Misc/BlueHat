#include "NeuronSumDir.mqh"

void NeuronSumDir::NeuronSumDir(string nname)
{
    name = nname;
}

double NeuronSumDir::GetNode()
{
    double p=0, n=0;
    for(int i=0; i<axons.Count(); i++)    
        if(axons.at(i).GetGainedValueN()>0)
            p+=axons.at(i).GetGainedValueN();
        else
            n+=axons.at(i).GetGainedValueN();
    if(MathAbs(p)>MathAbs(n))
        return p;
    else if(MathAbs(p)<MathAbs(n))
        return n;
    else
        return 0;
}

void NeuronSumDir::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
