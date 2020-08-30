#include "../globals/_globals.mqh"
class Market
{
protected:
    int current_index;
public:
    double history[];
    double close[];
    double diff_raw[];
    double diff_norm[];
    int oldest_available;  //oldest index that has enough history behind itself
    double diff_norm_factor; //A factor which maps strong diffs to around 1 by multiplication
                                //SOFT_NORMAL is applied after this multiplication
public:
    virtual void Initialise(int max_history)=0;
    virtual void UpdateBuffers(int index)=0;
    virtual void GetIndicators(int hndl, double& buf0[])=0;
};