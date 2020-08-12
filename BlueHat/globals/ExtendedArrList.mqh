#include <Generic\ArrayList.mqh>

template<typename T>
class CXArrayList : public CArrayList<T>
{
public:
    T at(int index);
};

template<typename T>
T CXArrayList::at(int index)
{
    T temp;
    if(TryGetValue(index, temp))
        return temp;
    else
        return NULL;
}