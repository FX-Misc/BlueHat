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
Neuron* NeuronFactory::FindNeuronByName(string n, CXArrayList<Neuron*>* list, int& ret_id)
{
    for(int i=0; i<list.Count(); i++)
        if(list.at(i).name == n)
        {
            ret_id = i;
            return list.at(i);
        }
    ret_id = -1;
    return NULL;
}
