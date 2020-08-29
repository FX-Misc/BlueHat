#include "../Neuron.mqh"
class NeuronSUM : public Neuron
{
public:
    NeuronSUM(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
