#include <Generic\ArrayList.mqh>
#include "assert.mqh"

template<typename T>
class CXArrayList : public CArrayList<T>
{
public:
    T at(int index);
};

template<typename T>
T CXArrayList::at(int index)
{
    assert( (index>=0) && (index<this.Count()), "CXArrayList::at invalid index");
    T temp;
    assert(TryGetValue(index, temp) , "CXArrayList::at failed");
    return temp;
}