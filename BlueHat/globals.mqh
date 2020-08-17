#define FLOAT_NEAR(a,b) ( (abs((a)-(b))<1e-20) ? true : false )
enum
{
    CMP_SMALLER,
    CMP_NEAR,
    CMP_BIGGER
};
#define FLOAT_CMP(a,b) ( (a>b+1e-20) ? CMP_BIGGER :  ((a<b-1e-20)?CMP_SMALLER : CMP_NEAR) )
