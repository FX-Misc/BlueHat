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
    double gain;             //0.001...10
    bool negate;
    double degradaion_rate;  //1 for no degradation. should be less than 1
    double growth_rate;  //should be greater than 0
    double min;  //the floor of the Axon, typically 0.001   
    double max;  //the ceiling of the Axon, typically 10
    double hist_sum;
    int hist_cnt;
public:
    INode* pnode;
    Axon(INode* pn, int node_id, bool neg, bool f, double init, double deg_r, double gr_r, double m, double M);
    int node_id;
    bool freeze;    //It will be used later, to disbale useless Axons on-the-go rather than after manual analysis
    flag_grow_t grow_temp_flag;    //a notepad for triner, to mark the axons to grow after all evaluations
    void GainGrow();
    void GainDeGrow();
    void GainDegrade();
    double GetGainedValueN() const;
    double GetGain();
    void ResetGain();
    double GetAve();    
    void UpdateAve();    
};
