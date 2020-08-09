#include "INode.mqh"
#include "Axon.mqh"
#include <Generic\ArrayList.mqh>
class INeuron : public INode
{
protected:
    CArrayList<Axon*> axons;
public:
    void AddAxon(Axon*);
};