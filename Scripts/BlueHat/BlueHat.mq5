#include "../../BlueHat/INode.mqh"
#include "../../BlueHat/Axon.mqh"
#include "../../BlueHat/Features/FeatureCheater.mqh"
#include "../../BlueHat/globals/assert.mqh"
#include "../../BlueHat/globals/ExtendedArrList.mqh"
void OnStart()
{
    Print("Hi there");
    assert(1>0,"test");
    
    CXArrayList<int> arr;
    arr.Add(10);
    arr.Add(20);
    arr.Add(30);
    Print(arr.at(1));
//    SoftMax* softmax = new SoftMax();
//    Trainer* trainer = new Trainer(softmax);
//    delete softmax;
//    delete trainer;
    Print("Done");
}
//+------------------------------------------------------------------+
/*    INode* feature[2];
    feature[0] = new FeatureCheater;
    feature[1] = new NeuronSUM;
    Axon ax(feature[1], 0, 0);
    Print(feature[1].GetNode(),"end");  
    delete feature[0]; 
    delete feature[1]; 
*/
