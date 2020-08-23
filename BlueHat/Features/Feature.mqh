//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
class Feature : public INode
{
protected:
    float updated_value;
public:
    virtual void Update(const float& c[], int len) = 0;
    float GetNode(void);
    string name;
};