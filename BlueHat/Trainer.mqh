#include "Axon.mqh"
#include "INode.mqh"
#include "CompareScore.mqh"
#include "/globals/ExtendedArrList.mqh"
class Trainer
{
private:
    CXArrayList<Axon*> *axonsL1;
    CXArrayList<Axon*> *axonsL2;
    INode* pSoftMax;
    float sum_accuracy_short;
    float sum_accuracy_all_time;   
    int epoch_counter;  //the number of training epochs so far 
    CompareScore compare_score;
public:
    Trainer(INode* psm, CXArrayList<Axon*> *pL1, CXArrayList<Axon*> *pL2);
    ~Trainer();
    void Go1Epoch(float new_norm_diff, bool degradation);
    float GetAccuracyShort() const;
    float GetAccuracyAllTime() const;
    float GetCurrentOutput() const;
};
