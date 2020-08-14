enum flag_grow_t
{
    FLAG_GROW,
    FLAG_DEGROW,
    FLAG_KEEP
};
class IAxonTrain
{
public:
    bool active;    //It will be used later, to disbale useless Axons on-the-go rather than after manual analysis
    flag_grow_t grow_temp_flag;    //a notepad for triner, to mark the axons to grow after all evaluations
    virtual void GainGrow()=0;
    virtual void GainDeGrow()=0;
    virtual void GainDegrade()=0;
};