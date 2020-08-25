#include "Owner.mqh"

Owner::Owner()
{
    axonsL1 = new CXArrayList<Axon*>;
    axonsL2 = new CXArrayList<Axon*>;
    MathSrand(GetTickCount());
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
    for(int i=0; i<neourons.Count(); i++)
        delete neourons.at(i);
    for(int i=0; i<features.Count(); i++)
        delete features.at(i);
    delete axonsL1;
    delete axonsL2; 
    delete eval;
    delete acc;
    delete quality;

    Print("deleting done");
}
void Owner::CreateNN(evaluation_method_t evm)  //TODO: input file/
{
    FeatureFactory ff;
    AccuracyFactory acf;
    NeuronFactory nf;
    
#define LOAD_NN_FROM_DB
#ifdef  LOAD_NN_FROM_DB
//==================Features
    string str;
    int req;
    req = db.CreateRequest("Features");
    str = db.ReadNextString(req);
    while(str!=DB_END_STR)
    {
        assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
        features.Add(ff.CreateFeature(str));
        str = db.ReadNextString(req);
    };
    db.FinaliseRequest(req);
    Print(features.Count()," features created");

//==================AxonsL1
    int i;
    req = db.CreateRequest("AxonsFeID");
    i = db.ReadNextInt(req);
    while(i!=DB_END_INT)
    {
        assert(i!=DB_ERROR_INT,"DB ERROR IN NN");
        axonsL1.Add( new Axon(features.at(i), i, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
        i = db.ReadNextInt(req);
    };
    db.FinaliseRequest(req);
    Print(axonsL1.Count()," Axons(L1) created");

//==================Neurons
    string tempstr[MAX_AXONS]; 
    string tempaxons;
    int tempcnt;
    Neuron* tempne;
    req = db.CreateRequest("Neurons");
    str = db.ReadNextString(req);
    while(str!=DB_END_STR)
    {
        assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
        tempcnt = StringSplit(str,'=',tempstr);
        assert(tempcnt==2,"wrong neuron entry format");
        tempne = nf.CreateNeuron(tempstr[0]);
        neourons.Add(tempne);
        tempaxons = tempstr[1]; 
        tempcnt = StringSplit(tempaxons,' ',tempstr);
        for(int j=0; j<tempcnt; j++)
        {
            int axonNo = (int)StringToInteger(tempstr[j]);
            assert(axonNo < axonsL1.Count(), "wrong axon no");
            tempne.AddAxon(axonsL1.at(axonNo));
        }      
        str = db.ReadNextString(req);
    };
    db.FinaliseRequest(req);
    Print(neourons.Count()," neurons created");
//==================AxonsL2
    for(int j=0; j<neourons.Count(); j++)
        axonsL2.Add( new Axon(neourons.at(j), j, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    Print(axonsL2.Count()," Axons(L2) created");
//==================Softmax
    softmax = new SoftMax();
    for(int j=0; j<axonsL2.Count(); j++)
        softmax.AddAxon(axonsL2.at(j));
//==================Others
    acc = acf.CreateAccuracy(evm);
    eval = new Evaluator(acc);
    trainer = new Trainer(softmax, eval, axonsL1, axonsL2);
    quality = new QualityMetrics();
#else 
    //based on the input file, decide on feature type
    features.Add(ff.CreateFeature(FEATURE_RANDOM));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_BIAS_POSITIVE));
    features.Add(ff.CreateFeature(FEATURE_BIAS_NEGATIVE));

    axonsL1.Add( new Axon(features.at(0), 0, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(2), 2, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL1.Add( new Axon(features.at(3), 3, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );


    neourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    neourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    neourons.Add( nf.CreateNeuron(NEURON_SUM) ); 
    neourons.Add( nf.CreateNeuron(NEURON_SUM) ); 

    neourons.at(0).AddAxon(axonsL1.at(0));
    neourons.at(0).AddAxon(axonsL1.at(1));
    neourons.at(1).AddAxon(axonsL1.at(2));
    neourons.at(2).AddAxon(axonsL1.at(3));
    neourons.at(3).AddAxon(axonsL1.at(4));
       
    axonsL2.Add( new Axon(neourons.at(0), 0, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL2.Add( new Axon(neourons.at(1), 1, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL2.Add( new Axon(neourons.at(2), 2, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );
    axonsL2.Add( new Axon(neourons.at(3), 3, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR) );

    softmax = new SoftMax();
    softmax.AddAxon(axonsL2.at(0));
    softmax.AddAxon(axonsL2.at(1));
    softmax.AddAxon(axonsL2.at(2));
    softmax.AddAxon(axonsL2.at(3));
    
    acc = acf.CreateAccuracy(evm);
    eval = new Evaluator(acc);
    trainer = new Trainer(softmax, eval, axonsL1, axonsL2);
    quality = new QualityMetrics();
#endif 
}

void Owner::UpdateInput(const float& c[], const float& d[], int len)
{
    for(int i=0; i<features.Count(); i++)
        ((Feature*)(features.at(i))).Update(c, d, len);
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
    db.AddDBGTBLItem("desired", false);
    db.AddDBGTBLItem("softmax",false);
    db.AddDBGTBLItem("DiffShort", false);
    db.AddDBGTBLItem("DiffLong", false);
    db.AddDBGTBLItem("DiffAll", false);
    db.AddDBGTBLItem("DirShort", false);
    db.AddDBGTBLItem("DirLong", false);
    db.AddDBGTBLItem("DirAll", false);
    for(int i=0; i<features.Count(); i++)
        db.AddDBGTBLItem(features.at(i).name+IntegerToString(i,2,'0'),false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL1.at(i).node_id,2,'0'),false);
    for(int i=0; i<neourons.Count(); i++)
        db.AddDBGTBLItem("N"+IntegerToString(i,2,'0'),false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.AddDBGTBLItem("Y"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL2.at(i).node_id,2,'0'),false);
    return db.AddDBGTBLItem("reserve", true);
}
bool Owner::CreateStateDB()
{
    return true;
}
void Owner::SaveDebugInfo(int index, float desired_in)
{
    db.Insert("ID", (float)index, false);    
    db.Insert("desired", desired_in, false);
    db.Insert("softmax", softmax.GetNode(), false);
    db.Insert("DiffShort", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_SHORT), false);
    db.Insert("DiffLong", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_LONG), false);
    db.Insert("DiffAll", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_ALLTIME), false);
    db.Insert("DirShort", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_SHORT), false);
    db.Insert("DirLong", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_LONG), false);
    db.Insert("DirAll", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_ALLTIME), false);
    for(int i=0; i<features.Count(); i++)
        db.Insert(features.at(i).name+IntegerToString(i,2,'0'), features.at(i).GetNode(), false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.Insert("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL1.at(i).node_id,2,'0'), axonsL1.at(i).GetGain(), false);
    for(int i=0; i<neourons.Count(); i++)
        db.Insert("N"+IntegerToString(i,2,'0'), neourons.at(i).GetNode(), false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.Insert("Y"+IntegerToString(i,2,'0')+"_"+IntegerToString(axonsL2.at(i).node_id,2,'0'), axonsL2.at(i).GetGain(), false);
    db.Insert("reserve", 0, true);
}
