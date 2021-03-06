#include "Owner.mqh"

Owner::Owner(int pLen):patternLen(pLen)
{
    patterns = new CXArrayList<Pattern*>;
}
void Owner::UpdateInput(const double& c[], const double& d[], const datetime& t[])
{   //d is diff_raw, despite BlueHat
    MqlDateTime ts;
    static int barOfDay=-1;
    TimeToStruct(t[1], ts);
    if(ts.hour==StartHour && ts.min<=30)
    {   //Start of the day
        for(int i=0; i<patterns.Count(); i++)
        { 
            patterns.at(i).giveBar(-1,c[1]-c[2]);
        }
        barOfDay=0;
    }
    if(barOfDay>=0)
    {
        for(int i=0; i<patterns.Count(); i++)
        {
    
            patterns.at(i).giveBar(barOfDay,d[1]);
        }
        barOfDay++;
    }
}
void Owner::LoadPatterns(Market* m)
{
    //for now, start with all possible patterns
    //later, only "good" patterns can be loaded from db
    for(int i=0; i<(1<<(patternLen+1)); i++)
    {
        patterns.Add(new Pattern(i));
    }
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
