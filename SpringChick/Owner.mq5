#include "Owner.mqh"

Owner::Owner(int pLen):patternLen(pLen)
{
    patterns = new CXArrayList<Pattern*>;
}
void Owner::UpdateInput(const double& c[], const double& d[], const double& o[], const datetime& t[])
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
    }
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
            switch(patterns.at(i).giveBar(barOfDay,d[1]))
            {
                case BAR_ITS_ME_DIRECT:
                    patterns.at(i).openEval(o[0],true);
                    g.DisplayVert("+"+patterns.at(i).name, t[1], c[1] );
                    break;
                case BAR_ITS_ME_REVERSE:
                    patterns.at(i).openEval(o[0],false);
                    g.DisplayVert("-"+patterns.at(i).name, t[1], c[1] );
                    break;
            }
 //       g.DisplayVert("."+barOfDay+" id"+patterns.at(0).ID+" stat"+patterns.at(0).status,t[1], c[1] );
        barOfDay++;
    }
}
void Owner::report()
{
    for(int i=0; i<patterns.Count(); i++)
    {
        //g.DisplayVert("="+patterns.at(i).name+" "+
        //    patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
        //    (int)patterns.at(i).QEndday.DirectionShort+","+(int)patterns.at(i).QEndday.DirectionLong+" P "+
        //    (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
        //    , t[1], c[1]);
        Print("="+patterns.at(i).name+" "+
            patterns.at(i).QEndday.dirCorrectCnt+"/"+patterns.at(i).QEndday.count+" D "+
            (int)(patterns.at(i).QEndday.DirectionShort*10)+","+(int)(patterns.at(i).QEndday.DirectionLong*10)+" P "+
            (int)patterns.at(i).QEndday.ProfitShort+","+(int)patterns.at(i).QEndday.ProfitLong
            );
    }
}
void Owner::LoadPatterns(Market* m)
{
    //for now, start with all possible patterns
    //later, only "good" patterns can be loaded from db

//    string str="";
    for(int j=1; j<=patternLen; j++)
    {
        for(int i=0; i<(1<<(j+1)); i++)
        {
            patterns.Add(new Pattern(i,j));
//            str+=":"+patterns.at(patterns.Count()-1).ID+patterns.at(patterns.Count()-1).DecisionBar+patterns.at(patterns.Count()-1).name+"  ";
        }
//        str+="\n";
    }
//    Comment(str);

//    patterns.Add(new Pattern(6,2));

    //for(int i=0; i<(1<<(patternLen+1)); i++)
    //{
    //    patterns.Add(new Pattern(i,patternLen));
    //}
//    patterns.Add(new Pattern(6,3));
/*        string str;
        int req;
        req = db.CreateRequest("AxonsL1");
        str = db.ReadNextString(req);
        while(str!=DB_END_STR)
        {
            assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
            bool neg=false;
            if(str[0]=='-')
            {   //negate the axon
                str=StringSubstr(str,1);
                neg=true;
            }
            string tempstr[3],name;
            bool freeze;
            double init;
            int splitcnt = StringSplit(str,'=',tempstr);
            switch(splitcnt)
            {
                case 1:   //normal Axon
                    name = tempstr[0];
                    freeze = false;
                    init = AXON_FLOOR;
                    break;
                case 2:   //active Axon, but with init value
                    name = tempstr[0];
                    freeze = false;
                    init = StringToDouble(tempstr[1]);
                    break;
                case 3:   //frozen Axon
                    assert(tempstr[1]=="F" || tempstr[1]=="f", "Axon is not frozen");
                    name = tempstr[0];
                    freeze = true;
                    init = StringToDouble(tempstr[2]);
                    break;
                 default:
                    freeze = true;
                    init = 0;
                    assert(false,"wrong Axon format");
                    break;
            }
            features.AddIfNotFound(ff.FeatureInstance(name));
            int feNo = features.IndexOf(ff.FeatureInstance(name));
            assert(feNo>=0 && feNo<features.Count(), "wrong feature no");
            axonsL1.Add( new Axon(ff.FeatureInstance(name), feNo, neg, freeze, init, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING, axon_method) );
            str = db.ReadNextString(req);
        };
        for(int i=0; i<features.Count(); i++)
            features.at(i).market = m;
        db.FinaliseRequest(req);
        Print(features.Count()," features created");
        Print(axonsL1.Count()," Axons(L1) created");
    }
*/
}


//void Owner::Train1Epoch(double desired, double desired_scaled, evaluation_method_t evm)
//{
//    switch(evm)
//    {
//        case METHOD_DIRECTION:
//            trainer.Go1Epoch(desired,accDir);
//            trainer.ApplyAxonChanges(true, desired_scaled);
//            break;
//        case METHOD_ANALOG_DISTANCE:
//            trainer.Go1Epoch(desired,accAnalog);
//            trainer.ApplyAxonChanges(false, 0);
//            break;
//        case METHOD_ALL:
//            trainer.Go1Epoch(desired,accDir);
//            trainer.ApplyAxonChanges(true, desired_scaled);
//            trainer.Go1Epoch(desired,accAnalog);
//            trainer.ApplyAxonChanges(false, 0);
//            break;
//        default:
//            assert(false,"unknown accuracy method");
//    }
//}
//trade_advice_t Owner::GetAdvice()
//{
//    return TRADE_NONE;
//}
bool Owner::CreateDebugDB(DEBUG_MODE debug_m)
{
    if(debug_m == DEBUG_NONE)
        return true;
    db.AddDBGTBLItem("time", false);
    //db.AddDBGTBLItem("desired", false);
    //db.AddDBGTBLItem("softmax",false);
    //if(debug_m==DEBUG_VERBOSE)
    //{
    //    db.AddDBGTBLItem("DiffShort", false);
    //}

    //if(debug_m==DEBUG_VERBOSE)
    //    for(int i=0; i<features.Count(); i++)
    //        db.AddDBGTBLItem(features.at(i).name,false);
    //for(int i=0; i<axonsL1.Count(); i++)
    //{
    //    db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"_"+axonsL1.at(i).pnode.name,false);
    //    if(debug_m==DEBUG_VERBOSE || debug_m==DEBUG_INTERVAL_100)
    //        db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"p",false);
    //}
    return db.AddDBGTBLItem("reserve", true);
}
bool Owner::CreateStateDB()
{
    return true;
}
Owner::~Owner()
{
    Print("deleting done");
}

void Owner::SaveDebugInfo(DEBUG_MODE debug_m, int index, double diff_raw1, double close1, datetime time1)
{
    if(debug_m == DEBUG_NONE)
        return;
    if(debug_m == DEBUG_INTERVAL_10)
        if(index%10 != 0)
            return;
    if(debug_m == DEBUG_INTERVAL_100)
        if(index%100 != 0)
            return;
    db.Insert("ID", (double)index, false);    
    db.Insert("time", (double)time1, false);
    if(debug_m==DEBUG_VERBOSE)
    {
        //db.Insert("DiffShort", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_SHORT), false);
    }
    //db.Insert("Dirpc", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_ALLTIME), false);
    //if(debug_m==DEBUG_VERBOSE)
    //{
    //    db.Insert("ProfitShort", quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_SHORT), false);
    //    db.Insert("ProfitLong", quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_LONG), false);
    //}
    //if(debug_m==DEBUG_VERBOSE)
    //    for(int i=0; i<features.Count(); i++)
    //        db.Insert(features.at(i).name, features.at(i).GetNode(), false);
    //for(int i=0; i<axonsL1.Count(); i++)
    //{
    //    db.Insert("X"+IntegerToString(i,2,'0')+"_"+axonsL1.at(i).pnode.name, axonsL1.at(i).GetGain(), false);
    //    if(debug_m==DEBUG_VERBOSE || debug_m==DEBUG_INTERVAL_100)
    //        db.Insert("X"+IntegerToString(i,2,'0')+"p", axonsL1.at(i).GetProfit(), false);
    //}
    db.Insert("reserve", 0, true);
}
//void Owner::UpdateAxonStats()
//{
//    bestL1=axonsL1.at(0);
//    bestL1Profit=axonsL1.at(0);
//    for(int i=0; i<axonsL1.Count(); i++)
//    {
//        axonsL1.at(i).UpdateAve();
//        if(axonsL1.at(i).GetAve() > bestL1.GetAve())
//            bestL1=axonsL1.at(i);
//        if(axonsL1.at(i).GetProfit() > bestL1Profit.GetProfit() )
//            bestL1Profit=axonsL1.at(i);
//    }
//    bestL2=axonsL2.at(0);
//    bestL2Profit=axonsL2.at(0);
//    for(int i=0; i<axonsL2.Count(); i++)
//    {
//        axonsL2.at(i).UpdateAve();
//        if(axonsL2.at(i).GetAve() > bestL2.GetAve())
//            bestL2=axonsL2.at(i);
//        if(axonsL2.at(i).GetProfit() > bestL2Profit.GetProfit() )
//            bestL2Profit=axonsL2.at(i);
//    }
//    bestL3=axonsL3.at(0);
//    bestL3Profit=axonsL3.at(0);
//    for(int i=0; i<axonsL3.Count(); i++)
//    {
//        axonsL3.at(i).UpdateAve();
//        if(axonsL3.at(i).GetAve() > bestL3.GetAve())
//            bestL3=axonsL3.at(i);
//         if(axonsL3.at(i).GetProfit() > bestL3Profit.GetProfit() )
//            bestL3Profit=axonsL3.at(i);
//   } 
//}
