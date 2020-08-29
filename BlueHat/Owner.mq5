#include "Owner.mqh"

Owner::Owner()
{
    axonsL1 = new CXArrayList<Axon*>;
    axonsL2 = new CXArrayList<Axon*>;
    axonsL3 = new CXArrayList<Axon*>;
    MathSrand(GetTickCount());
}
Owner::~Owner()
{
    delete softmax;
    delete trainer;
    Print("deleting axons: ",axonsL1.Count(),"+",axonsL2.Count(),"+",axonsL3.Count());
    for(int i=0; i<axonsL1.Count(); i++)
        delete axonsL1.at(i);
    for(int i=0; i<axonsL2.Count(); i++)
        delete axonsL2.at(i);
    for(int i=0; i<axonsL3.Count(); i++)
        delete axonsL3.at(i);
    for(int i=0; i<neuronsL1.Count(); i++)
        delete neuronsL1.at(i);
    for(int i=0; i<neuronsL2.Count(); i++)
        delete neuronsL2.at(i);
    for(int i=0; i<features.Count(); i++)
        delete features.at(i);
    delete axonsL1;
    delete axonsL2; 
    delete axonsL3; 
    delete eval;
    delete acc;
    delete quality;

    Print("deleting done");
}
void Owner::CreateNN(evaluation_method_t evm)  //TODO: input file/
{
    FeatureFactory ff;
//    features.AddIfNotFound(ff.FeatureInstance("feCheater"));
//    Print(features.Count(),features.at(0).name,features.at(1).name);
    AccuracyFactory acf;
    NeuronFactory nf;
    

//==================Features & AxonsL1
    {
        string str;
        int req;
        req = db.CreateRequest("AxonsL1");
        str = db.ReadNextString(req);
        while(str!=DB_END_STR)
        {
            assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
            features.AddIfNotFound(ff.FeatureInstance(str));
            int feNo = features.IndexOf(ff.FeatureInstance(str));
            assert(feNo>=0 && feNo<features.Count(), "wrong feature no");
            axonsL1.Add( new Axon(ff.FeatureInstance(str), feNo, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING) );
            str = db.ReadNextString(req);
        };
        db.FinaliseRequest(req);
        Print(features.Count()," features created");
        Print(axonsL1.Count()," Axons(L1) created");
    }
//==================NeuronsL1
    {
        string str;
        int req;
        Neuron* ne = NULL;
        int index = 0;
        string tempstr[2];
        //int splitcnt;
        req = db.CreateRequest("NeuronsL1");
        str = db.ReadNextString(req);
        while(str!=DB_END_STR)
        {
            assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
            if(str=="+")
                ne.AddAxon(axonsL1.at(index));
            else
            {                
                int splitcnt = StringSplit(str,'=',tempstr);
                assert(splitcnt==2,"wrong neuron format in NN");
                ne = nf.CreateNeuron(tempstr[0],tempstr[1]);
                ne.AddAxon(axonsL1.at(index));
                neuronsL1.Add(ne);
            }
            str = db.ReadNextString(req);
            index++;
        };
        db.FinaliseRequest(req);
        Print(neuronsL1.Count()," Neurons(L1) created");
    }
//==================AxonsL2
    {
        string str;
        int req;
        int index = -1;
        Neuron* ne=NULL;
        req = db.CreateRequest("AxonsL2");
        str = db.ReadNextString(req);
        while(str!=DB_END_STR)
        {
            assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
            ne = nf.FindNeuronByName(str, &neuronsL1, index);
            assert(index!=-1 && ne!=NULL,"neuron not found in NN");
            axonsL2.Add(new Axon(ne, index, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING));
            
            str = db.ReadNextString(req);
        };
        db.FinaliseRequest(req);
        Print(axonsL2.Count()," Axons(L2) created");
    }
//==================NeuronsL2
    {
        string str;
        int req;
        Neuron* ne = NULL;
        int index = 0;
        string tempstr[2];
        //int splitcnt;
        req = db.CreateRequest("NeuronsL2");
        str = db.ReadNextString(req);
        while(str!=DB_END_STR)
        {
            assert(str!=DB_ERROR_STR,"DB ERROR IN NN");
            if(str=="+")
                ne.AddAxon(axonsL2.at(index));
            else
            {                
                int splitcnt = StringSplit(str,'=',tempstr);
                assert(splitcnt==2,"wrong neuron format in NN");
                ne = nf.CreateNeuron(tempstr[0],tempstr[1]);
                ne.AddAxon(axonsL2.at(index));
                neuronsL2.Add(ne);
            }
            str = db.ReadNextString(req);
            index++;
        };
        db.FinaliseRequest(req);
        Print(neuronsL2.Count()," Neurons(L2) created");
    }
//==================AxonsL2
    {
        for(int i=0; i<neuronsL2.Count(); i++)
            axonsL3.Add( new Axon(neuronsL2.at(i), i, RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING) );
        Print(axonsL3.Count()," Axons(L3) created");
    }
//==================Softmax
    {
        softmax = new NeuronSUM("softmax");
        for(int i=0; i<axonsL3.Count(); i++)
            softmax.AddAxon(axonsL3.at(i));
    }
//==================Others
    acc = acf.CreateAccuracy(evm);
    eval = new Evaluator(acc);
    trainer = new Trainer(softmax, eval, axonsL1, axonsL2, axonsL3);
    quality = new QualityMetrics();

}

void Owner::UpdateInput(const double& c[], const double& d[], int len)
{
    for(int i=0; i<features.Count(); i++)
        ((Feature*)(features.at(i))).Update(c, d, len);
}
void Owner::Train1Epoch(double desired)
{
    trainer.Go1Epoch(desired);
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
        db.AddDBGTBLItem(features.at(i).name,false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"_"+axonsL1.at(i).pnode.name,false);
    for(int i=0; i<neuronsL1.Count(); i++)
        db.AddDBGTBLItem("N"+"_"+neuronsL1.at(i).name,false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.AddDBGTBLItem("Y"+IntegerToString(i,2,'0')+"_"+axonsL2.at(i).pnode.name,false);
    for(int i=0; i<neuronsL2.Count(); i++)
        db.AddDBGTBLItem("N"+"_"+neuronsL2.at(i).name,false);
    for(int i=0; i<axonsL3.Count(); i++)
        db.AddDBGTBLItem("Z"+IntegerToString(i,2,'0')+"_"+axonsL3.at(i).pnode.name,false);
    db.AddDBGTBLItem("diff_raw", false);
    db.AddDBGTBLItem("close_raw", false);
    return db.AddDBGTBLItem("reserve", true);
}
bool Owner::CreateStateDB()
{
    return true;
}
void Owner::SaveDebugInfo(int index, double desired_in, double diff_raw1, double close1)
{
    db.Insert("ID", (double)index, false);    
    db.Insert("desired", desired_in, false);
    db.Insert("softmax", softmax.GetNode(), false);
    db.Insert("DiffShort", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_SHORT), false);
    db.Insert("DiffLong", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_LONG), false);
    db.Insert("DiffAll", quality.GetQuality(QUALITY_METHOD_DIFF,QUALITY_PERIOD_ALLTIME), false);
    db.Insert("DirShort", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_SHORT), false);
    db.Insert("DirLong", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_LONG), false);
    db.Insert("DirAll", quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_ALLTIME), false);
    for(int i=0; i<features.Count(); i++)
        db.Insert(features.at(i).name, features.at(i).GetNode(), false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.Insert("X"+IntegerToString(i,2,'0')+"_"+axonsL1.at(i).pnode.name, axonsL1.at(i).GetGain(), false);
    for(int i=0; i<neuronsL1.Count(); i++)
        db.Insert("N"+"_"+neuronsL1.at(i).name, neuronsL1.at(i).GetNode(), false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.Insert("Y"+IntegerToString(i,2,'0')+"_"+axonsL2.at(i).pnode.name, axonsL2.at(i).GetGain(), false);
    for(int i=0; i<neuronsL2.Count(); i++)
        db.Insert("N"+"_"+neuronsL2.at(i).name, neuronsL2.at(i).GetNode(), false);
    for(int i=0; i<axonsL3.Count(); i++)
        db.Insert("Z"+IntegerToString(i,2,'0')+"_"+axonsL3.at(i).pnode.name, axonsL3.at(i).GetGain(), false);
    db.Insert("diff_raw", diff_raw1, false);
    db.Insert("close_raw", close1, false);
    db.Insert("reserve", 0, true);
}
