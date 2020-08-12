#include "/NeuronSUM.mqh"
 
#include "/../INode.mqh"

enum neurons_t
{
    NEURON_SUM,
};
 
class NeuronFactory
{
private:
public:
    INeuron* CreateNeuron(neurons_t n);
};