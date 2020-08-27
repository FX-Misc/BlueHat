//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasNegative : public Feature
{
public:
    FeatureBiasNegative();
    ~FeatureBiasNegative();
    void Update(const float& raw_close[], const float& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureBiasNegative::uniqueInstance=NULL;    