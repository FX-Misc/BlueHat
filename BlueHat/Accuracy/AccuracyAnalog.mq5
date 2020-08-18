#include "AccuracyAnalog.mqh"
float AccuracyAnalog::CalculateAccuracy(float desired, float value)
{
    return (2-MathAbs(value-desired))/2;
}