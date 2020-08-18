#include "../globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyDirection : public IAccuracy
{
public:
    float CalculateAccuracy(float desired, float value);
};