#include "/FeatureCheater.mqh"
#include "/FeatureRandom.mqh"
#include "/FeatureBiasPositive.mqh"
#include "/FeatureBiasNegative.mqh"
#include "/FeatureBiasZero.mqh"
 
#include "/../INode.mqh"

class FeatureFactory
{
private:
public:
    INode* CreateFeature(string name);
};