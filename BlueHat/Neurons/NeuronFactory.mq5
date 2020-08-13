#include "NeuronFactory.mqh"
//#include "../globals/assert.mqh"
INeuron* NeuronFactory::CreateNeuron(neurons_t n)
{
    INode* neuron;
    switch(n)
    {
        case NEURON_SUM:
            neuron = new NeuronSUM();
            break;
        default:
            neuron = NULL;
            break;
    };
    assert(neuron != NULL, "CreateNeuron failed to create");
    return neuron;
}
