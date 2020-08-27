//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class Feature3LastDiffsMean : public Feature
{
public:
    Feature3LastDiffsMean();
    ~Feature3LastDiffsMean();
    void Update(const float& raw_close[], const float& norm_d[], int len);
};
    