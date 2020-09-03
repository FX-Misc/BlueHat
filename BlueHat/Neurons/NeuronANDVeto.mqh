#include "../Neuron.mqh"
class NeuronANDVeto : public Neuron
{
public:
    NeuronANDVeto(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
