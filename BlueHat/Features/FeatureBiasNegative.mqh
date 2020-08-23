//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasNegative : public Feature
{
public:
    FeatureBiasNegative();
    ~FeatureBiasNegative();
    void Update(const float& c[], int len);
};
    