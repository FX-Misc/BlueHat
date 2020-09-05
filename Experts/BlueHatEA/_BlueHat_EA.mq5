#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/Markets/Market.mqh"
#include "../../BlueHat/Markets/MarketFactory.mqh"
#include "../../BlueHat/globals/_globals.mqh"

//#property version   "1.00"
input markets_t market_type=MARKET_SCRIPT_REAL;
input DEBUG_MODE debug_mode=DEBUG_NORMAL;
input int depth=100;
input evaluation_method_t evaluation_method = METHOD_ANALOG_DISTANCE;
//+------------------------------------------------------------------+
MarketFactory mf;
double ea_desired;
Owner owner;
Market* market;
datetime lastbar_timeopen;
double ea_return;
int OnInit()
{
    Print("Hello from EA");
    ea_return = 0;
    market = mf.CreateMarket(market_type);
    market.Initialise(depth); //0 for full history
        
    market.UpdateBuffers(0);
    Print("his01:",market.history[0], " ", market.history[1],"close01:",market.close[0], " ", market.close[1]);

    owner.db.OpenDB();
    owner.CreateNN(evaluation_method, market);
    owner.CreateDebugDB(debug_mode);
    owner.CreateStateDB();
    
    market.UpdateBuffers(market.oldest_available);
    owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
    int len_div_10=(market.oldest_available-1)/10;
    for(int i=market.oldest_available-1; i>=0; i--)
    {
//        if(i%400==0)//Temporary: reset axons priodically
//            owner.ResetAxons();
        market.UpdateBuffers(i);
        //Note: here, close[0] is not used at all just for compatiblity with EA, where close[0] is the uncompleted bar
        //Note: index+1 is the last completed Bar, so the one that we need
        //If not going through the history, do UpdateInput(+2) before the loop; then the loop uses close(+1) as desired to train the 1st time
        ea_desired = market.diff_norm[1];
        owner.Train1Epoch(ea_desired);
        owner.quality.UpdateMetrics(ea_desired, owner.softmax.GetNode(), market.tick_convert_factor * market.diff_raw[1]);
        owner.UpdateAxonStats();
        owner.SaveDebugInfo(debug_mode, i, ea_desired, market.diff_raw[1], market.close[1]);
        if( len_div_10 > 0)
            if( (i%len_div_10) == 0)
                print_progress(&owner, 10*(i/len_div_10));
        owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
        //owner.GetAdvice();
        //trade here
    }  
    Print("init done");
    return(INIT_SUCCEEDED);
}
void print_progress(Owner* _owner, int progress)
{
    Print("..",progress,"%");
    Print(_owner.GetAxonsReport());
    Print("Quality metrics, profit= ",DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_SHORT),1)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_LONG),1)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_ALLTIME),1)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_AVEALL),1));
    Print("Quality metrics, Diff= ",DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_SHORT),5)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_LONG),5)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_ALLTIME),4));
    Print("Quality metrics, Direction= ",DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_SHORT),5)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_LONG),5)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_ALLTIME),1),"%");
}

void OnDeinit(const int reason)
{
        
    owner.db.CloseDB();
    delete market;
    Print("DeInit");
}
//+------------------------------------------------------------------+
void OnTick()
{
    if(isNewBar())
    {
        Print("tick on ",lastbar_timeopen);
        ea_return++;
    }
}
//+------------------------------------------------------------------+
void OnTrade()
{
    Print("Trade event");   
}
double OnTester()
{
    Print("Tester finished");
    return(ea_return);
}
//+------------------------------------------------------------------+
bool isNewBar(const bool print_log=true)
{
    static datetime bartime=0; // store open time of the current bar
    //--- get open time of the zero bar
    datetime currbar_time=iTime(_Symbol,_Period,0);
    //--- if open time changes, a new bar has arrived
    if(bartime!=currbar_time)
    {
        bartime=currbar_time;
        lastbar_timeopen=bartime;
        //--- display data on open time of a new bar in the log      

        //!!log for testing
        if(!(MQLInfoInteger(MQL_OPTIMIZATION)||MQLInfoInteger(MQL_TESTER)))
        {
            //--- display a message with a new bar open time
            PrintFormat("%s: new bar on %s %s opened at %s",__FUNCTION__,_Symbol,
                     StringSubstr(EnumToString(_Period),7),
                     TimeToString(TimeCurrent(),TIME_SECONDS));
            //--- get data on the last tick
            MqlTick last_tick;
            if(!SymbolInfoTick(Symbol(),last_tick))
                Print("SymbolInfoTick() failed, error = ",GetLastError());
            //--- display the last tick time up to milliseconds
            PrintFormat("Last tick was at %s.%03d",
                     TimeToString(last_tick.time,TIME_SECONDS),last_tick.time_msc%1000);
        }
        //--- we have a new bar
        return (true);
    }
    //--- no new bar
    return (false);
}