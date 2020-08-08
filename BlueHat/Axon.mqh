#include "INode.mqh"
#include "IAxonTrain.mqh"
class Axon : public IAxonTrain
{
private:
    INode* pnode;
    float gain;             //-1..+1 starts at 0
    float degradaion_rate;  //1 for no degradation. should be less than 1
    float growth_rate;  //should be greater than 0
public:
    Axon(INode* pn, float deg_r, float gr_r);
    bool active;
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    
};
