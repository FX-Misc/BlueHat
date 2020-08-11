#include "IAxonTrain.mqh"
#include "INode.mqh"
#include <Generic\ArrayList.mqh>
class Trainer
{
private:
    CArrayList<IAxonTrain*> axonsL1;
    CArrayList<IAxonTrain*> axonsL2;
    INode* pSoftMax;
    float sum_accuracy_short;
    float sum_accuracy_all_time;   
    int epoch_counter;  //the number of training epochs so far 
public:
    Trainer(INode* psm);
    ~Trainer();
    void Go1Epoch(float new_norm_diff);
    float GetAccuracyShort() const;
    float GetAccuracyAllTime() const;
    float GetCurrentOutput() const;
    void AddAxon(int layer, IAxonTrain* ax);    //Add an Axon created by factory to either axonsL1 or axonsL2
};
