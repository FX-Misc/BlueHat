#include "Trainer.mqh"
#define ACC_SHORT_LEN 1000
Trainer::Trainer(INode* psm) : pSoftMax(psm)
{
    sum_accuracy_short = 0;
    sum_accuracy_all_time = 0;
    epoch_counter = 0;
}
void Trainer::Go1Epoch(float new_norm_diff)
{
    //TODO: reform to the Absolute Agressive method, AAepoch.py
}
float Trainer::GetAccuracyShort(void)
{
    return sum_accuracy_short / ACC_SHORT_LEN;
}
float Trainer::GetAccuracyAllTime(void)
{
    return sum_accuracy_all_time / (epoch_counter+1);
}
float Trainer::GetCurrentOutput(void)
{
    return pSoftMax.GetNode();
}
void Trainer::AddAxon(int layer, IAxonTrain* ax)
{
    switch(layer)
    {
        case 1:
            axonsL1.Add(ax);
            break;
        case 2:
        default:
            axonsL2.Add(ax);
            break;
    }
}
