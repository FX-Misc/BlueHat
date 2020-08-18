#include "/NeuronSUM.mqh"
 
#include "/../INode.mqh"

enum neurons_t
{
    NEURON_SUM,
};
 
class NeuronFactory
{
public:
    Neuron* CreateNeuron(neurons_t n);
};