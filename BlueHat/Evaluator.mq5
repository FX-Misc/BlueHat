#include "Evaluator.mqh"
evaluate_score_t Evaluator::EvaluateTrial(double desired, double base_value, double trial_value, IAccuracy* acc)
{
    double base_accuracy = acc.CalculateAccuracy(desired, base_value);
    double trial_accuracy = acc.CalculateAccuracy(desired, trial_value);
    
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
}

