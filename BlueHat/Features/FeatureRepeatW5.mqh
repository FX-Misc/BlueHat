#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureRepeatW5: public Feature
{
public:
    FeatureRepeatW5();
    ~FeatureRepeatW5();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureRepeatW5::uniqueInstance=NULL;    