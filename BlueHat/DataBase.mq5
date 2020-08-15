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
                       "NAME           TEXT    NOT NULL,"
                       "SECTION            INT     NOT NULL,"
                       "VALUE         REAL );"))
    {
        Print("DB: ", filename, " create table failed with code ", GetLastError());
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
