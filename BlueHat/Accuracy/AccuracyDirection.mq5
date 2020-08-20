#include "AccuracyDirection.mqh"
float AccuracyDirection::CalculateAccuracy(float desired, float value)
{
    if(FLOAT_SIGN(desired)==FLOAT_SIGN(value))
        return MathAbs(value);
    else
        return -MathAbs(value);
}