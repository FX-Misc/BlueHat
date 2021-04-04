#include "../Neuron.mqh"
class NeuronVoter : public Neuron
{
public:
    NeuronVoter(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
