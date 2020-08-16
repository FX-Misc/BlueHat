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
    if(!DatabaseExecute(db, "CREATE TABLE DEBUG("
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
    if(!DatabaseExecute(db, "CREATE TABLE STATE("
                       "ID INT PRIMARY KEY     NOT NULL,"
                       "NAME           TEXT    NOT NULL,"
                       "Gain            INT     NOT NULL,"
                       "VALUE         REAL );"))
    {
        Print("DB: ", filename, " create table failed with code ", GetLastError());
        DatabaseClose(db);
        return false;
    }
    
    return true;
}
bool DataBase::Insert(string name, float value)
{
    static int i=0;
    i++;
//    if(!DatabaseExecute(db, "INSERT INTO DEBUG (" +name+ ") VALUES ( 0.1 ); "))
    if(!DatabaseExecute(db, "INSERT INTO DEBUG ( ID , softmax ) VALUES (  " +IntegerToString(i)+" , 0.2 ); "))
    {
        Print("DB: ", " insert failed with code ", GetLastError());
        return false;
    }
    return true;
}