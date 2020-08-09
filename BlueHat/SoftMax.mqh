#include "INeuron.mqh"
class SoftMax : public INeuron
{
private:
    float OutputCurve(float raw) const;
public:
    float GetNode();    
};
