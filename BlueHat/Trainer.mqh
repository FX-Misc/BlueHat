#include "IAxonTrain.mqh"
#include "INode.mqh"
#include "/globals/ExtendedArrList.mqh"
class Trainer
{
private:
    CXArrayList<IAxonTrain*> *axonsL1;
    CXArrayList<IAxonTrain*> *axonsL2;
    INode* pSoftMax;
    float sum_accuracy_short;
    float sum_accuracy_all_time;   
    int epoch_counter;  //the number of training epochs so far 
public:
    Trainer(INode* psm, CXArrayList<IAxonTrain*> *pL1, CXArrayList<IAxonTrain*> *pL2);
    ~Trainer();
    void Go1Epoch(float new_norm_diff);
    float GetAccuracyShort() const;
    float GetAccuracyAllTime() const;
    float GetCurrentOutput() const;
};
