#include "NeuronFactory.mqh"
//#include "../globals/assert.mqh"
Neuron* NeuronFactory::CreateNeuron(string name)
{
    INode* neuron;
    if(name=="neSum")
        neuron = new NeuronSUM();
    else if(name=="neSum")
        neuron = new NeuronSUM();
    else
        neuron = NULL;
    assert(neuron != NULL, "CreateNeuron failed to create");
    return neuron;
}
