class IAccuracy
{
protected:
public:
    virtual double CalculateAccuracy(double desired, double value)=0;
};