#include "/FeatureCheater.mqh"
#include "/FeatureRandom.mqh"
#include "/FeatureBiasPositive.mqh"
#include "/FeatureBiasNegative.mqh"
#include "/FeatureRepeatLast.mqh"
 
#include "/../INode.mqh"

class FeatureFactory
{
private:
public:
    INode* CreateFeature(string name);
};