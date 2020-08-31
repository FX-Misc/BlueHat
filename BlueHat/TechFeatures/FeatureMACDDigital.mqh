#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureMACDDigital: public Feature
{
private:
    int handle;
    double macd_main[];
    double macd_signal[];
public:
    FeatureMACDDigital();
    ~FeatureMACDDigital();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureMACDDigital::uniqueInstance=NULL;    