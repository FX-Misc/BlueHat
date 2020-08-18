#include "../../BlueHat/Owner.mqh"
//#include "../../BlueHat/Trainer.mqh"

#property script_show_inputs
input bool debug=true;
input evaluation_method_t evaluation_method = METHOD_ANALOG_DISTANCE;

void OnStart()
{
    float desired;
    
    Print("Hi there");
    assert(1>0,"test");
   

    Owner owner();
    owner.CreateNN(evaluation_method);
    owner.db.OpenDB();
    owner.CreateDebugDB();
    owner.CreateStateDB();
    
    for(int i=0; i< 1000; i++)
    {
        desired = (float)0.1;
        owner.UpdateInput(i,1000);
        if(debug)
            owner.SaveDebugInfo(i, desired);
        owner.Train1Epoch(desired);
        owner.GetAdvice();
    }
        
    owner.db.CloseDB();
    Print("Bye");
}

//snippet
/*
DataBaseExport to save a table as csv

string request_text=StringFormat("INSERT INTO DEALS (ID,ORDER_ID,POSITION_ID,TIME,TYPE,ENTRY,SYMBOL,VOLUME,PRICE,PROFIT,SWAP,COMMISSION,MAGIC,REASON)"
                                       "VALUES (%d, %d, %d, %d, %d, %d, '%s', %G, %G, %G, %G, %G, %d, %d)",
                                       deal_ticket, order_ticket, position_ticket, time, type, entry, symbol, volume, price, profit, swap, commission, magic, reason);
*/

/*    string filename = "test.sqlite";
    int db=DatabaseOpen(filename, DATABASE_OPEN_READWRITE | DATABASE_OPEN_CREATE |DATABASE_OPEN_COMMON);
    if(db==INVALID_HANDLE)
    {
        Print("DB: ", filename, " open failed with code ", GetLastError());
        return;
    }
    if(DatabaseTableExists(db, "COMPANY"))
    {
        //--- delete the table
        if(!DatabaseExecute(db, "DROP TABLE COMPANY"))
        {
            Print("Failed to drop table COMPANY with code ", GetLastError());
            DatabaseClose(db);
            return;
        }
    }
//--- create the COMPANY table 
    if(!DatabaseExecute(db, "CREATE TABLE COMPANY("
                       "ID INT PRIMARY KEY     NOT NULL,"
                       "NAME           TEXT    NOT NULL,"
                       "AGE            INT     NOT NULL,"
                       "ADDRESS        CHAR(50),"
                       "SALARY         REAL );"))
    {
        Print("DB: ", filename, " create table failed with code ", GetLastError());
        DatabaseClose(db);
        return;
    }
    
    
    
    
    
    
    if(!DatabaseExecute(db, "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1,'Paul',32,'California',25000.00); "
                       "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2,'Allen',25,'Texas',15000.00); "
                       "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (3,'Teddy',23,'Norway',20000.00);"
                       "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (4,'Mark',25,'Rich-Mond',65000.00);"))
    {
        Print("DB: ", filename, " insert failed with code ", GetLastError());
        DatabaseClose(db);
        return;
    }     
//--- create a query and get a handle for it
    int request=DatabasePrepare(db, "SELECT * FROM COMPANY WHERE SALARY>15000");
    if(request==INVALID_HANDLE)
    {
    
        Print("DB: ", filename, " request failed with code ", GetLastError());
        DatabaseClose(db);
        return;
    }
    //--- print all entries with the salary greater than 15000
    int    id, age;
    string name, address;
    double salary;
    Print("Persons with salary > 15000:");
    for(int i=0; DatabaseRead(request); i++)
    {
        //--- read the values of each field from the obtained entry
        if(DatabaseColumnInteger(request, 0, id) && DatabaseColumnText(request, 1, name) &&
                    DatabaseColumnInteger(request, 2, age) && DatabaseColumnText(request, 3, address) && DatabaseColumnDouble(request, 4, salary))
            Print(i, ":  ", id, " ", name, " ", age, " ", address, " ", salary);
        else
        {
            Print(i, ": DatabaseRead() failed with code ", GetLastError());
            DatabaseFinalize(request);
            DatabaseClose(db);
            return;
        }
    }
    //--- remove the query after use
    DatabaseFinalize(request);     
         
    DatabaseClose(db);

*/