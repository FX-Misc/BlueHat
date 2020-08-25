//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class FeatureRepeatLast : public Feature
{
public:
    FeatureRepeatLast();
    ~FeatureRepeatLast();
    void Update(const float& raw_close[], const float& d[], int len);
};
    