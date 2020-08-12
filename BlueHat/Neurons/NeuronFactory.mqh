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
    NeuronFactory();
    INeuron* CreateNeuron(neurons_t n);
};