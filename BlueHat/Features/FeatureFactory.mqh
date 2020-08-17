#include "/FeatureCheater.mqh"
#include "/Featurerandom.mqh"
 
#include "/../INode.mqh"

enum features_t
{
    FEATURE_RANDOM,
    FEATURE_CHEATER,
};
 
class FeatureFactory
{
private:
public:
    INode* CreateFeature(features_t fe);
};