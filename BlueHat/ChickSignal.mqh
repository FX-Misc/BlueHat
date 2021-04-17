#include "/globals/ExtendedArrList.mqh"
class ChickSignal
{
private:
    CXArrayList<Pattern*> *patterns;
public:
    ChickSignal(CXArrayList<Pattern*> *p);
    int GetIncSignal();
    ~ChickSignal();
};
