#include "../Neuron.mqh"
class NeuronNORSumN : public Neuron
{
public:
    NeuronNORSumN(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
