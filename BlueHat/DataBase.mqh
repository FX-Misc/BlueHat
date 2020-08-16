class DataBase
{
private:
    int db; //DataBase handle
public:
    bool OpenDB();
    bool CloseDB();
    bool Insert(string name, float value, bool completed);
};