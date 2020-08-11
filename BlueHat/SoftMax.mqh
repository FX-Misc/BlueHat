#include "INeuron.mqh"
class SoftMax : public INeuron
{
private:
    float OutputCurve(float raw) const;
public:
    ~SoftMax();
    float GetNode();   
    void AddAxon(Axon* ax);   
};
