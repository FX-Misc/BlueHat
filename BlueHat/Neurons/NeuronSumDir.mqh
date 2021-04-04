#include "../Neuron.mqh"
class NeuronSumDir : public Neuron
{
public:
    NeuronSumDir(string nname);
    double GetNode();
    void AddAxon(Axon*);    
};
