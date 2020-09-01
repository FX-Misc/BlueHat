#include "MarketPattern.mqh"
class MarketRandom : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};