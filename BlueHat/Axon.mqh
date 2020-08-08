#include "IFeature.mqh"
class Axon
{
private:
    IFeature* pfeature;
    float gain;
    float degradaion_rate;
    float growth_rate;
public:
    Axon(IFeature* pf, float deg_r, float gr_r);
    bool active;
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    
};
