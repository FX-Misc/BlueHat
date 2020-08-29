#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureRepeatLast : public Feature
{
public:
    FeatureRepeatLast();
    ~FeatureRepeatLast();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureRepeatLast::uniqueInstance=NULL;    