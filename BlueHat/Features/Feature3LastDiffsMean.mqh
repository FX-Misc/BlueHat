//#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "Feature.mqh"
class Feature3LastDiffsMean : public Feature
{
public:
    Feature3LastDiffsMean();
    ~Feature3LastDiffsMean();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* Feature3LastDiffsMean::uniqueInstance=NULL;    