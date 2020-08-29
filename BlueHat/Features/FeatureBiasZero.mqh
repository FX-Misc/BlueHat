//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureBiasZero : public Feature
{
public:
    FeatureBiasZero();
    ~FeatureBiasZero();
    void Update(const float& raw_close[], const float& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureBiasZero::uniqueInstance=NULL;    