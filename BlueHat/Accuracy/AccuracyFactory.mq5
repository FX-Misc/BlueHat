#include "AccuracyFactory.mqh"
//#include "../globals/assert.mqh"
IAccuracy* AccuracyFactory::CreateAccuracy(evaluation_method_t method)
{
    IAccuracy* acc;
    switch(method)
    {
        case METHOD_ANALOG_DISTANCE:
            acc = new AccuracyAnalog();
            break;
        case METHOD_DIRECTION:
            acc = new AccuracyDirection();
            break;
        default:
            acc = NULL;
            break;
    };
    assert(acc != NULL, "CreateAccuracy failed to create");
    return acc;
}
