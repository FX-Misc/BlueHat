#include "MarketScriptReal.mqh"
void MarketScriptReal::Initialise(int max_history)
{
    ArraySetAsSeries(history, true);  //changes the indexing method of the array; the latest as 0
    ArraySetAsSeries(history_open, true);
    ArraySetAsSeries(history_times, true); 
    ArraySetAsSeries(close, true);  
    ArraySetAsSeries(open, true);  
    ArraySetAsSeries(times, true);  
    ArraySetAsSeries(diff_raw, true);  
    ArraySetAsSeries(diff_norm, true);  
    ArrayResize(diff_raw, TIMESERIES_DEPTH);
    ArrayResize(diff_norm, TIMESERIES_DEPTH);
        
    CSymbolInfo info;
    info.Name(ChartSymbol());
    info.Select();
    tick_convert_factor = (int)MathRound(1/info.TickSize());

    int max = (max_history==0)? iBars(ChartSymbol(),ChartPeriod()) : MathMin(max_history,iBars(ChartSymbol(),ChartPeriod()));
    Print("--bars in history:",max); 
    CopyClose(ChartSymbol(),ChartPeriod(),0,max,history);
    CopyOpen(ChartSymbol(),ChartPeriod(),0,max,history_open);
    CopyTime(ChartSymbol(),ChartPeriod(),0,max,history_times);
    oldest_available = ArraySize(history) - TIMESERIES_DEPTH;
    diff_norm_factor = CalculateDiffNormFactor();
    Print("market init for ",ChartSymbol(),". oldest avail sample=",oldest_available," + depth=",TIMESERIES_DEPTH," norm_factor=",diff_norm_factor," tick_convert=",tick_convert_factor);
}

void MarketScriptReal::UpdateBuffers(int index)
{
    current_index = index;
    ArrayCopy(close,history,0,index,TIMESERIES_DEPTH+1); 
    ArrayCopy(open,history_open,0,index,TIMESERIES_DEPTH+1); 
    ArrayCopy(times,history_times,0,index,TIMESERIES_DEPTH+1); 
    //close[0] is the uncomplete bar in the main loop of EA, the newest but unused bar in the script
    //close[1] is the desired in the main loop.
    //In features, close[0] is for the cheating only, which is equivalent to close[1] main loop
    //same with diff
    
    for(int i=0; i<TIMESERIES_DEPTH; i++)
    {
//        diff_raw[i] = close[i]-close[i+1];
        diff_raw[i] = close[i]-open[i];
        if(!correct_sign)   //reverse inputs for testing
            diff_raw[i] = -diff_raw[i];
        diff_norm[i] = SOFT_NORMAL(diff_raw[i] * diff_norm_factor);
    }
}

void MarketScriptReal::GetIndicators(int hndl, int ind_buff_no, double& buf0[])
{
    assert( CopyBuffer(hndl,ind_buff_no,current_index,TIMESERIES_DEPTH,buf0) >0, "indicator CopyBuffer not successfull");
    if(!correct_sign)   //reverse indicators to test bidirectionality
        for(int i=0; i<TIMESERIES_DEPTH; i++)
            buf0[i]=-buf0[i];

}
double MarketScriptReal::CalculateDiffNormFactor()
{
    int len=MathMin(ArraySize(history),1000);
    double temp=0;
    for(int i=1; i<len-1; i++) 
        temp += MathAbs(history[i]-history_open[i]);
    temp = temp/len;    //average of diffs
    return 0.2/temp;
}
MarketScriptReal::MarketScriptReal(bool sign):correct_sign(sign)
{
}