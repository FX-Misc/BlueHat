#include "FeatureFactory.mqh"
#include "../globals/assert.mqh"
INode* FeatureFactory::CreateFeature(features_t fe)
{
    INode* feature;
    switch(fe)
    {
        case FEATURE_CHEATER:
            feature = new FeatureCheater();
            break;
        case FEATURE_RANDOM:
            feature = new FeatureRandom();
            break;
        default:
            feature = NULL;
            break;
    }
    assert(feature != NULL, "");
    return feature;
}
