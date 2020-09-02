#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureIMAFast: public Feature
{
private:
    int IMA_handle;
    double IMA[];
public:
    FeatureIMAFast();
    ~FeatureIMAFast();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureIMAFast::uniqueInstance=NULL;    