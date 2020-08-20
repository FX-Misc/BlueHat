#include "Neuron.mqh"
class SoftMax : public Neuron
{
private:
    float OutputCurve(float raw) const;

public:
    float GetNode();   
    void AddAxon(Axon* ax);
};
