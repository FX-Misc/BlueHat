#include "Trainer.mqh"
#include "SoftMax.mqh"
#include "Features/FeatureFactory.mqh"
#include "Neurons/NeuronFactory.mqh"
#include "INeuron.mqh"
#include "/globals/ExtendedArrList.mqh"
//#include "Trainer"

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

/*#include "INode.mqh"
#include "IAxonTrain.mqh"
#include "Axon.mqh"

#include "/Features/FeatureCheater.mqh"

#include "/Neurons/NeuronSUM.mqh"

 
class NNFactory
{
private:
    SoftMax* sf;
    Trainer* tr;
public:
    NNFactory(SoftMax* psf, Trainer* ptr);
    ~NNFactory();
    void CreateNNetwork();

*/