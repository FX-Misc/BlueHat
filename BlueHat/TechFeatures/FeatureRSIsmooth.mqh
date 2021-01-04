#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureRSIsmooth: public Feature
{
private:
    int handle;
    double rsi[];
public:
    FeatureRSIsmooth();
    ~FeatureRSIsmooth();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureRSIsmooth::uniqueInstance=NULL;    