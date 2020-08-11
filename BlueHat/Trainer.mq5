#include "Trainer.mqh"
#define ACC_SHORT_LEN 1000
Trainer::~Trainer()
{
Print("del ",axonsL1.Count()," ",axonsL2.Count());
    IAxonTrain* ax;
    for(int i=axonsL1.Count()-1; i>=0; i--)
    {
        axonsL1.TryGetValue(i,ax);
        delete ax;
    }
    for(int i=axonsL2.Count()-1; i>=0; i--)
    {
        axonsL2.TryGetValue(i,ax);
        delete ax;
    }
    Print("d");
//    delete axonsL1;
//    delete axonsL2;
}
Trainer::Trainer(INode* psm) : pSoftMax(psm)
{
    sum_accuracy_short = 0;
    sum_accuracy_all_time = 0;
    epoch_counter = 0;
}
void Trainer::Go1Epoch(float new_norm_diff)
{
    //TODO: reform to the Absolute Aggressive method, AAepoch.py
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
void Trainer::AddAxon(int layer, IAxonTrain* ax)
{
    switch(layer)
    {
        case 0:
            axonsL1.Add(ax);
            break;
        case 1:
        default:
            axonsL2.Add(ax);
            break;
    }
}
