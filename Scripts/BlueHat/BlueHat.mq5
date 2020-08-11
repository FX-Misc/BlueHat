#include "../../BlueHat/INode.mqh"
#include "../../BlueHat/Axon.mqh"
#include "../../BlueHat/NNFactory.mqh"
#include "../../BlueHat/Features/FeatureCheater.mqh"
void OnStart()
{
    Print("Hi there");
    SoftMax* softmax = new SoftMax();
    Trainer* trainer = new Trainer(softmax);
    NNFactory* factory = new NNFactory(softmax, trainer);
    factory.CreateNNetwork();
    delete softmax;
    delete trainer;
    delete factory;
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
