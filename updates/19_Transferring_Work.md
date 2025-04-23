# Notes

- About the model plan: 
    - I originally wanted to iteratively add to the standard data set (as can be seen in the [model plan](./15_Model_Plan.md)). I have not done this in my work, as I have not gotten the results that I had planned to. Furthermore, I don't think it is necessary to do so, but that decision is now up to you.
    - In order to tell when a data set is properly conformed, I track the validation set accuracy and wait for it to get as low as it can (the validation set is all data from the <b>Novel</b> set, so I want the accuracy to get to 0, meaning that the <i>Discriminator</i> thinks all of its data is from the <b>Standard</b> set)
- About the data sets:
    - There are some data sets that I did not get from OSF (as mentioned in an [earlier update](./01_DataSets.md)). I have some notes about what I did to get the data sets as they appear now, but I don't know that they are terrible helpful. If you need me to get you a better step-by-step of how I got what I did, it will take me some time to retrace my own steps and make sure I get the same thing. But, I am happy to do so.

# Results

- Here are some things I have seen, what I tried to do to fix them, and what I found as a result (there are some images of training plots [here](../plots/12_Modifying_Network_Part_1.md/Adversary/) that may help you to see what I am talking about):
    - When I do not include classes in the training process, I find that the <i>Discriminator</i> has a really hard time distinguishing the normalized <b>Standard</b> from the normalized <b>Novel</b>. The prediction accuracy started at about 0, though it should have been higher to begin. I tried to change the number of layers in the <i>Encoder</i> and found that with enough layers, the validation set accuracy would start higher, but this just seemed to be due to the <i>Encoder</i> completely messing up the data set randomly.
    - When I included class, the <i>Discriminator</i> got a lot better at distinguishing the two data sets (which was expected) and that is where the trouble with the <i>Encoder</i> came about. When the <i>Discriminator</i> got really good at distinguishing the two data sets, the <i>Encoder</i> seemed not able to keep up. I tried changing how powerful it was (the number of layers) and the learning rate (so it would learn faster than the <i>Discriminator</i>), but couldn't seem to rectify this.
        - When I was changing the learning rates, I noticed that the accuracy would start high, dip down, then rise again as the <i>discriminator</i> kept learning, but when I checked the model during that dip, the <i>Encoder</i> still hadn't learned to do its job well (i.e. the <b>Standard</b> data set did not predict well on the <b>novel</b> data set)
    - I thought that if the <i>Encoder</i> was having a hard time fooling the <i>Discriminator</i> it might be because the <i>Discriminator</i> had information about the classes, but the <i>Encoder</i> did not. So, I allowed the <i>Encoder</i> to see information about the classes of the data it was encoding.This, however, did nothing to change the results.
- Here are my thoughts about what is going wrong. I have included in the bottom of this some images that help to visualize what I am about to say:
    - The <i>Encoder</i> portion of my model does not seem to be learning well at all. It merely seems to be squeezing the data into a tighter cluster that resides in one half of the <b>Standard</b> data. - I think that is I am getting about 50% accuracy.
    - What is the cause of this? I think it is that I am using a bad loss function or something like that. I don't know what to change about that, and I only thought about this in the last week or so, so I never messed around with it. But, if the loss function is bad, then the <i>Encoder</i> can't really know how to update to do better.


# Images

[GSE25055 before conformation](trainBeforeTibblenormalPCA.jpg)

[GSE25055 after conformation](trainAfterTibblenormalPCA.jpg)
