#include "MarketFactory.mqh"
Market* MarketFactory::CreateMarket(markets_t type)
{
    switch(type)
    {
        case MARKET_RANDOM:
            return new MarketRandom();
        case MARKET_SCRIPT_REAL:
            return new MarketScriptReal();
        case MARKET_PATTERN_SAW:
            return new MarketPatternSaw();
        case MARKET_PATTERN_SINE:
            return new MarketPatternSine();
        case MARKET_PATTERN_HILLS_N:
            return new MarketPatternHills_N();
        case MARKET_PATTERN_PDIFF_N:
            return new MarketPatternPDiff_N();
        case MARKET_PATTERN_MIX:
            return new MarketPatternMix();
        default:
            assert(false, "wrong market type");
            return NULL;
    }
}
