//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasPositive : public Feature
{
public:
    FeatureBiasPositive();
    ~FeatureBiasPositive();
    void Update(int index, int history_index);
};
    