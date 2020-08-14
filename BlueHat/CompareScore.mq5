#include "CompareScore.mqh"
evaluate_score_t evaluate(float desired, float base_value, float trial_value)
{
    if(desired > 0)
    {
        switch(FLOAT_CMP(trial_value,base_value))
        {
            case CMP_BIGGER: 
                return SCORE_GOOD;
                break;
            case CMP_NEAR:
                return SCORE_NEUTRAL;
                break;
            case CMP_SMALLER:
                if(base_value<desired)
                    return SCORE_BAD;
                else
                    return SCORE_NEUTRAL;
                break;
            default:
                assert(false,"");     
                return 0;           
        }
    }
    else
    {   //desired < 0
        switch(FLOAT_CMP(trial_value,base_value))
        {
            case CMP_SMALLER: 
                return SCORE_GOOD;
            case CMP_NEAR:
                return SCORE_NEUTRAL;
            case CMP_BIGGER:
                if(base_value>desired)
                    return SCORE_BAD;
                else
                    return SCORE_NEUTRAL;
                break;
            default:
                assert(false,"");   
                return 0;             
        }
    }
}

