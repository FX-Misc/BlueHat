class DataBase
{
private:
    int db; //DataBase handle
public:
    bool OpenDB();
    bool CloseDB();
    bool AddDBGTBLItem(string name, bool completed);
    bool Insert(string name, float value, bool completed);
};