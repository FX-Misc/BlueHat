#include "Owner.mqh"

Owner::Owner()
{
    axonsL1 = new CXArrayList<Axon*>;
    axonsL2 = new CXArrayList<Axon*>;
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
void Owner::CreateNN(evaluation_method_t evm)  //TODO: input file/
{
    FeatureFactory ff;

    //based on the input file, decide on feature type
    features.Add(ff.CreateFeature(FEATURE_RANDOM));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_RANDOM));

    axonsL1.Add( new Axon(features.at(0), 0, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(2), 2, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );

    NeuronFactory nf;
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    ineourons.Add( nf.CreateNeuron(NEURON_SUM) ); 

    ineourons.at(0).AddAxon(axonsL1.at(0));
    ineourons.at(0).AddAxon(axonsL1.at(1));
    ineourons.at(1).AddAxon(axonsL1.at(2));
    ineourons.at(2).AddAxon(axonsL1.at(3));
       
    axonsL2.Add( new Axon(ineourons.at(0), 0, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL2.Add( new Axon(ineourons.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL2.Add( new Axon(ineourons.at(2), 2, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );

    softmax = new SoftMax();
    softmax.AddAxon(axonsL2.at(0));
    softmax.AddAxon(axonsL2.at(1));
    softmax.AddAxon(axonsL2.at(2));
    
    eval = new Evaluator(evm);
    trainer = new Trainer(softmax, eval, axonsL1, axonsL2);
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
    for(int i=0; i<features.Count(); i++)
        db.AddDBGTBLItem(features.at(i).name+IntegerToString(i,2,'0'),false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL1.at(i).node_id,2,'0'),false);
    for(int i=0; i<ineourons.Count(); i++)
        db.AddDBGTBLItem("N"+IntegerToString(i,2,'0'),false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.AddDBGTBLItem("Y"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL2.at(i).node_id,2,'0'),false);
    db.AddDBGTBLItem("ACCshort", false);
    db.AddDBGTBLItem("ACCall", false);
    db.AddDBGTBLItem("DIRshort", false);
    db.AddDBGTBLItem("DIRall", false);
    db.AddDBGTBLItem("desired", false);
    return db.AddDBGTBLItem("softmax",true);
}
bool Owner::CreateStateDB()
{
    return true;
}
void Owner::SaveDebugInfo(int index, float desired_in)
{
    db.Insert("ID", (float)index, false);    
    for(int i=0; i<features.Count(); i++)
        db.Insert(features.at(i).name+IntegerToString(i,2,'0'), features.at(i).GetNode(), false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.Insert("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL1.at(i).node_id,2,'0'), axonsL1.at(i).GetGain(), false);
    for(int i=0; i<ineourons.Count(); i++)
        db.Insert("N"+IntegerToString(i,2,'0'), ineourons.at(i).GetNode(), false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.Insert("Y"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL2.at(i).node_id,2,'0'), axonsL2.at(i).GetGain(), false);
    db.Insert("ACCshort", eval.GetAccuracyShort(), false);
    db.Insert("ACCall", eval.GetAccuracyAllTime(), false);
    db.Insert("DIRshort", eval.GetDirectionCorrectnessShort(), false);
    db.Insert("DIRall", eval.GetDirectionCorrectnessAllTime(), false);
    db.Insert("desired", desired_in, false);
    db.Insert("softmax", softmax.GetNode(), true);
}
