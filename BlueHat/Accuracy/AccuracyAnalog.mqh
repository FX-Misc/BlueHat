#include "../globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyAnalog : IAccuracy
{
public:
    float CalculateAccuracy(float desired, float value);
};