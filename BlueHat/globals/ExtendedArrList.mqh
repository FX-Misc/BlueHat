#include <Generic\ArrayList.mqh>
#include "assert.mqh"

template<typename T>
class CXArrayList : public CArrayList<T>
{
public:
    T at(int index);
    bool AddIfNotFound(T item);
};

template<typename T>
T CXArrayList::at(int index)
{
    assert( (index>=0) && (index<this.Count()), "CXArrayList::at invalid index");
    
    T temp;
    assert(TryGetValue(index, temp) , "CXArrayList::at failed");
    return temp;
}

template<typename T>
bool CXArrayList::AddIfNotFound(T item)
{   //returns true if not found and added
    if(IndexOf(item)==-1)   
    {   //not found
        this.Add(item);
        return true;
    }
    else
        return false;
 }