//#include "./globals/ExtendedArrList.mqh"
//#include "./globals/assert.mqh"

enum bar_result_t
{
    BAR_MORE_PLZ,
    BAR_SLEEP,
    BAR_NOT_ME,
    BAR_ITS_ME_DIRECT,
    BAR_ITS_ME_REVERSE,
};
 
enum pattern_status_t
{
    STATUS_MORE_PLZ,
    STATUS_SLEEP,
    STATUS_ITS_ME_DIRECT,
    STATUS_ITS_ME_REVERSE,
};

struct quality_t
{
    int count;
    int dirCorrectCnt;
    double DirectionShort;
    double DirectionLong;
    double ProfitShort;
    double ProfitLong;
};

class Pattern
{
//private:
//    CXArrayList<Axon*> *axonsL3;
public:
    int ID;
    int DecisionBar;
    quality_t QEndday, QMidday;
    pattern_status_t status;
    Pattern(int id);
    ~Pattern();
    bar_result_t giveBar(int BarNo, double diff);
    void updateMidday(double close);
    void updateEndday(double close);
};
