//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasNegative : public Feature
{
public:
    FeatureBiasNegative();
    ~FeatureBiasNegative();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureBiasNegative::uniqueInstance=NULL;    