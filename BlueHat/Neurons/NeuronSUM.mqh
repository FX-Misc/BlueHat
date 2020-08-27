#include "../Neuron.mqh"
class NeuronSUM : public Neuron
{
public:
    NeuronSUM(string nname);
    float GetNode();
    void AddAxon(Axon*);    
};
