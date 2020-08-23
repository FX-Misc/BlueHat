#include "../BlueHat/globals/_globals.mqh"
class Market
{
public:
    double history[];
    float close[TIMESERIES_DEPTH];
    float diff[TIMESERIES_DEPTH];
    int oldest_available;  //oldest index that has enough history behind itself
public:
    void InitForScript();
};