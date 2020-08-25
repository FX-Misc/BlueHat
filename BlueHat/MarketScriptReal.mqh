#include "Market.mqh"
class MarketScriptReal : public Market
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
    float GetNormalisedDiff(float d);
};