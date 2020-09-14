#include "NeuronSwitchHard.mqh"

void NeuronSwitchHard::NeuronSwitchHard(string nname)
{
    name = nname;
}

double NeuronSwitchHard::GetNode()
{
    //0: A=input for positive S
    //1: B=input for negative S
    //2: S=Switch
    assert(axons.Count()==3,"wrong no of axons in NeuronSwitchHard");

    double A=axons.at(0).GetGainedValueN();
    double B=axons.at(1).GetGainedValueN();
    double S=axons.at(2).GetGainedValueN();
    switch(FLOAT_SIGN(S))
    {
        case SIGN_ZERO:
            return 0;
        case SIGN_POSITIVE:
            return A;
        case SIGN_NEGATIVE:
            return B;
        default:
            assert(false,"unknown sign");
            return 0;
    }
}

void NeuronSwitchHard::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
