#include "Market.mqh"
class MarketPatternMix : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};