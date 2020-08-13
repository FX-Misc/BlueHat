#include "../../BlueHat/Owner.mqh"

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
    
    
    Print("Bye");
}
