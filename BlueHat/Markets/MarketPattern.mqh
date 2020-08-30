#include "Market.mqh"
class MarketPattern : public Market
{
public:
    void GetIndicators(int hndl, double& buf0[]);
};