#include "ChickOwner.mqh"

ChickOwner::ChickOwner(int pLen):patternLen(pLen)
{
    patterns = new CXArrayList<Pattern*>;
}
void ChickOwner::UpdateInput(const double& c[], const double& d[], const double& o[], const datetime& t[])
{   //d is diff_raw, despite BlueHat
    MqlDateTime ts1,ts2;
    static int barOfDay=-1;
    TimeToStruct(t[1], ts1);
    TimeToStruct(t[2], ts2);
    if(ts1.day!=ts2.day)
    {   //Start of the day
        int i;
        for(i=0; i<patterns.Count(); i++)
            patterns.at(i).giveBar(-1,o[1]-c[2]);
        barOfDay=0;
        g.DisplayVert("start "+i+" patterns", t[1], c[1] );
        Print("newday");
    }
//    else
        //g.DisplayVert(".", t[1], c[1] );
  //      Print("_");
    Print("in ", barOfDay, " t " ,ts1.min, " " , ts2.min);
    if(barOfDay==MiddayBar)
        for(int i=0; i<patterns.Count(); i++)
            patterns.at(i).closeEvalMidday(o[0]);
    if(barOfDay==EnddayBar)
        for(int i=0; i<patterns.Count(); i++)
        {
            patterns.at(i).closeEvalEndday(o[0]);
            //g.DisplayVert("="+patterns.at(i).name+" "+
            //    patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
            //    (int)patterns.at(i).QEndday.DirectionShort+","+(int)patterns.at(i).QEndday.DirectionLong+" P "+
            //    (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
            //    , t[1], c[1]);
/*            Print("="+patterns.at(i).name+" "+
                patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
                (int)patterns.at(i).QEndday.DirectionShort+","+(int)patterns.at(i).QEndday.DirectionLong+" P "+
                (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
                );
*/
        }

    if(barOfDay>=0)
    {
        for(int i=0; i<patterns.Count(); i++)
            if(patterns.at(i).giveBar(barOfDay,d[1])==BAR_ITS_ME_DIRECT)
            {
                patterns.at(i).openEval(o[0]);
                g.DisplayVert("+"+patterns.at(i).name, t[1], c[1] );
            }
 //       g.DisplayVert("."+barOfDay+" id"+patterns.at(0).ID+" stat"+patterns.at(0).status,t[1], c[1] );
        barOfDay++;
    }
}
void ChickOwner::report()
{
    for(int i=0; i<patterns.Count(); i++)
    {
        //g.DisplayVert("="+patterns.at(i).name+" "+
        //    patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
        //    (int)patterns.at(i).QEndday.DirectionShort+","+(int)patterns.at(i).QEndday.DirectionLong+" P "+
        //    (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
        //    , t[1], c[1]);
        Print("=M "+patterns.at(i).name+" "+
            patterns.at(i).QMidday.dirCorrectCnt+"/"+patterns.at(i).QMidday.count+" D "+
            (int)(patterns.at(i).QMidday.DirectionShort*10)+","+(int)(patterns.at(i).QMidday.DirectionLong*10)+" P "+
            (int)patterns.at(i).QMidday.ProfitShort+","+(int)patterns.at(i).QMidday.ProfitLong
            );
        Print("=E "+patterns.at(i).name+" "+
            patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
            (int)(patterns.at(i).QEndday.DirectionShort*10)+","+(int)(patterns.at(i).QEndday.DirectionLong*10)+" P "+
            (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
            );
    }
}
int ChickOwner::GetRoughSignal(int currentPos)    //a rogh signal(+1 buy, -1 sell, 0 none) just for test; it should merge with NN
{
    int mood;
    if(patterns.at(0).status==STATUS_ITS_ME_DIRECT)
    {
        double now=1;//patterns.at(0).QMidday.Direction+Shortpatterns.at(0).QMidday.DirectionLong+patterns.at(0).QEndday.ProfitShort+patterns.at(0).QEndday.ProfitLong;
        mood=now;
    }
    else
       mood=0;
    
    if(currentPos==mood)
        return 0;
    if(currentPos<mood)
        return +1;
    if(currentPos>mood)
        return -1;
    return 0;
}
void ChickOwner::LoadPatterns(Market* m)
{
    //for now, start with all possible patterns
    //later, only "good" patterns can be loaded from db

////    string str="";
//    for(int j=1; j<=patternLen; j++)
//    {
//        for(int i=0; i<(1<<(j+1)); i++)
//        {
//            patterns.Add(new Pattern(i,j));
//        }
////        str+="\n";
//    }
patterns.Add(new Pattern(2,1));
}

ChickOwner::~ChickOwner()
{
    Print("deleting ChickOwner done");
}

