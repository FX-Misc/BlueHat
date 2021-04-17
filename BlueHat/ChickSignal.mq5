#include "ChickSignal.mqh"
int ChickSignal::GetIncSignal()
{
    int mood=0;
    if(patterns.at(0).status==STATUS_ITS_ME_DIRECT)
    {
        //double now=1;//patterns.at(0).QMidday.Direction+Shortpatterns.at(0).QMidday.DirectionLong+patterns.at(0).QEndday.ProfitShort+patterns.at(0).QEndday.ProfitLong;
        if(patterns.at(0).QEndday.ProfitShort>0)
            mood=+1;
        else
            mood=-1;
    }
    else
       mood=0;
    return mood;
}
ChickSignal::~ChickSignal()
{
}
ChickSignal::ChickSignal(CXArrayList<Pattern*> *p)
{
    patterns=p;
}
//int ChickOwner::GetRoughSignal(int currentPos)    //a rogh signal(+1 buy, -1 sell, 0 none) just for test; it should merge with NN
//{
//    int mood;
//    if(patterns.at(0).status==STATUS_ITS_ME_DIRECT)
//    {
//        double now=1;//patterns.at(0).QMidday.Direction+Shortpatterns.at(0).QMidday.DirectionLong+patterns.at(0).QEndday.ProfitShort+patterns.at(0).QEndday.ProfitLong;
//        mood=now;
//    }
//    else
//       mood=0;
//    
//    if(currentPos==mood)
//        return 0;
//    if(currentPos<mood)
//        return +1;
//    if(currentPos>mood)
//        return -1;
//    return 0;
//}