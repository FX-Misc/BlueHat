//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasZero : public Feature
{
public:
    FeatureBiasZero();
    ~FeatureBiasZero();
    void Update(int index, int history_index);
};
    