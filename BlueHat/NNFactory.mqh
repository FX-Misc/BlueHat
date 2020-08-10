#include "SoftMax.mqh"
#include "Trainer.mqh"
#include "INode.mqh"
#include "IAxonTrain.mqh"
#include "Axon.mqh"

#include "/Features/FeatureCheater.mqh"

#include "/Neurons/NeuronSUM.mqh"

#define RATE_GROWTH (float)0.01
#define RATE_DEGRADATION (float)0.995
 
class NNFactory
{
public:
    void CreateNNetwork(SoftMax* sf, Trainer* tr);
};