#include "Market.mqh"
#include "DataBase.mqh"
//#include "Evaluator.mqh"
//#include "QualityMetrics.mqh"
//#include "Features/FeatureFactory.mqh"
//#include "Neurons/NeuronFactory.mqh"
//#include "Neuron.mqh"
#include "./globals/ExtendedArrList.mqh"
#include "./globals/assert.mqh"
//#include "/Accuracy/AccuracyDirection.mqh"
//#include "/Accuracy/AccuracyAnalog.mqh"
//#include "/IAccuracy.mqh"

enum evaluation_method_t
{
    METHOD_DIRECTION,
    METHOD_ANALOG_DISTANCE,
    METHOD_ALL,
};
 
enum trade_advice_t
{
    TRADE_BUY,
    TRADE_SELL,
    TRADE_KEEP,
    TRADE_NONE,
};
class Owner
{
//private:
//    CXArrayList<Axon*> *axonsL3;
public:
    Owner();
    ~Owner();
    DataBase db;
//    Trainer* trainer;
    //Evaluator* eval;
    //IAccuracy* accDir;
    //IAccuracy* accAnalog;
    //QualityMetrics* quality;
    void CreateNN(Market* m);
    void UpdateInput(const double& c[], const double& d[], int len);
    void SaveDebugInfo(DEBUG_MODE debug_m, int index, double diff_raw1, double close1, datetime time1);
    //void Train1Epoch(double desired, double desired_scaled, evaluation_method_t evm);
    //trade_advice_t GetAdvice();
    bool CreateDebugDB(DEBUG_MODE debug_m);
    bool CreateStateDB();
//    trade_advice_t Go1Bar(int index, int history_index, bool logging);
};
