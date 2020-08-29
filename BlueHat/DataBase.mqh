#define DB_END_INT  (-1)
#define DB_ERROR_INT  (-2)
#define DB_END_STR  ("end")
#define DB_ERROR_STR  ("error")
class DataBase
{
private:
    int db; //DataBase handle
public:
    bool OpenDB();
    bool CloseDB();
    bool AddDBGTBLItem(string name, bool completed);
    bool Insert(string name, double value, bool completed);
    int CreateRequest(string header);
    void FinaliseRequest(int request);
    string ReadNextString(int request);
    int ReadNextInt(int request);
};