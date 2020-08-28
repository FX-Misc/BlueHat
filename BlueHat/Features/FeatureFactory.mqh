#include "/FeatureCheater.mqh"
#include "/FeatureRandom.mqh"
#include "/FeatureBiasPositive.mqh"
#include "/FeatureBiasNegative.mqh"
#include "/FeatureBiasZero.mqh"
#include "/FeatureRepeatLast.mqh"
#include "/Feature3LastDiffsMean.mqh"
 
#include "/../INode.mqh"

class FeatureFactory
{
private:
public:
    INode* FeatureInstance(string name);
};