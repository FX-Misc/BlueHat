#include "../globals/_globals.mqh"
#include "../INode.mqh"
#include "../Features/Feature.mqh"
class FeatureMACD: public Feature
{
private:
    int handle;
    double macd_main[];
    double macd_signal[];
public:
    FeatureMACD();
    ~FeatureMACD();
    void Update(const double& raw_close[], const double& norm_d[], int len);
    static Feature* Instance();
    static Feature* uniqueInstance;
};
Feature* FeatureMACD::uniqueInstance=NULL;    