#include "Market.mqh"
#include "MarketRandom.mqh"
#include "MarketScriptReal.mqh"
enum markets_t
{
    MARKET_RANDOM,
    MARKET_SCRIPT_REAL,
};
class MarketFactory
{
public:
    Market* CreateMarket(markets_t type);
};