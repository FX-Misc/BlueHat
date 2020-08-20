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
private:
    IAccuracy* accuracy_calculator;
public:
    Evaluator(IAccuracy* acc);
    evaluate_score_t EvaluateTrial(float desired, float base_value, float trial_value);
};