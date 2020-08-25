#include "../BlueHat/globals/_globals.mqh"
class Market
{
public:
    double history[];
    float close[];
    float diff[];
    int oldest_available;  //oldest index that has enough history behind itself
    float diff_norm_factor; //A factor which maps strong diffs to around 1 by multiplication
                                //SOFT_NORMAL is applied after this multiplication
public:
    virtual void Initialise(int max_history)=0;
    virtual void UpdateBuffers(int index)=0;
    virtual float GetNormalisedDiff(float d)=0;
};