#include "../Neuron.mqh"
class NeuronSwitchHard : public Neuron
{
public:
    NeuronSwitchHard(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
