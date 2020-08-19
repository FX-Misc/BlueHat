#include "/AccuracyDirection.mqh"
#include "/AccuracyAnalog.mqh"
 
#include "/../IAccuracy.mqh"

enum evaluation_method_t
{
    METHOD_DIRECTION,
    METHOD_ANALOG_DISTANCE,
};
 
class AccuracyFactory
{
public:
    IAccuracy* CreateAccuracy(evaluation_method_t method);
};