#include "../../BlueHat/INode.mqh"
#include "../../BlueHat/Axon.mqh"
#include "../../BlueHat/Features/FeatureCheater.mqh"
void OnStart()
{
    Print("Hi there");
    INode* feature[2];
    feature[0] = new FeatureCheater;
    feature[1] = new Neuron;

    Axon ax(feature[1], 0, 0);
    
    Print(feature[1].GetNode(),"end");  
    delete feature[0]; 
    delete feature[1]; 
}
//+------------------------------------------------------------------+
