#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/Markets/Market.mqh"
#include "../../BlueHat/Markets/MarketFactory.mqh"
#include "../../BlueHat/globals/_globals.mqh"

//#property version   "1.00"
input markets_t market_type=MARKET_SCRIPT_REAL;
input DEBUG_MODE debug_mode=DEBUG_NONE;
input int depth=1000;
input evaluation_method_t evaluation_method = METHOD_ANALOG_DISTANCE;
//+------------------------------------------------------------------+
int OnInit()
{
    double desired;
    Print("Hello from EA");
    MarketFactory mf;
    Market* market = mf.CreateMarket(market_type);
    market.Initialise(depth); //0 for full history
        
    market.UpdateBuffers(0);
    Print("his01:",market.history[0], " ", market.history[1],"close01:",market.close[0], " ", market.close[1]);

    Owner owner();
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
        desired = market.diff_norm[1];
        owner.Train1Epoch(desired);
        owner.quality.UpdateMetrics(desired, owner.softmax.GetNode(), market.tick_convert_factor * market.diff_raw[1]);
        owner.UpdateAxonStats();
        owner.SaveDebugInfo(debug_mode, i, desired, market.diff_raw[1], market.close[1]);
        if( len_div_10 > 0)
            if( (i%len_div_10) == 0)
                print_progress(&owner, 10*(i/len_div_10));
        owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
        //owner.GetAdvice();
        //trade here
    }  
        
    owner.db.CloseDB();
//    print_progress(&owner,100);
    delete market;
    Print("Bye");
    return(INIT_SUCCEEDED);
}
void print_progress(Owner* owner, int progress)
{
    Print("..",progress,"%");
    Print(owner.GetAxonsReport());
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
    Print("DeInit");
}
//+------------------------------------------------------------------+
void OnTick()
{
}
//+------------------------------------------------------------------+
void OnTrade()
{
    Print("Trade event");   
}
double OnTester()
{
    Print("Tester finished");
    double ret=0.0;

    return(ret);
}
//+------------------------------------------------------------------+
