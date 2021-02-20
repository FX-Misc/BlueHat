#include "Owner.mqh"

Owner::Owner()
{
}
Owner::~Owner()
{
    Print("deleting done");
}
void Owner::CreateNN(Market* m)
{
}

void Owner::UpdateInput(const double& c[], const double& d[], int len)
{
}
void Owner::Train1Epoch(double desired, double desired_scaled, evaluation_method_t evm)
{
    switch(evm)
    {
        case METHOD_DIRECTION:
            trainer.Go1Epoch(desired,accDir);
            trainer.ApplyAxonChanges(true, desired_scaled);
            break;
        case METHOD_ANALOG_DISTANCE:
            trainer.Go1Epoch(desired,accAnalog);
            trainer.ApplyAxonChanges(false, 0);
            break;
        case METHOD_ALL:
            trainer.Go1Epoch(desired,accDir);
            trainer.ApplyAxonChanges(true, desired_scaled);
            trainer.Go1Epoch(desired,accAnalog);
            trainer.ApplyAxonChanges(false, 0);
            break;
        default:
            assert(false,"unknown accuracy method");
    }
}
trade_advice_t Owner::GetAdvice()
{
    return TRADE_NONE;
}
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
void Owner::UpdateAxonStats()
{
    bestL1=axonsL1.at(0);
    bestL1Profit=axonsL1.at(0);
    for(int i=0; i<axonsL1.Count(); i++)
    {
        axonsL1.at(i).UpdateAve();
        if(axonsL1.at(i).GetAve() > bestL1.GetAve())
            bestL1=axonsL1.at(i);
        if(axonsL1.at(i).GetProfit() > bestL1Profit.GetProfit() )
            bestL1Profit=axonsL1.at(i);
    }
    bestL2=axonsL2.at(0);
    bestL2Profit=axonsL2.at(0);
    for(int i=0; i<axonsL2.Count(); i++)
    {
        axonsL2.at(i).UpdateAve();
        if(axonsL2.at(i).GetAve() > bestL2.GetAve())
            bestL2=axonsL2.at(i);
        if(axonsL2.at(i).GetProfit() > bestL2Profit.GetProfit() )
            bestL2Profit=axonsL2.at(i);
    }
    bestL3=axonsL3.at(0);
    bestL3Profit=axonsL3.at(0);
    for(int i=0; i<axonsL3.Count(); i++)
    {
        axonsL3.at(i).UpdateAve();
        if(axonsL3.at(i).GetAve() > bestL3.GetAve())
            bestL3=axonsL3.at(i);
         if(axonsL3.at(i).GetProfit() > bestL3Profit.GetProfit() )
            bestL3Profit=axonsL3.at(i);
   } 
}
string Owner::GetAxonsReport()
{
    string temp = bestL1.pnode.name + "(" + IntegerToString(bestL1.node_id)+")=" + DoubleToString(bestL1.GetAve(),2)+"," + DoubleToString(bestL1.GetProfit(),2);
    temp += "..."+bestL1Profit.pnode.name + "(" + IntegerToString(bestL1Profit.node_id)+")=" + DoubleToString(bestL1Profit.GetAve(),2)+"," + DoubleToString(bestL1Profit.GetProfit(),2);
    temp += "   "+ bestL2.pnode.name + "(" + IntegerToString(bestL2.node_id)+")=" + DoubleToString(bestL2.GetAve(),2)+"," + DoubleToString(bestL2.GetProfit(),2);
    temp += "..."+bestL2Profit.pnode.name + "(" + IntegerToString(bestL2Profit.node_id)+")=" + DoubleToString(bestL2Profit.GetAve(),2)+"," + DoubleToString(bestL2Profit.GetProfit(),2);
    temp += "   "+ bestL3.pnode.name + "(" + IntegerToString(bestL3.node_id)+")=" + DoubleToString(bestL3.GetAve(),2)+"," + DoubleToString(bestL3.GetProfit(),2);
    temp += "..."+bestL3Profit.pnode.name + "(" + IntegerToString(bestL3Profit.node_id)+")=" + DoubleToString(bestL3Profit.GetAve(),2)+"," + DoubleToString(bestL3Profit.GetProfit(),2);
    return temp;
}
void Owner::ResetAxons(void)
{
    for(int i=0; i<axonsL1.Count(); i++)
        axonsL1.at(i).ResetGain();
    for(int i=0; i<axonsL2.Count(); i++)
        axonsL2.at(i).ResetGain();
    for(int i=0; i<axonsL3.Count(); i++)
        axonsL3.at(i).ResetGain();

}