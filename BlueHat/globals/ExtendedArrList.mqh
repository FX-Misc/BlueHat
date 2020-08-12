#include <Generic\ArrayList.mqh>

template<typename T>
class ExtendedArrList : public CArrayList<T>
{
public:
    T at(int index);
};

template<typename T>
T ExtendedArrList::at(int index)
{
    T temp;
    if(TryGetValue(index, temp))
        return temp;
    else
        return NULL;
}