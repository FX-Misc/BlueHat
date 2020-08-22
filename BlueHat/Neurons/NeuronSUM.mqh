#include "../Neuron.mqh"
class NeuronSUM : public Neuron
{
public:
    NeuronSUM();
    float GetNode();
    void AddAxon(Axon*);    
};
