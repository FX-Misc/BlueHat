#include "INode.mqh"
#include "globals/_globals.mqh"

enum flag_grow_t
{
    FLAG_GROW,
    FLAG_DEGROW,
    FLAG_KEEP
};
class Axon
{
private:
    INode* pnode;
    float gain;             //0.001...10
    float degradaion_rate;  //1 for no degradation. should be less than 1
    float growth_rate;  //should be greater than 0
    float min;  //the floor of the Axon, typically 0.001   
    float max;  //the ceiling of the Axon, typically 10
public:
    Axon(INode* pn, int node_id, float deg_r, float gr_r, float m, float M);
    int node_id;
    bool active;    //It will be used later, to disbale useless Axons on-the-go rather than after manual analysis
    flag_grow_t grow_temp_flag;    //a notepad for triner, to mark the axons to grow after all evaluations
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    float GetGainedValueN() const;
    float GetGain();
    
};
