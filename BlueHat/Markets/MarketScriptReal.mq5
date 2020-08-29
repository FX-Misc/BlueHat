#include "MarketScriptReal.mqh"
void MarketScriptReal::Initialise(int max_history)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    ArraySetAsSeries(close, true);  
    ArraySetAsSeries(diff_raw, true);  
    ArraySetAsSeries(diff_norm, true);  
    ArrayResize(diff_raw, TIMESERIES_DEPTH);
    ArrayResize(diff_norm, TIMESERIES_DEPTH);
        
    int max = (max_history==0)? iBars(ChartSymbol(),ChartPeriod()) : max_history;
    Print("--bars in history:",max); 
    CopyClose(ChartSymbol(),ChartPeriod(),0,max,history);
    oldest_available = ArraySize(history) - TIMESERIES_DEPTH;
    diff_norm_factor = 1000;    //TODO: calculate based on the reverse of a typical strong diff, 1000 for eurusd/1h as a sample 
    Print("market init for ",ChartSymbol(),". oldest avail sample=",oldest_available," + depth=",TIMESERIES_DEPTH," norm_factor=",diff_norm_factor);
}

void MarketScriptReal::UpdateBuffers(int index)
{
    ArrayCopy(close,history,0,index,TIMESERIES_DEPTH+1); 
    //close[0] is the uncomplete bar in the main loop of EA, the newest but unused bar in the script
    //close[1] is the desired in the main loop.
    //In features, close[0] is for the cheating only, which is equivalent to close[1] main loop
    //same with diff
    
    for(int i=0; i<TIMESERIES_DEPTH; i++)
    {
        diff_raw[i] = close[i]-close[i+1];
        diff_norm[i] = SOFT_NORMAL(diff_raw[i] * diff_norm_factor);
    }
}
