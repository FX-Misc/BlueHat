#include "MarketPattern.mqh"
class MarketPatternPDiff_N : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};