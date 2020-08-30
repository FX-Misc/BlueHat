#include "Market.mqh"
class MarketPattern : public Market
{
public:
    void GetIndicators(int hndl, int ind_buff_no, double& buf0[]);
};