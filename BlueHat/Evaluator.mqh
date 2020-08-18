#include "globals.mqh"
enum evaluation_method_t
{
    METHOD_DIRECTION,
    METHOD_ANALOG_DISTANCE,
};
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
    evaluation_method_t method;
    float SampleCorrectnessAnalog(float desired, float value) const;
    float SampleCorrectnessDirection(float desired, float value) const;

public:
    Evaluator(evaluation_method_t evm);
    evaluate_score_t EvaluateTrial(float desired, float base_value, float trial_value);
    float GetAccuracyShort() const;
    float GetAccuracyAllTime() const;
    float GetDirectionCorrectnessShort() const;
    float GetDirectionCorrectnessAllTime() const;
};