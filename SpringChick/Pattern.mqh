//#include "./globals/ExtendedArrList.mqh"
//#include "./globals/assert.mqh"
#include "./globals/_globals.mqh"

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
    STATUS_CANDIDATE_DIRECT,
    STATUS_CANDIDATE_REVERSE,
    STATUS_CANDIDATE_EITHER,
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
private:
    bool openBar;
    bool bars[MaxPatternLen];
public:
    int ID;
    int DecisionBar;
    quality_t QEndday, QMidday;
    pattern_status_t status;
    Pattern(int id, int len);
    ~Pattern();
    bar_result_t giveBar(int BarNo, double diff);
    void updateMidday(double close);
    void updateEndday(double close);
};
