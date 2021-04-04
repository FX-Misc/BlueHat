#include "Market.mqh"
#include "MarketScriptReal.mqh"
enum markets_t
{
    MARKET_SCRIPT_REAL,
    MARKET_RANDOM,
    MARKET_PATTERN_SAW,
    MARKET_PATTERN_SINE,
    MARKET_PATTERN_HILLS_N,
    MARKET_PATTERN_PDIFF_N,
    MARKET_PATTERN_MIX,
};
class MarketFactory
{
public:
    Market* CreateMarket(markets_t type, bool correct_sign);
};