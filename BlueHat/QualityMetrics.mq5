#include "QualityMetrics.mqh"
QualityMetrics::QualityMetrics(double min_sm):min_softmax_for_trade(min_sm)
{
    diff_filtered_short = 0;
    diff_filtered_long = 0;
    sum_diff_all_time = 0;   
    zerodiff_filtered_short = 0;
    zerodiff_filtered_long = 0;
    sum_zerodiff_all_time = 0;   
    direction_correct_all = 0;
    direction_incorrect_all = 0;
    direction_zero_all = 0;
    direction_filtered_short = 0;
    direction_filtered_long = 0;   
    profit_accumulated_all = 0;
    profit_short = 0;
    profit_long = 0;
    non_zero_predictions = 0;
    epoch_counter = 0;
    profit_ave_ticks = 0;
}
double QualityMetrics::GetQuality(quality_method_t method, quality_period_t period) const
{ //-1(min)..-(bad)..0(neutral)..+(good)..1(max)
    if(method==QUALITY_METHOD_DIFF)
        switch(period)
        {
            case QUALITY_PERIOD_SHORT:
                return zerodiff_filtered_short - diff_filtered_short;
            case QUALITY_PERIOD_LONG:
                return zerodiff_filtered_long - diff_filtered_long;
            case QUALITY_PERIOD_ALLTIME:
                return (sum_zerodiff_all_time - sum_diff_all_time)/(epoch_counter+1);
            default:
                assert(false,"invalid quality period");
        }
    else if(method==QUALITY_METHOD_DIRECTION)
        switch(period)
        {
            case QUALITY_PERIOD_SHORT:
                return direction_filtered_short;
            case QUALITY_PERIOD_LONG:
                return direction_filtered_long;
            case QUALITY_PERIOD_ALLTIME:
                return 100*(double)direction_correct_all/(direction_correct_all + direction_incorrect_all+1);
            default:
                assert(false,"invalid quality period");
        }
    else if(method==QUALITY_METHOD_PROFIT)
        switch(period)
        {
            case QUALITY_PERIOD_SHORT:
                return profit_short;
            case QUALITY_PERIOD_LONG:
                return profit_long;
            case QUALITY_PERIOD_ALLTIME:
                return profit_accumulated_all;
            case QUALITY_PERIOD_AVEALL:
                return profit_ave_ticks;
            default:
                assert(false,"invalid quality period");
        }
    else
        assert(false,"invalid quality method");
    return 0;    
}
void QualityMetrics::UpdateMetrics(double desired, double value, double ticks_raw)
{
    epoch_counter++;
    if(FLOAT_SIGN(desired)==FLOAT_SIGN(value))
    {   //correct direction
        direction_correct_all++;
        direction_filtered_short = FILTER(direction_filtered_short, +1 , METRIC_FILTER_SHORT);
        direction_filtered_long = FILTER(direction_filtered_long, +1 , METRIC_FILTER_LONG);  
    }
    else
    if(FLOAT_SIGN(value)==SIGN_ZERO)
    {   //softmax gives zero
        direction_zero_all++;
        direction_filtered_short = FILTER(direction_filtered_short, +0 , METRIC_FILTER_SHORT);
        direction_filtered_long = FILTER(direction_filtered_long, +0 , METRIC_FILTER_LONG);  
    }
    else
    {   //incorrect non-zero direction
        direction_incorrect_all++;
        direction_filtered_short = FILTER(direction_filtered_short, -1 , METRIC_FILTER_SHORT);
        direction_filtered_long = FILTER(direction_filtered_long, -1 , METRIC_FILTER_LONG);  
    }
    
    double diff = MathAbs(desired - value);
    
    diff_filtered_short = FILTER(diff_filtered_short, diff, METRIC_FILTER_SHORT);
    diff_filtered_long = FILTER(diff_filtered_long, diff, METRIC_FILTER_LONG);
    sum_diff_all_time += diff;
        
    double diff_zero = MathAbs( desired - 0);
    
    zerodiff_filtered_short = FILTER(zerodiff_filtered_short, diff_zero, METRIC_FILTER_SHORT);
    zerodiff_filtered_long = FILTER(zerodiff_filtered_long, diff_zero, METRIC_FILTER_LONG);
    sum_zerodiff_all_time += diff_zero;
    
    if(value>min_softmax_for_trade)
    {
        non_zero_predictions++;
        profit_accumulated_all += (+ticks_raw);
        profit_short = FILTER(profit_short, +ticks_raw, METRIC_FILTER_SHORT);
        profit_long = FILTER(profit_long, +ticks_raw, METRIC_FILTER_LONG);
        profit_ave_ticks = profit_accumulated_all / non_zero_predictions;
    }
    else if(value<-min_softmax_for_trade)
    {    
        non_zero_predictions++;
        profit_accumulated_all -= ticks_raw;
        profit_short = FILTER(profit_short, -ticks_raw, METRIC_FILTER_SHORT);
        profit_long = FILTER(profit_long, -ticks_raw, METRIC_FILTER_LONG);
        profit_ave_ticks = profit_accumulated_all / non_zero_predictions;
    }
    else
    {
//        non_zero_predictions--; //revert it, as softmax was neutral; no trade recommendation
//comment out to consider only trade bars. uncomment to insert 0 in non-trade bars
//        profit_short = FILTER(profit_short, 0, METRIC_FILTER_SHORT);
//        profit_long = FILTER(profit_long, 0, METRIC_FILTER_LONG);
    }
}    
