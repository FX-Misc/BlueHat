#include "globals/_globals.mqh"
#include "IAccuracy.mqh"
enum evaluate_score_t
{
    SCORE_GOOD,
    SCORE_NEUTRAL,
    SCORE_BAD,
};
class Evaluator
{
public:
    evaluate_score_t EvaluateTrial(double desired, double base_value, double trial_value, IAccuracy* acc);
};