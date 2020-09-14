#include "NeuronSwitchCombine.mqh"

void NeuronSwitchCombine::NeuronSwitchCombine(string nname)
{
    name = nname;
}

double NeuronSwitchCombine::GetNode()
{
    //0: A=input
    //1: Sa=switch
    //2: B=input
    //3: Sb=switch
    //..
    assert((axons.Count()%2==0)&&(axons.Count()>1),"wrong no of axons in NeuronSwitchCombine");
    
    double sum=0;
    for(int i=0; i<axons.Count(); i+=2)    
        if(axons.at(i+1).GetGainedValueN()>0)
            sum+=axons.at(i).GetGainedValueN();

    return sum;
}

void NeuronSwitchCombine::AddAxon(Axon* ax)
{
    axons.Add(ax);
}
