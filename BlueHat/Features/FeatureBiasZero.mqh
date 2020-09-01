//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasZero : public Feature
{
public:
    FeatureBiasZero();
    ~FeatureBiasZero();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureBiasZero::uniqueInstance=NULL;    