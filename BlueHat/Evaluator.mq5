#include "Evaluator.mqh"
Evaluator::Evaluator(IAccuracy* acc) : accuracy_calculator(acc)
{
    sum_accuracy_short = 0;
    sum_accuracy_all_time = 0;
    epoch_counter = 0;
}
float Evaluator::GetAccuracyShort(void) const
{
    return sum_accuracy_short / ACC_SHORT_LEN;
}
float Evaluator::GetAccuracyAllTime(void) const
{
    return sum_accuracy_all_time / (epoch_counter+1);
}
float Evaluator::GetDirectionCorrectnessShort() const
{
    return 0;
}
float Evaluator::GetDirectionCorrectnessAllTime() const
{
    return 0;
}

evaluate_score_t Evaluator::EvaluateTrial(float desired, float base_value, float trial_value)
{
    float base_accuracy = accuracy_calculator.CalculateAccuracy(desired, base_value);
    float trial_accuracy = accuracy_calculator.CalculateAccuracy(desired, trial_value);
    
    switch(FLOAT_CMP(trial_accuracy,base_accuracy))
    {
        case CMP_BIGGER: 
            return SCORE_GOOD;
            break;
        case CMP_NEAR:
            return SCORE_NEUTRAL;
            break;
        case CMP_SMALLER:
            return SCORE_BAD;
            break;
        default:
            assert(false,"");     
            return 0;           
    }
/*    if(desired > 0)
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

*/
}

