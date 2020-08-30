#include "Market.mqh"
class MarketPatternHills_N : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};