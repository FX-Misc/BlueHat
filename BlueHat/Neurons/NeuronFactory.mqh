#include "../globals/ExtendedArrList.mqh"
#include "/../INode.mqh"

#include "/NeuronSUM.mqh"
 
class NeuronFactory
{
public:
    Neuron* CreateNeuron(string type, string nname);
    Neuron* FindNeuronByName(string n, CXArrayList<Neuron*>* list, int& ret_id);    
};