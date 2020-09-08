#include "../Neuron.mqh"
class NeuronORSumP : public Neuron
{
public:
    NeuronORSumP(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
