#include "INode.mqh"
#include "Axon.mqh"
#include <Generic\ArrayList.mqh>
class INeuron : public INode
{
private:
    CArrayList<Axon*> axons;
//public:
//    virtual int GetNode(void)=0;
};