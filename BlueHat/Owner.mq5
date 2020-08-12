#include "Owner.mqh"

Owner::Owner()
{
    softmax = new SoftMax();
}
Owner::~Owner()
{
    delete softmax;
    delete trainer;
}
void Owner::CreateNN()  //TODO: input file/
{
    FeatureFactory ff;

    //based on the input file, decide on feature type
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));
    features.Add(ff.CreateFeature(FEATURE_CHEATER));

    axonsL1.Add( new Axon(features.at(0), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(1), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(2), RATE_DEGRADATION, RATE_GROWTH) );
    axonsL1.Add( new Axon(features.at(3), RATE_DEGRADATION, RATE_GROWTH) );

    NeuronFactory nf;
//    nf.CreateNeuron(neurons_t.    
    
    
    
    trainer = new Trainer(softmax, axonsL1, axonsL2);

//    INeuron* n = new NeuronSUM();
//    n.AddAxon(ax_N11);
//    trainer.AddAxon(0,

/*
    Axon* ax_N11 = new Axon(f_cheater, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N21 = new Axon(f_cheater, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N22 = new Axon(f_3, RATE_DEGRADATION, RATE_GROWTH);
    Axon* ax_N31 = new Axon(f_cheater, RATE_DEGRADATION, RATE_GROWTH);
    
    INeuron* N1 = new NeuronSUM();
    N1.AddAxon(ax_N11);
    INeuron* N2 = new NeuronSUM();
    N2.AddAxon(ax_N21);
    N2.AddAxon(ax_N22);
    INeuron* N3 = new NeuronSUM();
    N3.AddAxon(ax_N31);

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
*/
}