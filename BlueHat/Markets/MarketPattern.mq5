#include "MarketPattern.mqh"

void MarketPattern::GetIndicators(int hndl, double& buf0[])
{
    for(int i=0; i<TIMESERIES_DEPTH; i++)
        buf0[i]=0;    
}