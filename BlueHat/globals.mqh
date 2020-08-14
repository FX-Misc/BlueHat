#define FLOAT_NEAR(a,b) ( (abs((a)-(b))<0.001) ? true : false )
enum
{
    CMP_SMALLER,
    CMP_NEAR,
    CMP_BIGGER
};
#define FLOAT_CMP(a,b) ( (a>b+0.001) ? CMP_BIGGER :  ((a<b-0.001)?CMP_SMALLER : CMP_NEAR) )
