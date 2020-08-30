#include "Market.mqh"
class MarketRandom : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};