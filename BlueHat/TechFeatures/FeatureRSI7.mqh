#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureRSI7: public Feature
{
private:
    int handle;
    double rsi[];
public:
    FeatureRSI7();
    ~FeatureRSI7();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureRSI7::uniqueInstance=NULL;    