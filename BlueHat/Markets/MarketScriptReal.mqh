#include "Market.mqh"
class MarketScriptReal : public Market
{
private:
    bool correct_sign;
    double CalculateDiffNormFactor();
public:
    MarketScriptReal(bool sign);
    void Initialise(int max_history);
    void UpdateBuffers(int index);
    void GetIndicators(int hndl, int ind_buff_no, double& buf0[]);
};