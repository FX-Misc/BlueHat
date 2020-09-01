#include "MarketPattern.mqh"
class MarketPatternMix : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};