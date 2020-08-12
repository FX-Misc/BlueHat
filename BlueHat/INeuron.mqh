#include "INode.mqh"
#include "Axon.mqh"
#include "/globals/ExtendedArrList.mqh"
class INeuron : public INode
{
protected:
    CXArrayList<Axon*> axons;
public:
    virtual void AddAxon(Axon*)=0;
};