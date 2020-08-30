#include "Evaluator.mqh"
Evaluator::Evaluator(IAccuracy* acc) : accuracy_calculator(acc)
{
}
evaluate_score_t Evaluator::EvaluateTrial(double desired, double base_value, double trial_value)
{
    double base_accuracy = accuracy_calculator.CalculateAccuracy(desired, base_value);
    double trial_accuracy = accuracy_calculator.CalculateAccuracy(desired, trial_value);
    
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

