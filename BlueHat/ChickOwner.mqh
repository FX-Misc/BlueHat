#include "./Markets/Market.mqh"

#include "./Patterns/Pattern.mqh"
#include "Graphics.mqh"
#include "./globals/ExtendedArrList.mqh"
#include "./globals/assert.mqh"

//enum evaluation_method_t
//{
//    METHOD_DIRECTION,
//    METHOD_ANALOG_DISTANCE,
//    METHOD_ALL,
//};
 
class ChickOwner
{
//private:
//    
public:
    CXArrayList<Pattern*> *patterns;
    Graphics g;
    int patternLen;
    ChickOwner(int patternLen);
    ~ChickOwner();
    void LoadPatterns(Market* m);
    void UpdateInput(const double& c[], const double& d[], const double& o[], const datetime& t[]);
    void SaveDebugInfo(DEBUG_MODE debug_m, int index, double diff_raw1, double close1, datetime time1);
    bool CreateDebugDB(DEBUG_MODE debug_m);
    bool CreateStateDB();
    void report();
    int GetRoughSignal(int currentPos);
};
