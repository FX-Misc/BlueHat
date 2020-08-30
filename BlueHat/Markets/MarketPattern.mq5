#include "MarketPattern.mqh"

void MarketPattern::GetIndicators(int hndl, int ind_buff_no, double& buf0[])
{
    for(int i=0; i<TIMESERIES_DEPTH; i++)
        buf0[i]=0;    
}