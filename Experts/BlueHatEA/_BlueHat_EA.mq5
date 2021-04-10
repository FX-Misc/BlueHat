#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/ChickOwner.mqh"
#include "../../BlueHat/Markets/Market.mqh"
#include "../../BlueHat/Markets/MarketFactory.mqh"
#include "../../BlueHat/globals/_globals.mqh"

//#property version   "1.00"
input bool skip_1st_monday=false;
input bool skip_1st_morning=false;
input markets_t market_type=MARKET_SCRIPT_REAL;
input DEBUG_MODE debug_mode=DEBUG_NONE;
input double min_softmax=0.001;
input int depth=1000;
input evaluation_method_t evaluation_method = METHOD_DIRECTION;
input axon_value_t axon_value_method = AXON_METHOD_GAIN;

input int PatternLen=3;
input int MiddayBar=6; //6 for M15
input int EnddayBar=11; 
input int shortPeriod=5;    //shortPeriod 5 normal. 0 only last value
input int longPeriod=20;     //longPeriod 20 normal. 1 50-50

int   Pattern::shortP=shortPeriod;
int   Pattern::longP=longPeriod;

MarketFactory mf;
double ea_desired,ea_desired_scaled;
Owner owner;
Market* market;
datetime lastbar_timeopen;
double ea_return;
ChickOwner* chickowner;
int OnInit()
{
    Print("Hello from EA");
    ea_return = 0;

    market = mf.CreateMarket(market_type, true);
    market.Initialise(depth); //0 for full history
    chickowner = new ChickOwner(PatternLen);
    chickowner.LoadPatterns(market);
        
//    market.UpdateBuffers(0);
//    Print("his01:",market.history[0], " ", market.history[1],"close01:",market.close[0], " ", market.close[1]);

    owner.db.OpenDB();
    owner.CreateNN(market, axon_value_method, min_softmax);
    owner.CreateDebugDB(debug_mode);
    owner.CreateStateDB();
    





    Print("init done");
    return(INIT_SUCCEEDED);
}
void GoThroughHistory()
{
    Print("GoThroughHistory");

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
        ea_desired_scaled = market.diff_raw[1] * market.diff_norm_factor;
        if(!early_morning_skip(market.times[1], skip_1st_monday, skip_1st_morning))
        {
            owner.quality.UpdateMetrics(ea_desired, owner.softmax.GetNode(), market.tick_convert_factor * market.diff_raw[1]);
            owner.Train1Epoch(ea_desired, ea_desired_scaled, evaluation_method);
        }
        owner.UpdateAxonStats();
        owner.SaveDebugInfo(debug_mode, i, ea_desired, market.diff_raw[1], market.close[1], market.times[1]);
        if( len_div_10 > 0)
            if( (i%len_div_10) == 0)
                print_progress(&owner, 10*(i/len_div_10));
        owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
        //owner.GetAdvice();
        //trade here
        chickowner.UpdateInput(market.close, market.diff_raw, market.open, market.times);
    }  
    chickowner.report();        



    
    Print("History done");
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
bool HistoryDone=false;
int CurrPos=0;
void OnTick()
{
    if(!HistoryDone)
    {
        HistoryDone=true;
        GoThroughHistory();
        return;
    }
    if(isNewBar())
    {
//!!        ClosePositionsByBars(0);


//        if(i%400==0)//Temporary: reset axons priodically
//            owner.ResetAxons();
        market.UpdateBuffers(0);
        //Note: here, close[0] is not used at all just for compatiblity with EA, where close[0] is the uncompleted bar
        //Note: index+1 is the last completed Bar, so the one that we need
        //If not going through the history, do UpdateInput(+2) before the loop; then the loop uses close(+1) as desired to train the 1st time
        ea_desired = market.diff_norm[1];
        ea_desired_scaled = market.diff_raw[1] * market.diff_norm_factor;
        owner.Train1Epoch(ea_desired, ea_desired_scaled, evaluation_method);
        owner.quality.UpdateMetrics(ea_desired, owner.softmax.GetNode(), market.tick_convert_factor * market.diff_raw[1]);
        owner.UpdateAxonStats();
//!!        owner.SaveDebugInfo(debug_mode, 0, ea_desired, market.diff_raw[1], market.close[1], market.times[1]);
//        if( len_div_10 > 0)
//            if( (i%len_div_10) == 0)
//                print_progress(&owner, 10*(i/len_div_10));
        owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
        Print("tick on ",lastbar_timeopen);

        chickowner.UpdateInput(market.close, market.diff_raw, market.open, market.times);

#define  TRADEONCHICK
#ifdef TRADEONNN
        double soft=owner.softmax.GetNode();
        Print("soft=",soft, "dir:",DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_LONG),5));
        if(soft>0.001)
            Buy(0.1);
        else if(soft<-0.001)
            Sell(0.1);
#endif
#ifdef TRADEONCHICK
        int signal = chickowner.GetRoughSignal(CurrPos);
        if(signal==1)
        {
            Buy(0.1);
            CurrPos++;
        }
        if(signal==-1)
        {
            Sell(0.1);
            CurrPos--;
        }
#endif

        ea_return++;
    }
}
//+------------------------------------------------------------------+
void OnTrade()
{
//    Print("Trade event");   
}
double OnTester()
{
    Print("Tester finished");
    owner.db.CloseDB();
    delete market;
    Print("DeInit");
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
void ClosePositionsByBars(int holdtimebars,ulong deviation=10,ulong  magicnumber=0)
  {
   int total=PositionsTotal(); // number of open positions   
//--- iterate over open positions
   for(int i=total-1; i>=0; i--)
     {
      //--- position parameters
      ulong  position_ticket=PositionGetTicket(i);                                      // position ticket
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // symbol 
      ulong  magic=PositionGetInteger(POSITION_MAGIC);                                  // position MagicNumber
      datetime position_open=(datetime)PositionGetInteger(POSITION_TIME);               // position open time
      int bars=iBarShift(_Symbol,PERIOD_CURRENT,position_open)+1;                       // how many bars ago a position was opened
 
      //--- if a position's lifetime is already large, while MagicNumber and a symbol match
      if(bars>holdtimebars && magic==magicnumber && position_symbol==_Symbol)
        {
         int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);           // number of decimal places
         double volume=PositionGetDouble(POSITION_VOLUME);                              // position volume
         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE); // position type
         string str_type=StringSubstr(EnumToString(type),14);
         StringToLower(str_type); // lower the text case for correct message formatting
         PrintFormat("Close position #%d %s %s %.2f",
                     position_ticket,position_symbol,str_type,volume);
         //--- set an order type and sending a trade request
         if(type==POSITION_TYPE_BUY)
            MarketOrder(ORDER_TYPE_SELL,volume,deviation,magicnumber,position_ticket);
         else
            MarketOrder(ORDER_TYPE_BUY,volume,deviation,magicnumber,position_ticket);
        }
     }
  }
bool Buy(double volume,ulong deviation=10,ulong  magicnumber=0)
  {
//--- buy at a market price
   return (MarketOrder(ORDER_TYPE_BUY,volume,deviation,magicnumber));
  }
//+------------------------------------------------------------------+
//| Sell at a market price with a specified volume                   |
//+------------------------------------------------------------------+
bool Sell(double volume,ulong deviation=10,ulong  magicnumber=0)
  {
//--- sell at a market price
   return (MarketOrder(ORDER_TYPE_SELL,volume,deviation,magicnumber));
  }
bool MarketOrder(ENUM_ORDER_TYPE type,double volume,ulong slip,ulong magicnumber,ulong pos_ticket=0)
  {
//--- declaring and initializing structures
   MqlTradeRequest request={0};
   MqlTradeResult  result={0};
   double price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
   if(type==ORDER_TYPE_BUY)
      price=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
//--- request parameters
   request.action   =TRADE_ACTION_DEAL;                     // trading operation type
   request.position =pos_ticket;                            // position ticket if closing
   request.symbol   =Symbol();                              // symbol
   request.volume   =volume;                                // volume 
   request.type     =type;                                  // order type
   request.price    =price;                                 // trade price
   request.deviation=slip;                                  // allowable deviation from the price
   request.magic    =magicnumber;                           // order MagicNumber
//--- send a request
   if(!OrderSend(request,result))
     {
      //--- display data on failure
      PrintFormat("OrderSend %s %s %.2f at %.5f error %d",
                  request.symbol,EnumToString(type),volume,request.price,GetLastError());
      return (false);
     }
//--- inform of a successful operation
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   return (true);
  }
bool early_morning_skip(datetime t, bool skip_monday, bool skip_morning)
{
    MqlDateTime dt;
    TimeToStruct(t, dt);
    if(skip_morning)
        if(dt.hour==0 && dt.min==0)
            return true;
    if(skip_monday)
        if(dt.day_of_week==1 && dt.hour==0 && dt.min==0)
            return true;
    return false;
}