#include "NeuronVoter.mqh"

void NeuronVoter::NeuronVoter(string nname)
{
    name = nname;
}

double NeuronVoter::GetNode()
{
    int p=0, n=0;
    for(int i=0; i<axons.Count(); i++)    
        switch(FLOAT_SIGN(axons.at(i).GetGainedValueN()))
        {
            case SIGN_ZERO:
                break;
            case SIGN_POSITIVE:
                p++;
                break;
            case SIGN_NEGATIVE:
                n++;
                break;
            default:
                assert(false,"unknown sign");
                return 0;
        }
    return ((double)p-n)/10;
}

void NeuronVoter::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
