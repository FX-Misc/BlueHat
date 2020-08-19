class IAccuracy
{
protected:
public:
    virtual float CalculateAccuracy(float desired, float value)=0;
};