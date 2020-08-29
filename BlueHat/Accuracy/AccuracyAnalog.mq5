#include "AccuracyAnalog.mqh"
double AccuracyAnalog::CalculateAccuracy(double desired, double value)
{
    return (2-MathAbs(value-desired))/2;
}