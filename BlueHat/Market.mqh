#include "../BlueHat/globals/_globals.mqh"
class Market
{
public:
    double history[];
    float close[TIMESERIES_DEPTH+1];    //+1: for an extra sample to help to calculate diff[TIMESERIES_DEPTH-1]; close[TIMESERIES_DEPTH] is not used by application
    float diff[TIMESERIES_DEPTH];
    int oldest_available;  //oldest index that has enough history behind itself
public:
    virtual void Initialise(int max_history)=0;
    virtual void UpdateBuffers(int index)=0;
};