#include "MarketScriptReal.mqh"
void MarketScriptReal::Initialise(void)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    
    int max = iBars(ChartSymbol(),ChartPeriod());
    Print("--bars in history:",max); 
    CopyClose(ChartSymbol(),ChartPeriod(),0,max,history);
    oldest_available = ArraySize(history) - TIMESERIES_DEPTH;
    Print("market init for ",ChartSymbol(),". oldest avail sample=",oldest_available," + depth=",TIMESERIES_DEPTH);
}
//void Market::InitForScriptSimulatedData(int len)
//{
 //   ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
//    ArrayResize(history,len+TIMESERIES_DEPTH);
//    oldest_available = len;
    //TODO: fill in history
//}
void MarketScriptReal::UpdateBuffers(int index)
{
    ArrayCopy(close,history,0,index,TIMESERIES_DEPTH+1); //Still, close[0] is for cheating
    
    for(int i=0; i<TIMESERIES_DEPTH; i++)
    {
        diff[i]=close[i]-close[i+1];    //TODO: normalisation
    }
    
}

