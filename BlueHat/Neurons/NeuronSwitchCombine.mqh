#include "../Neuron.mqh"
class NeuronSwitchCombine : public Neuron
{
public:
    NeuronSwitchCombine(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
