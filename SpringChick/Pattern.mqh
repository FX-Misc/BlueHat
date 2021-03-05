//#include "./globals/ExtendedArrList.mqh"
//#include "./globals/assert.mqh"

enum update_result_t
{
    UPDATE_MORE_PLZ,
    UPDATE_SLEEP,
    UPDATE_NOT_ME,
    UPDATE_ITS_ME_POSITIVE,
    UPDATE_ITS_ME_NEGATIVE,
};
 

class Pattern
{
//private:
//    CXArrayList<Axon*> *axonsL3;
public:
    int DecisionBar;
    Pattern(int id);
    ~Pattern();
    update_result_t update(int BarNo, double diff);
};
