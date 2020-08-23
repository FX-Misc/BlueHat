//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureRepeatLast : public Feature
{
public:
    FeatureRepeatLast();
    ~FeatureRepeatLast();
    void Update(const float& c[], int len);
};
    