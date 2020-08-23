#include "Market.mqh"
void Market::InitForScript(void)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    
    CopyClose(ChartSymbol(),ChartPeriod(),0,1000000,history);
    oldest_available = ArraySize(history) - TIMESERIES_DEPTH;
    Print("market init for ",ChartSymbol(),". oldest avail sample=",oldest_available," + depth=",TIMESERIES_DEPTH);
}
