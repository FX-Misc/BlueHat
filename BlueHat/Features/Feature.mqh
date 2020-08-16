//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
class Feature : public INode
{
protected:
    float updated_value;
public:
    virtual void Update(int index, int history_index) = 0;
    float GetNode(void);
    string name;
};