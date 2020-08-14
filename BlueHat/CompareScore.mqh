#include "globals.mqh"
enum evaluate_score_t
{
    SCORE_GOOD,
    SCORE_NEUTRAL,
    SCORE_BAD,
};
class CompareScore
{
public:
    evaluate_score_t evaluate(float desired, float base_value, float trial_value);
};