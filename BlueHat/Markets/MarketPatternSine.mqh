#include "MarketPattern.mqh"
class MarketPatternSine : public MarketPattern
{
public:
    void Initialise(int max_history);
    void UpdateBuffers(int index);
};