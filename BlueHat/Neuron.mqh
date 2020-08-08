#include "INode.mqh"
#include "Axon.mqh"
#include <Generic\ArrayList.mqh>
class Neuron : public INode
{
private:
    CArrayList<Axon*> arr;
public:
    float GetValue();
    
};
