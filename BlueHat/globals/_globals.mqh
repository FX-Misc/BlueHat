#define TIMESERIES_DEPTH (10+1) //+1 is for useless sample of 0. number of bars available to features; must be at least equal to the length od indicators

#define MIN_SOFTMAX_FOR_TRADE 0.0001    //!!important; 0.001 the lower, the more trades on less margin
enum DEBUG_MODE
{
    DEBUG_NONE,
    DEBUG_NORMAL,
    DEBUG_VERBOSE,
    DEBUG_INTERVAL_10,
    DEBUG_INTERVAL_100
};


#define FLOAT_NEAR(a,b) ( (MathAbs((a)-(b))<1e-30) ? true : false )

enum
{
    CMP_SMALLER,
    CMP_NEAR,
    CMP_BIGGER
};
enum SIGN_T
{
    SIGN_POSITIVE=1,
    SIGN_ZERO=0,
    SIGN_NEGATIVE=-1
};
#define FLOAT_CMP(a,b) ( ((a)>(b)+(1e-20)) ? CMP_BIGGER :  (((a)<(b)-(1e-20))?CMP_SMALLER : CMP_NEAR) )
#define FLOAT_SIGN(a) ( ((a)>0+(1e-20)) ? SIGN_POSITIVE :  (((a)<0-(1e-20))?SIGN_NEGATIVE : SIGN_ZERO) )
#define SIGN(a) (( (a)>0 ) ? SIGN_POSITIVE :  (((a)<0)?SIGN_NEGATIVE : SIGN_ZERO) )

#define FILTER(OLD,NEW,COEF) ( (double)( (OLD)*(COEF) + (NEW) )/( (COEF)+1 ) )

#define NOISE(min,max) ((double)MathRand()*((double)(max)-(double)(min))/32768 + (double)(min))

//#define CAP(a,min,max) ((a)>(max)?((max)-(double)(1e-20)) : ((a)<(min)?((min)+(double)(1e-20)):(a)) )
#define CAP(a,min,max) (MathMax( MathMin((a),(max)) , (min) ))

#define SOFT_NORMAL(a) ((double)MathArctan((double)(a)*2)*(double)0.635)
//-1000-> -0.99714 -10-> -0.96573 -1-> -0.70304 -0.5-> -0.49873 -0-> 0.0 0.1-> 0.12535 0.70304 -0.96573 
