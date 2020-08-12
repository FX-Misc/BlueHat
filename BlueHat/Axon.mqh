#include "INode.mqh"
#include "IAxonTrain.mqh"
class Axon : public IAxonTrain, INode
{
private:
    INode* pnode;
    float gain;             //-1..+1 starts at 0
    float degradaion_rate;  //1 for no degradation. should be less than 1
    float growth_rate;  //should be greater than 0
public:
    Axon(INode* pn, float deg_r, float gr_r);
    ~Axon();
    bool active;    //It will be used later, to disbale useless Axons on-the-go rather than after manual analysis
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    float GetGainedValue() const;
    
};
