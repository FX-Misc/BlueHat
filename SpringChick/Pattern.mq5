#include "Pattern.mqh"

bar_result_t Pattern::giveBar(int BarNo, double diff)
{
    if(BarNo==-1)
    {
        assert(status==STATUS_SLEEP, "status not sleep at the start");
        if(openBar)
            if(diff>0)
            {
                status=STATUS_CANDIDATE_DIRECT;
                return BAR_MORE_PLZ;
            }
            else
            {
                status=STATUS_CANDIDATE_REVERSE;
                return BAR_MORE_PLZ;
            }
        status=STATUS_CANDIDATE_EITHER;
        return BAR_MORE_PLZ;
    }
    bool d = (diff>=0);
    switch(status)
    {
        case STATUS_SLEEP:
        case STATUS_ITS_ME_DIRECT:
        case STATUS_ITS_ME_REVERSE:
            return BAR_SLEEP;
            break;
        case STATUS_CANDIDATE_DIRECT:
            if(BarNo == DecisionBar)
            {
                status = STATUS_ITS_ME_DIRECT;
                return BAR_ITS_ME_DIRECT;
            }
            if( (bars[BarNo]&&d) || (!bars[BarNo]&&!d) )
                return BAR_MORE_PLZ;
            else
            {
                status = STATUS_SLEEP;
                return BAR_NOT_ME;
            }
            break;
        case STATUS_CANDIDATE_REVERSE:
            if(BarNo == DecisionBar)
            {
                status = STATUS_ITS_ME_REVERSE;
                return BAR_ITS_ME_REVERSE;
            }
            if( (bars[BarNo]&&!d) || (!bars[BarNo]&&d) )
                return BAR_MORE_PLZ;
            else
            {
                status = STATUS_SLEEP;
                return BAR_NOT_ME;
            }
            break;
        case STATUS_CANDIDATE_EITHER:
            assert(BarNo==0,"expected bar 0 when either");
            if( (bars[BarNo]&&d) || (!bars[BarNo]&&!d) )
            {
                status=STATUS_CANDIDATE_DIRECT;
                return BAR_MORE_PLZ;
            }
            else
            {
                status=STATUS_CANDIDATE_REVERSE;
                return BAR_MORE_PLZ;
            }
            break;
        default:
            assert(0,"which state is it?");
            return BAR_SLEEP;
    }
}

void Pattern::updateMidday(double close)
{
    
}

void Pattern::updateEndday(double close)
{
    switch(status)
    {
        case STATUS_ITS_ME_DIRECT:
            //!!TODO: evaluate
            status = STATUS_SLEEP;
            break;
        case STATUS_ITS_ME_REVERSE:
            //!!TODO: evaluate
            status = STATUS_SLEEP;
            break;
        case STATUS_SLEEP:
            break;
        default:
            assert(0,"unexpected status at Endday");
            break;
    }
}

Pattern::Pattern(int id, int len)
{
    ID=id;
    DecisionBar = len - 1;
    QMidday.DirectionShort=0;
    QMidday.DirectionLong=0;
    QMidday.ProfitLong=0;
    QMidday.ProfitShort=0;
    QMidday.count=0;
    QMidday.dirCorrectCnt=0;
    QEndday.DirectionShort=0;
    QEndday.DirectionLong=0;
    QEndday.ProfitLong=0;
    QEndday.ProfitShort=0;
    QEndday.count=0;
    QEndday.dirCorrectCnt=0;
    assert(ID<(1<<(PatternLen+1)) && ID>=0,"invalid ID");
    openBar = (ID&0x01 == 1);
    for(int i=1;i<len;i++)
        bars[i-1] = ((ID&(1<<i)) != 0);
    status=STATUS_SLEEP;
}

