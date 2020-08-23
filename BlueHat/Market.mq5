#include "Market.mqh"
void Market::InitForScriptRealHistory(void)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    
    CopyClose(ChartSymbol(),ChartPeriod(),0,1000000,history);
    oldest_available = ArraySize(history) - TIMESERIES_DEPTH;
    Print("market init for ",ChartSymbol(),". oldest avail sample=",oldest_available," + depth=",TIMESERIES_DEPTH);
}
void Market::InitForScriptSimulatedData(int len)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    ArrayResize(history,len+TIMESERIES_DEPTH);
    oldest_available = len;
    //TODO: fill in history
}
void Market::UpdateForScript(int index)
{
    ArrayCopy(close,history,0,index,TIMESERIES_DEPTH);
    
}

