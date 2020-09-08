#include "DataBase.mqh"
bool DataBase::CloseDB(void)
{
    if(db==0 || db==INVALID_HANDLE)
        return false;
        
    DatabaseClose(db);
    return true;
}
bool DataBase::OpenDB(void)
{
    string filename = "BlueHat.sqlite";
    db=DatabaseOpen(filename, DATABASE_OPEN_READWRITE | DATABASE_OPEN_CREATE |DATABASE_OPEN_COMMON);
    if(db==INVALID_HANDLE)
    {
        Print("DB: ", filename, " open failed with code ", GetLastError());
        return false;
    }
    if(DatabaseTableExists(db, "DEBUG"))
    {
        //--- delete the table
        if(!DatabaseExecute(db, "DROP TABLE DEBUG"))
        {
            Print("Failed to drop table DEBUG with code ", GetLastError());
            DatabaseClose(db);
            return false;
        }
    }
/*    if(!DatabaseExecute(db, "CREATE TABLE DEBUG("
                       "ID INT PRIMARY KEY     NOT NULL,"
                       "feature0 REAL,""feature1 REAL,""feature2 REAL,"
                       "axonl10 REAL,""AXONL11 REAL,""AXONL12 REAL,""AXONL13 REAL,"
                       "neuron0 REAL,""neuron1 REAL,""neuron2 REAL,"
                       "axonl20 REAL,""AXONL21 REAL,""AXONL22 REAL,""AXONL23 REAL,"
                       "softmax   REAL );"))
    {
        Print("DB: ", filename, " create table DEBUG failed with code ", GetLastError());
        DatabaseClose(db);
        return false;
    }
*/


    if(DatabaseTableExists(db, "STATE"))
    {
        //--- delete the table
        if(!DatabaseExecute(db, "DROP TABLE STATE"))
        {
            Print("Failed to drop table STATE with code ", GetLastError());
            DatabaseClose(db);
            return false;
        }
    }
/*    if(!DatabaseExecute(db, "CREATE TABLE STATE("
                       "ID INT PRIMARY KEY     NOT NULL,"
                       "NAME           TEXT    NOT NULL,"
                       "Gain            INT     NOT NULL,"
                       "VALUE         REAL );"))
    {
        Print("DB: ", filename, " create table failed with code ", GetLastError());
        DatabaseClose(db);
        return false;
    }
*/    
    return true;
}
bool DataBase::AddDBGTBLItem(string name, bool completed)
{
    static string str1="CREATE TABLE DEBUG( ID INT PRIMARY KEY     NOT NULL";
 
    string type;
    if(name=="time")
        type=" TEXT";
    else
        type=" REAL";
    if(!completed)
        str1+=","+name+type;
    else
    {
        str1+=","+name+type+");";
        if(!DatabaseExecute(db,str1))
        {
            Print("DB: create table DEBUG failed with code ", GetLastError());
            Print(str1);
            DatabaseClose(db);
            return false;
        }
        str1="CREATE TABLE DEBUG( ID INT PRIMARY KEY     NOT NULL";      
    }
    return true;
}

int DataBase::CreateRequest(string header)
{
    int request=0;
    request = DatabasePrepare(db, "SELECT "+header+" FROM NN");
    if(request==INVALID_HANDLE)
    {
        assert(false, "DB: unsuccessful request");
        DatabaseClose(db);
        return DB_ERROR_INT;
    }
    return request;
}
void DataBase::FinaliseRequest(int request)
{
    DatabaseFinalize(request);
}

string DataBase::ReadNextString(int request)
{
    if( ! DatabaseRead(request))
        return DB_END_STR;

    string str;
    if( ! DatabaseColumnText(request, 0, str))
    {
        Print("DB: Read failed");
        return DB_ERROR_STR;
    }
    if(str=="_")
        return DB_END_STR;
    return str;
}

bool DataBase::Insert(string name, double value, bool completed)
{
    static string str1="INSERT INTO DEBUG (";
    static string str2=") VALUES (";
    static string str3="); ";
    
    string number_str="";
    if(name=="ID")
        number_str=IntegerToString((int)value);
    else if(name=="time")
        number_str="'"+TimeToString((datetime)value)+"'";
    else
        number_str=DoubleToString(value);
        
    str1+=name+(completed?"":",");
    str2+=number_str+(completed?"":",");
    if(completed)
    {
        if(!DatabaseExecute(db,str1+str2+str3))
        {
            Print("DB: ", " insert failed with code ", GetLastError());
            Print(str1+str2+str3);
            return false;
        }
        str1="INSERT INTO DEBUG (";
        str2=") VALUES (";
        str3="); ";
    }
        
    
//    if(!DatabaseExecute(db, "INSERT INTO DEBUG ( ID , " +name+ " ) VALUES (  " +IntegerToString(id)+" , 0.2 ); "))
    return true;
}