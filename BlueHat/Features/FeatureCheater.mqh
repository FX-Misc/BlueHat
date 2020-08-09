//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
class FeatureCheater : public INode
{
public:
    FeatureCheater();
    ~FeatureCheater();
    float GetNode(void);
};