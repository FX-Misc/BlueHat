#include "Pattern.mqh"

bar_result_t Pattern::giveBar(int BarNo, double diff)
{
    if(BarNo==-1)
    {
        if(status!=STATUS_SLEEP)    //Last day was a short day
        {
            Print("short day");
            status=STATUS_SLEEP;
        }
        if( (openBar && diff>0) || (!openBar && diff<0))
        {
            status=STATUS_CANDIDATE_DIRECT;
            return BAR_MORE_PLZ;
        }
        else
        {
            status=STATUS_SLEEP;
            return BAR_NOT_ME;
        }
    }
    bool d = (diff>=0);
    switch(status)
    {
        case STATUS_SLEEP:
        case STATUS_ITS_ME_DIRECT:
            return BAR_SLEEP;
            break;
        case STATUS_CANDIDATE_DIRECT:
            if( (bars[BarNo]&&d) || (!bars[BarNo]&&!d) )
            {
                if(BarNo == DecisionBar-1)
                {
                    status = STATUS_ITS_ME_DIRECT;
                    return BAR_ITS_ME_DIRECT;
                }
                return BAR_MORE_PLZ;
            }
            else
            {
                status = STATUS_SLEEP;
                return BAR_NOT_ME;
            }
            break;
        default:
            assert(0,"which state is it?");
            return BAR_SLEEP;
    }
}
void Pattern::openEval(double open0)
{
    assert(status==STATUS_ITS_ME_DIRECT,"I am not direct");
    EvalOpenPrice=open0;
}
void Pattern::closeEvalMidday(double open0)
{
    int direction;
    double profit;
    switch(status)
    {
        case STATUS_ITS_ME_DIRECT:
            direction = (open0>=EvalOpenPrice)?+1:-1;
            profit = open0 - EvalOpenPrice;
            QMidday.count++;
            QMidday.dirCorrectCnt+=direction;
            QMidday.ProfitShort = (QMidday.ProfitShort*Pattern::shortP + profit) / (Pattern::shortP+1); 
            QMidday.ProfitLong = (QMidday.ProfitLong*Pattern::longP + profit) / (Pattern::longP+1); 
            QMidday.DirectionShort = (QMidday.DirectionShort*Pattern::shortP + direction) / (Pattern::shortP+1); 
            QMidday.DirectionLong = (QMidday.DirectionLong*Pattern::longP + direction) / (Pattern::longP+1); 
            break;
        case STATUS_SLEEP:
            break;
        default:
            assert(0,"unexpected status at Midday");
            break;
    }
}

void Pattern::closeEvalEndday(double open0)
{
    int direction;
    double profit;
    switch(status)
    {
        case STATUS_ITS_ME_DIRECT:
            direction = (open0>=EvalOpenPrice)?+1:-1;
            profit = open0 - EvalOpenPrice;
            QEndday.count++;
            QEndday.dirCorrectCnt+=direction;
            QEndday.ProfitShort = (QEndday.ProfitShort*Pattern::shortP + profit) / (Pattern::shortP+1); 
            QEndday.ProfitLong = (QEndday.ProfitLong*Pattern::longP + profit) / (Pattern::longP+1); 
            QEndday.DirectionShort = (QEndday.DirectionShort*Pattern::shortP + direction) / (Pattern::shortP+1); 
            QEndday.DirectionLong = (QEndday.DirectionLong*Pattern::longP + direction) / (Pattern::longP+1); 
            status = STATUS_SLEEP;
            break;
        case STATUS_SLEEP:
            break;
        default:
            assert(0,"unexpected status at Endday");
            break;
    }
}

string Pattern::IDtoName(int id, bool ob, int decision)
{
  string out;
  if(ob)
    out="H";
  else
    out="L";
  int i=id/2;
  for(int j=0;j<decision;j++)
  {
     out=out+string(i%2);
     i/=2;
  }
  return(out);
}

Pattern::Pattern(int id, int len)
{
    ID=id;
    DecisionBar = len;
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
    assert((PatternLen==0 || ID<(1<<(PatternLen+1))) && ID>=0,"invalid ID");
    openBar = (ID&0x01 == 1);
    for(int i=1;i<=len;i++)
        bars[i-1] = ((ID&(1<<i)) != 0);
    status=STATUS_SLEEP;
    name = IDtoName(ID, openBar, DecisionBar);
}

