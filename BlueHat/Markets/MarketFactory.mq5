#include "MarketFactory.mqh"
Market* MarketFactory::CreateMarket(markets_t type)
{
    switch(type)
    {
        case MARKET_RANDOM:
            return new MarketRandom();
        case MARKET_SCRIPT_REAL:
            return new MarketScriptReal();
        default:
            assert(false, "wrong market type");
            return NULL;
    }
}
