//#include "./Markets/Market.mqh"

#include "./Patterns/Pattern.mqh"
#include "Graphics.mqh"
#include "./globals/ExtendedArrList.mqh"
#include "./globals/assert.mqh"

enum evaluation_method_t
{
    METHOD_DIRECTION,
    METHOD_ANALOG_DISTANCE,
    METHOD_ALL,
};
 
enum trade_advice_t
{
    TRADE_BUY,
    TRADE_SELL,
    TRADE_KEEP,
    TRADE_NONE,
};
class ChickOwner
{
//private:
//    
public:
    CXArrayList<Pattern*> *patterns;
    Graphics g;
    int patternLen;
    Owner(int patternLen);
    ~Owner();
    void LoadPatterns(Market* m);
    void UpdateInput(const double& c[], const double& d[], const double& o[], const datetime& t[]);
    void SaveDebugInfo(DEBUG_MODE debug_m, int index, double diff_raw1, double close1, datetime time1);
    bool CreateDebugDB(DEBUG_MODE debug_m);
    bool CreateStateDB();
    void report();
};
