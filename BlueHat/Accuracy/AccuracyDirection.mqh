#include "../globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyDirection : IAccuracy
{
public:
    float CalculateAccuracy(float desired, float value);
};