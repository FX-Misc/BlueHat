#include "Owner.mqh"

Owner::Owner()
{
    axonsL1 = new CXArrayList<IAxonTrain*>;
    axonsL2 = new CXArrayList<IAxonTrain*>;
}
Owner::~Owner()
{
    delete softmax;
    delete trainer;
    Print("deleting axons: ",axonsL1.Count(),"+",axonsL2.Count());
    for(int i=0; i<axonsL1.Count(); i++)
        delete axonsL1.at(i);
    for(int i=0; i<axonsL2.Count(); i++)
        delete axonsL2.at(i);
    for(int i=0; i<ineourons.Count(); i++)
        delete ineourons.at(i);
    for(int i=0; i<features.Count(); i++)
        delete features.at(i);
    delete axonsL1;
    delete axonsL2; 

    Print("deleting done");
}
void Owner::CreateNN()  //TODO: input file/
{
    FeatureFactory ff;

    //based on the input file, decide on feature type
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));

    axonsL1.Add( new Axon(features.at(0), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(0), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(1), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(2), RATE_DEGRADATION, RATE_GROWTH) );

    NeuronFactory nf;
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 

    ineourons.at(0).AddAxon(axonsL1.at(0));
    ineourons.at(0).AddAxon(axonsL1.at(1));
    ineourons.at(1).AddAxon(axonsL1.at(2));
    ineourons.at(2).AddAxon(axonsL1.at(3));
       
    axonsL2.Add( new Axon(ineourons.at(0), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL2.Add( new Axon(ineourons.at(1), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL2.Add( new Axon(ineourons.at(2), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL2.Add( new Axon(ineourons.at(2), RATE_DEGRADATION, RATE_GROWTH) );

    softmax = new SoftMax();
    softmax.AddAxon(axonsL2.at(0));
    softmax.AddAxon(axonsL2.at(1));
    softmax.AddAxon(axonsL2.at(2));
    softmax.AddAxon(axonsL2.at(3));
    
    trainer = new Trainer(softmax, axonsL1, axonsL2);
}
/*
trade_advice_t Owner::Go1Bar(int index, int history_index, bool logging)
{
    for(int i=0; i<features.Count(); i++)
        ((Feature*)(features.at(i))).Update(index, history_index);

    if(logging)
        SaveDebugInfo(index);        
    float new_desired = 0.5;//close[index]
    trainer.Go1Epoch(new_desired,true);
    return TRADE_NONE;
*/
void Owner::UpdateInput(int index, int history_index)
{
    for(int i=0; i<features.Count(); i++)
        ((Feature*)(features.at(i))).Update(index, history_index);
}
void Owner::Train1Epoch(float desired)
{
    trainer.Go1Epoch(desired,true);
}
trade_advice_t Owner::GetAdvice()
{
    return TRADE_NONE;
}
bool Owner::CreateDebugDB()
{
    db.AddDBGTBLItem("feature0",false);
    db.AddDBGTBLItem("feature1",false);
    db.AddDBGTBLItem("feature2",false);
    db.AddDBGTBLItem("axonsL10",false);
    db.AddDBGTBLItem("axonsL11",false);
    db.AddDBGTBLItem("axonsL12",false);
    db.AddDBGTBLItem("axonsL13",false);
    db.AddDBGTBLItem("ineourons0",false);
    db.AddDBGTBLItem("ineourons1",false);
    db.AddDBGTBLItem("ineourons2",false);
    db.AddDBGTBLItem("axonsL20",false);
    db.AddDBGTBLItem("axonsL21",false);
    db.AddDBGTBLItem("axonsL22",false);
    db.AddDBGTBLItem("axonsL23",false);
    return db.AddDBGTBLItem("softmax",true);
}
bool Owner::CreateStateDB()
{
/*
    db.AddDBGTBLItem("feature0",false);
    db.AddDBGTBLItem("feature1",false);
    db.AddDBGTBLItem("feature2",false);
    db.AddDBGTBLItem("axonsL10",false);
    db.AddDBGTBLItem("axonsL11",false);
    db.AddDBGTBLItem("axonsL12",false);
    db.AddDBGTBLItem("axonsL13",false);
    db.AddDBGTBLItem("ineourons0",false);
    db.AddDBGTBLItem("ineourons1",false);
    db.AddDBGTBLItem("ineourons2",false);
    db.AddDBGTBLItem("axonsL20",false);
    db.AddDBGTBLItem("axonsL21",false);
    db.AddDBGTBLItem("axonsL22",false);
    db.AddDBGTBLItem("axonsL23",false);
    return db.AddDBGTBLItem("softmax",true);
    */
    return true;
}
void Owner::SaveDebugInfo(int index)
{   //TODO_performance: use as transaction to speed up, rather than separate writtings
    db.Insert("ID", (float)index, false);    
    db.Insert("feature0", (float)0.5, false);    
    db.Insert("softmax", (float)0.6, true);    
//    db.Insert(index+1, "softmax", (float)0.5);    
}