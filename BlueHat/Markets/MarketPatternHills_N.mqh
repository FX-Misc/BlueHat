#include "MarketPattern.mqh"
class MarketPatternHills_N : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};