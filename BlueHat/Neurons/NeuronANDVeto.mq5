#include "NeuronANDVeto.mqh"

void NeuronANDVeto::NeuronANDVeto(string nname)
{
    name = nname;
}

double NeuronANDVeto::GetNode()
{
    int signs=0;
    for(int i=0; i<axons.Count(); i++)
        signs += FLOAT_SIGN(axons.at(i).GetGainedValueN());
    SIGN_T common_sign=SIGN_ZERO;
    if(signs == SIGN_POSITIVE * axons.Count())
        common_sign=SIGN_POSITIVE;
    if(signs == SIGN_NEGATIVE * axons.Count())
        common_sign=SIGN_NEGATIVE;
    if(common_sign==SIGN_ZERO)
        return 0;
    double ret=1;
    for(int i=0; i<axons.Count(); i++)
        ret *= axons.at(i).GetGainedValueN();
    ret=MathAbs(ret);
    double nret = MathPow(ret, (double)1/axons.Count());
    nret=(double)common_sign*nret;
    return nret;
}

void NeuronANDVeto::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
