//#include "./globals/ExtendedArrList.mqh"
//#include "./globals/assert.mqh"
//#include "./globals/_globals.mqh"
#include <Generic\HashMap.mqh>

class Graphics
{
private:
    CHashMap<datetime,string> map;
public:
    void DisplayVert(string s, datetime t, double p);
    void DisplyHor(string s, datetime t, double p);
    void Clear();
};
