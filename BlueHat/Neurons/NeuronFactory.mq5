#include "NeuronFactory.mqh"
//#include "../globals/assert.mqh"
Neuron* NeuronFactory::CreateNeuron(string type, string nname)
{
    INode* neuron;
    if(type=="neSum")
        neuron = new NeuronSUM(nname);
    else if(type=="neSum")
        neuron = new NeuronSUM(nname);
    else
        neuron = NULL;
    assert(neuron != NULL, "CreateNeuron failed to create");
    return neuron;
}
