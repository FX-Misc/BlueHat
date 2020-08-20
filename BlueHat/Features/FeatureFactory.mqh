#include "/FeatureCheater.mqh"
#include "/FeatureRandom.mqh"
#include "/FeatureBiasPositive.mqh"
#include "/FeatureBiasNegative.mqh"
 
#include "/../INode.mqh"

enum features_t
{
    FEATURE_RANDOM,
    FEATURE_CHEATER,
    FEATURE_BIAS_POSITIVE,
    FEATURE_BIAS_NEGATIVE,
};
 
class FeatureFactory
{
private:
public:
    INode* CreateFeature(features_t fe);
};