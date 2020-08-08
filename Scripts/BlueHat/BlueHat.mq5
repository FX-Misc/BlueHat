#include "../../BlueHat/IFeature.mqh"
#include "../../BlueHat/Features/FeatureCheater.mqh"
void OnStart()
{
    Print("Hi there");
    IFeature* feature[2];
    feature[0] = new FeatureCheater;
    feature[1] = new FeatureCheater;
    
    Print(feature[1].GetFeature(),"end");  
    delete feature[0]; 
    delete feature[1]; 
}
//+------------------------------------------------------------------+
