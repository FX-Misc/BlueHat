#include "Market.mqh"
class MarketPatternSaw : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};