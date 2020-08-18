#include "globals.mqh"
enum evaluate_score_t
{
    SCORE_GOOD,
    SCORE_NEUTRAL,
    SCORE_BAD,
};
class Evaluator
{
private:
    float sum_accuracy_short;
    float sum_accuracy_all_time;   
    int epoch_counter;  //the number of training epochs so far 

public:
    Evaluator();
    evaluate_score_t EvaluateTrial(float desired, float base_value, float trial_value);
    float GetAccuracyShort() const;
    float GetAccuracyAllTime() const;
    float GetDirectionCorrectnessShort() const;
    float GetDirectionCorrectnessAllTime() const;
};