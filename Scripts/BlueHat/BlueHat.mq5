#include "../../BlueHat/Owner.mqh"
#include "../../BlueHat/Trainer.mqh"

#include "../../BlueHat/INode.mqh"
#include "../../BlueHat/Axon.mqh"
#include "../../BlueHat/Features/FeatureCheater.mqh"
#include "../../BlueHat/globals/assert.mqh"
#include "../../BlueHat/globals/ExtendedArrList.mqh"

void OnStart()
{
    Print("Hi there");
    assert(1>0,"test");

    Owner owner();
    owner.CreateNN();
    
    for(int i=0; i< 10; i++)
    {
        owner.Go1Bar(i,1000);
        Print(owner.trainer.GetCurrentOutput());
    }
        
    Print("Bye");
}
