#define FLOAT_NEAR(a,b) ( (MathAbs((a)-(b))<1e-20) ? true : false )
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
