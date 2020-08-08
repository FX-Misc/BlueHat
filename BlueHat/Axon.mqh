#include "INode.mqh"
class Axon
{
private:
    INode* pnode;
    float gain;
    float degradaion_rate;
    float growth_rate;
public:
    Axon(INode* pn, float deg_r, float gr_r);
    bool active;
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    
};
