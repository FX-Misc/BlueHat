//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureCheater : public Feature
{
public:
    FeatureCheater();
    ~FeatureCheater();
    void Update(int index, int history_index);
};
    