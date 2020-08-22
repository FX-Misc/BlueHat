#include "INode.mqh"
#include "Axon.mqh"
#include "/globals/ExtendedArrList.mqh"
class Neuron : public INode
{
protected:
    CXArrayList<Axon*> axons;
public:
    virtual void AddAxon(Axon* ax)=0;
    string name;
};