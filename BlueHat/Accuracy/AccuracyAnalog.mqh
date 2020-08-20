#include "../globals/_globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyAnalog : public IAccuracy
{
public:
    float CalculateAccuracy(float desired, float value);
};