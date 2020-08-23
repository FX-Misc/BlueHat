#define TIMESERIES_DEPTH 10 //number of bars available to features; must be at least equal to the length od indicators


#define FLOAT_NEAR(a,b) ( (MathAbs((a)-(b))<1e-20) ? true : false )

float test_in[1003];

enum
{
    CMP_SMALLER,
    CMP_NEAR,
    CMP_BIGGER
};
enum
{
    SIGN_POSITIVE=1,
    SIGN_ZERO=0,
    SIGN_NEGATIVE=-1
};
#define FLOAT_CMP(a,b) ( ((a)>(b)+(1e-20)) ? CMP_BIGGER :  (((a)<(b)-(1e-20))?CMP_SMALLER : CMP_NEAR) )
#define FLOAT_SIGN(a) ( ((a)>0+(1e-20)) ? SIGN_POSITIVE :  (((a)<0-(1e-20))?SIGN_NEGATIVE : SIGN_ZERO) )

#define FILTER(OLD,NEW,COEF) ( (float)( (OLD)*(COEF) + (NEW) )/( (COEF)+1 ) )

#define NOISE(min,max) ((float)MathRand()*((float)(max)-(float)(min))/32768 + (float)(min))

//#define CAP(a,min,max) ((a)>(max)?((max)-(float)(1e-20)) : ((a)<(min)?((min)+(float)(1e-20)):(a)) )
#define CAP(a,min,max) (MathMax( MathMin((a),(max)) , (min) ))