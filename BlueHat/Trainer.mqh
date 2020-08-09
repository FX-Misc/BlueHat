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
    int epoch_counter;
public:
    Trainer(INode* psm);
    void Go1Epoch(float new_norm_diff);
    float GetAccuracyShort();
    float GetAccuracyAllTime();
    float GetCurrentOutput();
    void AddAxon(int layer, IAxonTrain* ax);
};
