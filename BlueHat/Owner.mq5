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
int Owner::GetFeatureNo(string fe_name)
{
    for(int i=0; i<features.Count(); i++)
        if(features.at(i).name == fe_name)
            return i;
    return -1;
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
    string s;
    string temps[2]; 
    req = db.CreateRequest("AxonsFeID");
    s = db.ReadNextString(req);
    while(s!=DB_END_STR)
    {
        assert(s!=DB_ERROR_STR,"DB ERROR IN NN");
        assert(StringSplit(s,'=',temps)==2,"wrong format in NN");
        int axNo = (int)StringToInteger(temps[0]);
        int feNo = GetFeatureNo(temps[1]);
        axonsL1.Add( new Axon(features.at(feNo), RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING) );
        assert(axNo==axonsL1.Count()-1,"wrong axon no in NN");
        s = db.ReadNextString(req);
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
        axonsL2.Add( new Axon(neourons.at(j), RATE_DEGRADATION, RATE_GROWTH, AXON_FLOOR, AXON_CEILING) );
    Print(axonsL2.Count()," Axons(L2) created");
//==================Softmax
    softmax = new NeuronSUM();
    for(int j=0; j<axonsL2.Count(); j++)
        softmax.AddAxon(axonsL2.at(j));
//==================Others
    acc = acf.CreateAccuracy(evm);
    eval = new Evaluator(acc);
    trainer = new Trainer(softmax, eval, axonsL1, axonsL2);
    quality = new QualityMetrics();
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
        db.AddDBGTBLItem("_"+IntegerToString(i,2,'0')+features.at(i).name,false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.AddDBGTBLItem("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(GetFeatureNo(((Feature*)(axonsL1.at(i).pnode)).name),2,'0'),false);
    for(int i=0; i<neourons.Count(); i++)
        db.AddDBGTBLItem("N"+IntegerToString(i,2,'0'),false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.AddDBGTBLItem("Y"+IntegerToString(i,2,'0'),false);
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
        db.Insert("_"+IntegerToString(i,2,'0')+features.at(i).name, features.at(i).GetNode(), false);
    for(int i=0; i<axonsL1.Count(); i++)
        db.Insert("X"+IntegerToString(i,2,'0')+"_"+IntegerToString(GetFeatureNo(((Feature*)(axonsL1.at(i).pnode)).name),2,'0'), axonsL1.at(i).GetGain(), false);
    for(int i=0; i<neourons.Count(); i++)
        db.Insert("N"+IntegerToString(i,2,'0'), neourons.at(i).GetNode(), false);
    for(int i=0; i<axonsL2.Count(); i++)
        db.Insert("Y"+IntegerToString(i,2,'0'), axonsL2.at(i).GetGain(), false);
    db.Insert("reserve", 0, true);
}
/*2020.08.26 16:44:56.296	BlueHat (EURUSD,H1)	CREATE TABLE DEBUG( ID INT PRIMARY KEY    
 NOT NULL,desired REAL,softmax REAL,DiffShort REAL,DiffLong REAL,DiffAll REAL,DirShort REAL,DirLong REAL,DirAll REAL,
 00feCheater REAL,01feBiasP REAL,02feBiasN REAL,03feBiasZ REAL,04feRandom REAL,05feRepeatL REAL,
 06fe3DiffMean REAL,X00_00 REAL,X01_01 REAL,X02_02 REAL,X03_03 REAL,X04_04 REAL,X05_05 REAL,
 X06_06 REAL,X07_06 REAL,X08_06 REAL,X09_06 REAL,N00 REAL,N01 REAL,N02 REAL,Y00 REAL,Y01 REAL,Y02 REAL,
 reserve REAL);
*/