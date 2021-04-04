#include "../Neuron.mqh"
class NeuronSwitchCompare : public Neuron
{
public:
    NeuronSwitchCompare(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
