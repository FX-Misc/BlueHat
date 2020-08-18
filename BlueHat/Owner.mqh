#include "Trainer.mqh"
#include "SoftMax.mqh"
#include "DataBase.mqh"
#include "Evaluator.mqh"
#include "Features/FeatureFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "INeuron.mqh"
#include "/globals/ExtendedArrList.mqh"
#include "globals/assert.mqh"

#define RATE_GROWTH (float)0.01
#define RATE_DEGRADATION (float)0.9999
#define AXON_FLOOR (float)0.001

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
    CXArrayList<INeuron*> ineourons;
    CXArrayList<Axon*> *axonsL1;
    CXArrayList<Axon*> *axonsL2;
public:
    Owner();
    ~Owner();
    DataBase db;
    SoftMax* softmax;
    Trainer* trainer;
    Evaluator* eval;
    void CreateNN(evaluation_method_t evm);//the database file as input?
    void UpdateInput(int index, int history_index);
    void SaveDebugInfo(int index, float desired_in);
    void Train1Epoch(float desired);
    trade_advice_t GetAdvice();
    bool CreateDebugDB();
    bool CreateStateDB();
//    trade_advice_t Go1Bar(int index, int history_index, bool logging);
};
