#include "Pattern.mqh"

Pattern::Pattern(int id)
{
}

update_result_t Pattern::update(int BarNo, double diff)
{
    return UPDATE_SLEEP;
}