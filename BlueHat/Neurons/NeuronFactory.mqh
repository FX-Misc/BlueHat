#include "/NeuronSUM.mqh"
 
#include "/../INode.mqh"
 
class NeuronFactory
{
public:
    Neuron* CreateNeuron(string name);
};