#include "AccuracyDirection.mqh"
double AccuracyDirection::CalculateAccuracy(double desired, double value)
{
    if(FLOAT_SIGN(desired)==FLOAT_SIGN(value))
        return MathAbs(value);
    else
        return -MathAbs(value);
}