#include "Trainer.mqh"
#include "SoftMax.mqh"
#include "Features/FeatureFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "INeuron.mqh"
#include "/globals/ExtendedArrList.mqh"
#include "globals/assert.mqh"

#define RATE_GROWTH (float)0.01
#define RATE_DEGRADATION (float)0.995

class Owner
{
private:
    CXArrayList<INode*> features;
    CXArrayList<INeuron*> ineourons;
    CXArrayList<IAxonTrain*> *axonsL1;
    CXArrayList<IAxonTrain*> *axonsL2;

public:
    Owner();
    ~Owner();
    SoftMax* softmax;
    Trainer* trainer;
    void CreateNN();//the database file as input?
    
};
