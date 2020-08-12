#include "/FeatureCheater.mqh"
 
#include "/../INode.mqh"

enum features_t
{
    FEATURE_CHEATER,
};
 
class FeatureFactory
{
private:
public:
    FeatureFactory();
    INode* CreateFeature(features_t fe);
};