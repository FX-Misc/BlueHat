#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureMACDBinary: public Feature
{
private:
    int handle;
    double macd_main[];
    double macd_signal[];
public:
    FeatureMACDBinary();
    ~FeatureMACDBinary();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureMACDBinary::uniqueInstance=NULL;    