#include "Market.mqh"
class MarketPatternSine : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};