#include "/NeuronSUM.mqh"
 
#include "/../INode.mqh"
 
class NeuronFactory
{
public:
    Neuron* CreateNeuron(string type, string nname);
};