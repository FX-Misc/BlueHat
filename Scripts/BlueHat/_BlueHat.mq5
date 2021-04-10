#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/ChickOwner.mqh"
#include "../../BlueHat/Markets/Market.mqh"
#include "../../BlueHat/Markets/MarketFactory.mqh"
#include "../../BlueHat/globals/_globals.mqh"
 
#property script_show_inputs

input bool skip_1st_monday=false;
input bool skip_1st_morning=false;
input markets_t market_type=MARKET_SCRIPT_REAL;
input DEBUG_MODE debug_mode=DEBUG_NONE;//DEBUG_VERBOSE;
input double min_softmax=0.001;
input int depth=1000;
input evaluation_method_t evaluation_method = METHOD_DIRECTION;
input axon_value_t axon_value_method = AXON_METHOD_GAIN;

input int PatternLen=3;
input int MiddayBar=6; //6 for M15
input int EnddayBar=11; 
input int shortPeriod=5;    //shortPeriod 5 normal. 0 only last value
input int longPeriod=20;     //longPeriod 20 normal. 1 50-50

int   Pattern::shortP=shortPeriod;
int   Pattern::longP=longPeriod;

void OnStart()
{
    double desired,desired_scaled;
    
    Print("Hi there");
    assert(1>0,"test");

    Owner owner();
    MarketFactory mf;
    Market* market = mf.CreateMarket(market_type, true);
    market.Initialise(depth); //0 for full history
    ChickOwner chickowner(PatternLen);
    chickowner.LoadPatterns(market);
        
//!!    market.UpdateBuffers(0);
//Not sure what is this line for. removed cause not compatible with EA market

//    Print("his01:",market.history[0], " ", market.history[1],"close01:",market.close[0], " ", market.close[1]);

    owner.db.OpenDB();
    owner.CreateNN(market, axon_value_method, min_softmax);
    owner.CreateDebugDB(debug_mode);
    owner.CreateStateDB();
    wow
    market.UpdateBuffers(market.oldest_available);
    owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
    int len_div_10=(market.oldest_available-1)/10;
    for(int i=market.oldest_available-1; i>=0; i--)
    {

//        if(i%400==0)//Temporary: reset axons priodically
//            owner.ResetAxons();
        market.UpdateBuffers(i);
        //Note: here, close[0] is not used at all just for compatiblity with EA, where close[0] is the uncompleted bar
        //Note: index+1 is the last completed Bar, so the one that we need
        //If not going through the history, do UpdateInput(+2) before the loop; then the loop uses close(+1) as desired to train the 1st time
        desired = market.diff_norm[1];
        desired_scaled = market.diff_raw[1] * market.diff_norm_factor;
        if(!early_morning_skip(market.times[1], skip_1st_monday, skip_1st_morning))
        {
            owner.quality.UpdateMetrics(desired, owner.softmax.GetNode(), market.tick_convert_factor * market.diff_raw[1]);
            owner.Train1Epoch(desired, desired_scaled, evaluation_method);
        }
        owner.UpdateAxonStats();
        owner.SaveDebugInfo(debug_mode, i, desired, market.diff_raw[1], market.close[1], market.times[1]);
        if( len_div_10 > 0)
            if( (i%len_div_10) == 0)
                print_progress(&owner, 10*(i/len_div_10));
        owner.UpdateInput(market.close, market.diff_norm, TIMESERIES_DEPTH);
        //owner.GetAdvice();
        //trade here
        chickowner.UpdateInput(market.close, market.diff_raw, market.open, market.times);
    }  
    chickowner.report();        
        
    owner.db.CloseDB();
//    print_progress(&owner,100);
    delete market;
    Print("Bye");
}
void print_progress(Owner* owner, int progress)
{
    Print("..",progress,"%");
    Print(owner.GetAxonsReport());
    Print("Quality metrics, profit= ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_LONG),1)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_ALLTIME),1)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_PROFIT,QUALITY_PERIOD_AVEALL),1));
    Print("Quality metrics, Direction= ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_LONG),5)," ",
                                   DoubleToString(owner.quality.GetQuality(QUALITY_METHOD_DIRECTION,QUALITY_PERIOD_ALLTIME),1),"%");
}
bool early_morning_skip(datetime t, bool skip_monday, bool skip_morning)
{
    MqlDateTime dt;
    TimeToStruct(t, dt);
    if(skip_morning)
        if(dt.hour==0 && dt.min==0)
            return true;
    if(skip_monday)
        if(dt.day_of_week==1 && dt.hour==0 && dt.min==0)
            return true;
    return false;
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