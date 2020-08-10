#include "NNFactory.mqh"
NNFactory::NNFactory(SoftMax* psf, Trainer* ptr) : sf(psf),tr(ptr)
{
}
void NNFactory::CreateNNetwork(/*arc_file,*/)
{
//Features:
    INode* f_cheater = new FeatureCheater();    
    INode* f_2 = new FeatureCheater();    
    INode* f_3 = new FeatureCheater();    
    
    Axon* ax_N11 = new Axon(f_cheater, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N21 = new Axon(f_2, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N22 = new Axon(f_3, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N31 = new Axon(f_cheater, RATE_DEGRADATION, RATE_GROWTH);
    
    INeuron* N1 = new NeuronSUM();
    N1.AddAxon(ax_N11);
    INeuron* N2 = new NeuronSUM();
    N1.AddAxon(ax_N21);
    N1.AddAxon(ax_N22);
    INeuron* N3 = new NeuronSUM();
    N1.AddAxon(ax_N31);

    Axon* ax_S1 = new Axon(N1, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_S2 = new Axon(N2, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_S3 = new Axon(N3, RATE_DEGRADATION, RATE_GROWTH);

    sf.AddAxon(ax_S1);    
    sf.AddAxon(ax_S2);    
    sf.AddAxon(ax_S3);
    
    tr.AddAxon(0, (IAxonTrain*)ax_N11);     
    tr.AddAxon(0, (IAxonTrain*)ax_N21);     
    tr.AddAxon(0, (IAxonTrain*)ax_N22);     
    tr.AddAxon(0, (IAxonTrain*)ax_N31);  
       
    tr.AddAxon(1, (IAxonTrain*)ax_S1);     
    tr.AddAxon(1, (IAxonTrain*)ax_S2);     
    tr.AddAxon(1, (IAxonTrain*)ax_S3);     
}
