//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasPositive : public Feature
{
public:
    FeatureBiasPositive();
    ~FeatureBiasPositive();
    void Update(const float& raw_close[], const float& norm_d[], int len);
};
    