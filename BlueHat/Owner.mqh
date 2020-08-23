#include "Trainer.mqh"
#include "SoftMax.mqh"
#include "DataBase.mqh"
#include "Evaluator.mqh"
#include "QualityMetrics.mqh"
#include "Features/FeatureFactory.mqh"
#include "Accuracy/AccuracyFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "Neuron.mqh"
#include "/globals/ExtendedArrList.mqh"
#include "globals/assert.mqh"

#define RATE_GROWTH (float)0.01
#define RATE_DEGRADATION (float)0.9999
#define AXON_FLOOR (float)0.001

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
    CXArrayList<Neuron*> neourons;
    CXArrayList<Axon*> *axonsL1;
    CXArrayList<Axon*> *axonsL2;
public:
    Owner();
    ~Owner();
    DataBase db;
    SoftMax* softmax;
    Trainer* trainer;
    Evaluator* eval;
    IAccuracy* acc;
    QualityMetrics* quality;
    void CreateNN(evaluation_method_t evm);//the database file as input?
    void UpdateInput(const float& c[], int len);
    void SaveDebugInfo(int index, float desired_in);
    void Train1Epoch(float desired);
    trade_advice_t GetAdvice();
    bool CreateDebugDB();
    bool CreateStateDB();
//    trade_advice_t Go1Bar(int index, int history_index, bool logging);
};
