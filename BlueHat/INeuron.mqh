#include "INode.mqh"
#include "Axon.mqh"
#include <Generic\ArrayList.mqh>
class INeuron : public INode
{
protected:
    CArrayList<Axon*> axons;
public:
    virtual void AddAxon(Axon*)=0;
};