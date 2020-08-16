#include "Trainer.mqh"
#include "SoftMax.mqh"
#include "DataBase.mqh"
#include "Features/FeatureFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "INeuron.mqh"
#include "/globals/ExtendedArrList.mqh"
#include "globals/assert.mqh"

#define RATE_GROWTH (float)0.01
#define RATE_DEGRADATION (float)0.995

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
    CXArrayList<IAxonTrain*> *axonsL1;
    CXArrayList<IAxonTrain*> *axonsL2;
public:
    Owner();
    ~Owner();
    DataBase db;
    SoftMax* softmax;
    Trainer* trainer;
    void CreateNN();//the database file as input?
    void UpdateInput(int index, int history_index);
    void SaveDebugInfo(int index);
    void Train1Epoch(float desired);
    trade_advice_t GetAdvice();
    bool CreateDebugDB();
    bool CreateStateDB();
//    trade_advice_t Go1Bar(int index, int history_index, bool logging);
};
