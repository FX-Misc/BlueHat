#include "FeatureFactory.mqh"
#include "../globals/assert.mqh"
INode* FeatureFactory::FeatureInstance(string name)
{
    INode* feature;
    if(name=="feCheater")
        feature = FeatureCheater::Instance();
    else if(name=="feRandom")
        feature = FeatureRandom::Instance();
    else if(name=="feBiasP")
        feature = FeatureBiasPositive::Instance();
    else if(name=="feBiasN")
        feature = FeatureBiasNegative::Instance();
    else if(name=="feBiasZ")
        feature = FeatureBiasZero::Instance();
    else if(name=="feRepeatL")
        feature = FeatureRepeatLast::Instance();
    else if(name=="fe3DiffMean")
        feature = Feature3LastDiffsMean::Instance();
    else
        feature = NULL;
    assert(feature != NULL, "");
    return feature;
}
