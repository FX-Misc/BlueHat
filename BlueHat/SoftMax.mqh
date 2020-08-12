class SoftMax : public INode
{
private:
    float OutputCurve(float raw) const;

public:
    CXArrayList<IAxonTrain*> *axons;
    SoftMax(CXArrayList<IAxonTrain*> *ax);
    float GetNode();   
};
