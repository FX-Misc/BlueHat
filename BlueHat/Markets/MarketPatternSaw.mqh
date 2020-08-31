#include "MarketPattern.mqh"
class MarketPatternSaw : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};