#include "INeuron.mqh"
class SoftMax : public INeuron
{
private:
    float OutputCurve(float raw);
public:
    float GetNode();    
};
