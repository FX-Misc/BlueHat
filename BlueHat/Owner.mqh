#include "Trainer.mqh"
#include "DataBase.mqh"
#include "Evaluator.mqh"
#include "QualityMetrics.mqh"
#include "Features/FeatureFactory.mqh"
#include "Accuracy/AccuracyFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "Neuron.mqh"
#include "/globals/ExtendedArrList.mqh"
#include "globals/assert.mqh"

#define RATE_GROWTH (double)0.01
#define RATE_DEGRADATION (double)0.999
#define AXON_FLOOR (double)0.001
#define AXON_CEILING (double)10

#define MAX_AXONS 50

enum trade_advice_t
{
    TRADE_BUY,
    TRADE_SELL,
    TRADE_KEEP,
    TRADE_NONE,
};
class Owner
{
private:
    CXArrayList<Feature*> features;
    CXArrayList<Neuron*> neuronsL1;
    CXArrayList<Neuron*> neuronsL2;
    CXArrayList<Axon*> *axonsL1;
    CXArrayList<Axon*> *axonsL2;
    CXArrayList<Axon*> *axonsL3;
    Axon* bestL1;
    Axon* bestL2;
    Axon* bestL3;
public:
    Owner();
    ~Owner();
    DataBase db;
    Neuron* softmax;
    Trainer* trainer;
    Evaluator* eval;
    IAccuracy* acc;
    QualityMetrics* quality;
    void CreateNN(evaluation_method_t evm, Market* m);//the database file as input?
    void UpdateInput(const double& c[], const double& d[], int len);
    void SaveDebugInfo(DEBUG_MODE debug_m, int index, double desired_in, double diff_raw1, double close1);
    void Train1Epoch(double desired);
    trade_advice_t GetAdvice();
    bool CreateDebugDB(DEBUG_MODE debug_m);
    bool CreateStateDB();
    void UpdateAxonStats();
    string GetAxonsReport();
    void ResetAxons();
//    trade_advice_t Go1Bar(int index, int history_index, bool logging);
};
