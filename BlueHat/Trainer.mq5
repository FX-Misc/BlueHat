#include "Trainer.mqh"
#define ACC_SHORT_LEN 1000
Trainer::~Trainer()
{
}
Trainer::Trainer(INode* psm, Evaluator* peval, CXArrayList<Axon*> *pL1, CXArrayList<Axon*> *pL2, CXArrayList<Axon*> *pL3) : pSoftMax(psm), axonsL1(pL1), axonsL2(pL2), axonsL3(pL3), eval(peval)
{
}
void Trainer::Go1Epoch(double new_norm_diff)
{
    double base_value;

    for(int i=0; i<axonsL1.Count(); i++)
        if(axonsL1.at(i).active)
        {
            base_value = GetCurrentOutputN();
            axonsL1.at(i).GainGrow(); //trial grow
            switch( eval.EvaluateTrial( new_norm_diff, base_value, GetCurrentOutputN() ) )
            {
                case SCORE_GOOD:    //all good, positive change
                    axonsL1.at(i).grow_temp_flag = FLAG_GROW;
                    break;
                case SCORE_NEUTRAL:    //no change in the output, keep the existing
                    axonsL1.at(i).grow_temp_flag = FLAG_KEEP;
                    break;
                case SCORE_BAD:    //change in the reverse direction
                    axonsL1.at(i).grow_temp_flag = FLAG_DEGROW;
                    break;
            }
            axonsL1.at(i).GainDeGrow();
        }
        
    for(int i=0; i<axonsL2.Count(); i++)
        if(axonsL2.at(i).active)
        {
            base_value = GetCurrentOutputN();
            axonsL2.at(i).GainGrow(); //trial grow
            switch( eval.EvaluateTrial(new_norm_diff, base_value, GetCurrentOutputN() ) )
            {
                case SCORE_GOOD:    //all good, positive change
                    axonsL2.at(i).grow_temp_flag = FLAG_GROW;
                    break;
                case SCORE_NEUTRAL:    //no change in the output, keep the existing
                    axonsL2.at(i).grow_temp_flag = FLAG_KEEP;
                    break;
                case SCORE_BAD:    //change in the reverse direction
                    axonsL2.at(i).grow_temp_flag = FLAG_DEGROW;
                    break;
            }
            axonsL2.at(i).GainDeGrow();
        }
        
    for(int i=0; i<axonsL3.Count(); i++)
        if(axonsL3.at(i).active)
        {
            base_value = GetCurrentOutputN();
            axonsL3.at(i).GainGrow(); //trial grow
            switch( eval.EvaluateTrial(new_norm_diff, base_value, GetCurrentOutputN() ) )
            {
                case SCORE_GOOD:    //all good, positive change
                    axonsL3.at(i).grow_temp_flag = FLAG_GROW;
                    break;
                case SCORE_NEUTRAL:    //no change in the output, keep the existing
                    axonsL3.at(i).grow_temp_flag = FLAG_KEEP;
                    break;
                case SCORE_BAD:    //change in the reverse direction
                    axonsL3.at(i).grow_temp_flag = FLAG_DEGROW;
                    break;
            }
            axonsL3.at(i).GainDeGrow();
        }
     
    //fixing the changes
    for(int i=0; i<axonsL1.Count(); i++)
        if(axonsL1.at(i).active)
        {
            axonsL1.at(i).GainDegrade();
            switch(axonsL1.at(i).grow_temp_flag)
            {
                case FLAG_GROW:
                    axonsL1.at(i).GainGrow();
                    break;
                case FLAG_DEGROW:
                    axonsL1.at(i).GainDeGrow();
                    break;
                case FLAG_KEEP:
                    break;
            }            
        }
    for(int i=0; i<axonsL2.Count(); i++)
        if(axonsL2.at(i).active)
        {
            axonsL2.at(i).GainDegrade();
            switch(axonsL2.at(i).grow_temp_flag)
            {
                case FLAG_GROW:
                    axonsL2.at(i).GainGrow();
                    break;
                case FLAG_DEGROW:
                    axonsL2.at(i).GainDeGrow();
                    break;
                case FLAG_KEEP:
                    break;
            }            
        }
    for(int i=0; i<axonsL3.Count(); i++)
        if(axonsL3.at(i).active)
        {
            axonsL3.at(i).GainDegrade();
            switch(axonsL3.at(i).grow_temp_flag)
            {
                case FLAG_GROW:
                    axonsL3.at(i).GainGrow();
                    break;
                case FLAG_DEGROW:
                    axonsL3.at(i).GainDeGrow();
                    break;
                case FLAG_KEEP:
                    break;
            }            
        }
}
double Trainer::GetCurrentOutputN(void) const
{
    return SOFT_NORMAL( pSoftMax.GetNode() );
}
