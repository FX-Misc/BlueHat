#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureSlope12 : public Feature
{
public:
    FeatureSlope12();
    ~FeatureSlope12();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureSlope12::uniqueInstance=NULL;    