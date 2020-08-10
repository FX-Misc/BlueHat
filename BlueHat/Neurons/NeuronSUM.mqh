#include "../INeuron.mqh"
class NeuronSUM : public INeuron
{
public:
    float GetNode();
    void AddAxon(Axon*);    
};
