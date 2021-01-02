//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
#include "../Markets/Market.mqh"
class Feature : public INode
{
protected:
    double updated_value;
public:
    virtual void Update(const double& raw_close[], const double& norm_d[], int len) = 0; 
    //raw_close is needed for some indicators (e.g. compare to ima), norm_d is normalised diff
    //TODO: raw_open[0] is better than raw_close[1]. However, raw_close is nt used regularly
    //norm_d[0] and raw_close[0] are for cheater only.
    //TODO: indicators to be created in the feature, send back the handle, receive the value by Update
    //or: get the index by Update and calculate the indicator[index+1]                         
    double GetNode(void);
    
    Market* market;

};