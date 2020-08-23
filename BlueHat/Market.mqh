#include "../BlueHat/globals/_globals.mqh"
class Market
{
public:
    double history[];
    float close[];
    float diff[];
    int oldest_available;  //oldest index that has enough history behind itself
public:
    virtual void Initialise(int max_history)=0;
    virtual void UpdateBuffers(int index)=0;
};