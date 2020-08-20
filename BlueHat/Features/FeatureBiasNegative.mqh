//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasNegative : public Feature
{
public:
    FeatureBiasNegative();
    ~FeatureBiasNegative();
    void Update(int index, int history_index);
};
    