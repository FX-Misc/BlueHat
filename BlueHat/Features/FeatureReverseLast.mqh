#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureReverseLast : public Feature
{
public:
    FeatureReverseLast();
    ~FeatureReverseLast();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureReverseLast::uniqueInstance=NULL;    