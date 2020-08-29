#include "Axon.mqh"
#include "INode.mqh"
#include "Evaluator.mqh"
#include "/globals/ExtendedArrList.mqh"
class Trainer
{
private:
    CXArrayList<Axon*> *axonsL1;
    CXArrayList<Axon*> *axonsL2;
    CXArrayList<Axon*> *axonsL3;
    INode* pSoftMax;
    Evaluator* eval;
public:
    Trainer(INode* psm, Evaluator* peval, CXArrayList<Axon*> *pL1, CXArrayList<Axon*> *pL2, CXArrayList<Axon*> *pL3);
    ~Trainer();
    void Go1Epoch(float new_norm_diff);
    float GetCurrentOutputN() const;
};
