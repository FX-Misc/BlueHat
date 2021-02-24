#include "./globals/_globals.mqh"
#include <Trade\SymbolInfo.mqh>
class Market
{
//protected:
public:
    int current_index;
    double history[];
    double history_open[];
public:
    datetime history_times[];
    datetime history_volume[];
    double close[];
    double open[];
    double volume[];
    datetime times[];
    double diff_raw[];
    double diff_norm[];
    int oldest_available;  //oldest index that has enough history behind itself
    int tick_convert_factor;    //multiply diff by this to convert to ticks. a pip = 10 ticks
    double diff_norm_factor; //A factor which maps strong diffs to around 1 by multiplication
                                //SOFT_NORMAL is applied after this multiplication
public:
    virtual void Initialise(int max_history)=0;
    virtual void UpdateBuffers(int index)=0;
    virtual void GetIndicators(int hndl, int ind_buff_no, double& buf0[])=0;
};