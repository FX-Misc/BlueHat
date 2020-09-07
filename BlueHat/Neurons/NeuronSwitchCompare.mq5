#include "NeuronSwitchCompare.mqh"

void NeuronSwitchCompare::NeuronSwitchCompare(string nname)
{
    name = nname;
}

double NeuronSwitchCompare::GetNode()
{
    //0: A=input
    //1: S=switch +
    //2: T=switch - trigger leve
    assert(axons.Count()==3,"wrongno of axons in NeuronSwitchCompare");
    
    double A=axons.at(0).GetGainedValueN();
    double S=axons.at(1).GetGainedValueN();
    double T=axons.at(2).GetGainedValueN();
    if(S<T)
        return 0;
    else
        return SIGN(A)*MathSqrt(MathSqrt(MathAbs(A*(S-T))));
}

void NeuronSwitchCompare::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
