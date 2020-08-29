#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureReverseLast : public Feature
{
public:
    FeatureReverseLast();
    ~FeatureReverseLast();
    void Update(const float& raw_close[], const float& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureReverseLast::uniqueInstance=NULL;    