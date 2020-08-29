#include "../globals/_globals.mqh"
#include "../IAccuracy.mqh"
class AccuracyAnalog : public IAccuracy
{
public:
    double CalculateAccuracy(double desired, double value);
};