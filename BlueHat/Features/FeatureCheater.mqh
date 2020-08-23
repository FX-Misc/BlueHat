//NOTE: only for testing the NN performance. Not to be used in real training
#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureCheater : public Feature
{
public:
    FeatureCheater();
    ~FeatureCheater();
    void Update(const float& c[], int len);
};
    