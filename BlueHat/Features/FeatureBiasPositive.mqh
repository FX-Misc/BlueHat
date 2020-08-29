//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasPositive : public Feature
{
public:
    FeatureBiasPositive();
    ~FeatureBiasPositive();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureBiasPositive::uniqueInstance=NULL;    