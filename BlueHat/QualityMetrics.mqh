#include "globals/_globals.mqh"
#define METRIC_FILTER_SHORT (15)
#define METRIC_FILTER_LONG (255)
enum quality_method_t 
{
    QUALITY_METHOD_DIFF,  
    QUALITY_METHOD_DIRECTION,  
};
enum quality_period_t 
{
    QUALITY_PERIOD_SHORT,  
    QUALITY_PERIOD_LONG,  
    QUALITY_PERIOD_ALLTIME,  
};
class QualityMetrics
{
private:
    double diff_filtered_short;  //0(good)..1
    double diff_filtered_long; 
    double sum_diff_all_time;  
    double zerodiff_filtered_short;
    double zerodiff_filtered_long;  
    double sum_zerodiff_all_time; 
    int direction_correct_all;
    int direction_incorrect_all;
    int direction_zero_all;
    double direction_filtered_short; //-1..1; 0 input for when softmax==0   
    double direction_filtered_long;   
    int epoch_counter;  //the number of training epochs so far 
public:
    QualityMetrics();
    double GetQuality(quality_method_t method, quality_period_t period) const; //-1(min)..-(bad)..0(neutral)..+(good)..1(max)
    void UpdateMetrics(double desired, double value);
};