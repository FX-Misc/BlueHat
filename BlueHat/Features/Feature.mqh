//NOTE: only for testing the NN performance. Not to be used in real training
#include "../INode.mqh"
class Feature : public INode
{
protected:
    float updated_value;
public:
    virtual void Update(const float& raw_close[], const float& d[], int len) = 0; 
    //raw_close is needed for some indicators (e.g. compare to ima), d is diff
    //d[0] and raw_close[0] are for cheater only.
    //TODO: indicators to be created in the feature, send back the handle, receive the value by Update
    //or: get the index by Update and calculate the indicator[index+1]
                            
    float GetNode(void);
    string name;
};