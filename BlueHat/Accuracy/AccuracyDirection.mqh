#include "../globals/_globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyDirection : public IAccuracy
{
public:
    double CalculateAccuracy(double desired, double value);
};