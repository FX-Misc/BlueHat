#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/Markets/Market.mqh"
#include "../../BlueHat/Markets/MarketFactory.mqh"
#include "../../BlueHat/globals/_globals.mqh"

//#property version   "1.00"
//+------------------------------------------------------------------+
int OnInit()
{
    Print("Hello from EA");
    MarketFactory mf();
    //mf.CreateMarket(0);
    //Owner owner();
    return(INIT_SUCCEEDED);
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
