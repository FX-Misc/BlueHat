#include "Pattern.mqh"

bar_result_t Pattern::giveBar(int BarNo, double diff)
{
    Print("pattern:",ID," bar:", BarNo, " diff",diff);
    return BAR_SLEEP;
}

void Pattern::updateMidday(double close)
{
    
}

void Pattern::updateEndday(double close)
{
}

Pattern::Pattern(int id)
{
    ID=id;
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
    status=STATUS_SLEEP;
}

