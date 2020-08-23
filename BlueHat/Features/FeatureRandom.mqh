//NOTE: only for testing. Not to be used in real training
#include "../INode.mqh"
#include "Feature.mqh"
#include "../globals/_globals.mqh"
class FeatureRandom : public Feature
{
public:
    FeatureRandom();
    ~FeatureRandom();
    void Update(const float& c[], int len);
};
    