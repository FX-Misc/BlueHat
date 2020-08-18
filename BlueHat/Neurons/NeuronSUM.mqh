#include "../Neuron.mqh"
class NeuronSUM : public Neuron
{
public:
    float GetNode();
    void AddAxon(Axon*);    
};
