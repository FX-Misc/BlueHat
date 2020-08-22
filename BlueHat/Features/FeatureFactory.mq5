#include "FeatureFactory.mqh"
#include "../globals/assert.mqh"
INode* FeatureFactory::CreateFeature(string name)
{
    INode* feature;
    if(name=="feCheater")
        feature = new FeatureCheater();
    else if(name=="feRandom")
        feature = new FeatureRandom();
    else if(name=="feBiasP")
        feature = new FeatureBiasPositive();
    else if(name=="feBiasN")
        feature = new FeatureBiasNegative();
    else
        feature = NULL;
    assert(feature != NULL, "");
    return feature;
}
