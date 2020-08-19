#include "QualityMetrics.mqh"
QualityMetrics::QualityMetrics()
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
    epoch_counter = 0;
}
float QualityMetrics::GetQuality(quality_method_t method, quality_period_t period) const
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
                return (float)(direction_correct_all - direction_incorrect_all)/(direction_correct_all + direction_incorrect_all+1);
            default:
                assert(false,"invalid quality period");
        }
    else
        assert(false,"invalid quality method");
    return 0;    
}
void QualityMetrics::UpdateMetrics(float desired, float value)
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
    
    float diff = MathAbs(desired - value);
    
    diff_filtered_short = FILTER(diff_filtered_short, diff, METRIC_FILTER_SHORT);
    diff_filtered_long = FILTER(diff_filtered_long, diff, METRIC_FILTER_LONG);
    sum_diff_all_time += diff;
        
    float diff_zero = MathAbs( desired /*(float)MathRand()/16384-1*/ - 0);
    
    zerodiff_filtered_short = FILTER(zerodiff_filtered_short, diff_zero, METRIC_FILTER_SHORT);
    zerodiff_filtered_long = FILTER(zerodiff_filtered_long, diff_zero, METRIC_FILTER_LONG);
    sum_zerodiff_all_time += diff_zero;
}    
