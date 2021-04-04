#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureReverse5ave: public Feature
{
public:
    FeatureReverse5ave();
    ~FeatureReverse5ave();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureReverse5ave::uniqueInstance=NULL;    