#include "INode.mqh"
#include "Axon.mqh"
class Neuron : public INode
{
private:
    Axon* Axons;
public:
    float GetValue();
    
};
