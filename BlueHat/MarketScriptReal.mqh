#include "Market.mqh"
class MarketScriptReal : public Market
{
public:
    void Initialise();
    void UpdateBuffers(int index);
};