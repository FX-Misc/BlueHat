#include "Trainer.mqh"
#define ACC_SHORT_LEN 1000
Trainer::~Trainer()
{
}
Trainer::Trainer(INode* psm, CXArrayList<IAxonTrain*> *pL1, CXArrayList<IAxonTrain*> *pL2) : pSoftMax(psm), axonsL1(pL1), axonsL2(pL2)
{
    sum_accuracy_short = 0;
    sum_accuracy_all_time = 0;
    epoch_counter = 0;
}
void Trainer::Go1Epoch(float new_norm_diff)
{
    float base_value = pSoftMax.GetNode();
}
float Trainer::GetAccuracyShort(void) const
{
    return sum_accuracy_short / ACC_SHORT_LEN;
}
float Trainer::GetAccuracyAllTime(void) const
{
    return sum_accuracy_all_time / (epoch_counter+1);
}
float Trainer::GetCurrentOutput(void) const
{
    return pSoftMax.GetNode();
}
