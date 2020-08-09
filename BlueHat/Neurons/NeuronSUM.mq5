#include "NeuronSUM.mqh"
float NeuronSUM::GetNode()
{
    float ret=0;
    Axon *ax;
    for(int i=0; i<axons.Count(); i++)
    {
        axons.TryGetValue(i,ax);
        ret += ax.GetGainedValue();
    }
    ret = ret/axons.Count();
    return ret;
}
