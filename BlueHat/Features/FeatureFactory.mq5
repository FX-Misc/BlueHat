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
        case FEATURE_BIAS_POSITIVE:
            feature = new FeatureBiasPositive();
            break;
        case FEATURE_BIAS_NEGATIVE:
            feature = new FeatureBiasNegative();
            break;
        default:
            feature = NULL;
            break;
    }
    assert(feature != NULL, "");
    return feature;
}
