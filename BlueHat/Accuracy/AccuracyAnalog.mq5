#include "AccuracyAnalog.mqh"
float AccuracyAnalog::CalculateAccuracy(float desired, float value)
{
    return MathAbs(value-desired);
}