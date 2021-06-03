# EEG-P300-Speller-Project

## Introduction
The P300 Speller is a paradigm commonly used to assist individuals with movement disorders communicate. The objective of this experiment was to train and implement a P300 Speller which takes advantage of the positional encoding of a character matrix. In this procedure, the user focused on target and non-target characters in a rapidly flashing keyboard. The subsequent flashes produced a peak in the Event Related Potential (ERP) approximately 300ms after the onset of the target. This EEG signal measurement is classically known as the P300 waveform and is a response exclusively evoked from target character flashes. A Support Vector Machine (SVM) classifier was trained to discriminate between target ERP’s and non-target characters, and to validate the paradigm a free-spelling task was performed. The collected EEG training data was processed and the average target vs. non-target ERP responses for validation of this theory were calculated.

## Note to the reader
This project was intended to highlight applications of machine learning to biological systems. The experiments were run with EEGLAB, an open-source MATLAB Toolbox for Physiological research. Prior to training the SVM classifier, the user was able to perform a free-spelling task. The differences between the two types of signals was graphically displayed across all channels. 

## Summary of Contributed files
All post experiment analysis was performed using `EEG_P300_Speller.m`. The file `EEG_P300_Speller.pdf` is a copy of the README.md which summarizes the project.

## Stimuli and Procedure
Three phases were performed for this experiment and consisted of training data acquisition, classifier training, and model deployment. Prior to commencing the test, several parameters were tuned to ensure the data measurements were of reliable quality. Referencing the overhead view of EEG electrodes in **Figure 1**, an 8-channel configuration was utilized to maximize the signal collection over the occipital lobe containing the visual cortex.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120694772-94699880-c478-11eb-8832-4d858d3bef45.png">
</p>

<p><b> 
  Figure 1. Transverse view of an 8-Channel EEG Layout over the Visual Cortex and Longitudinal (Cerebral) Fissure. The labeled electrodes: Fz, Cz, P3, Pz, P4, PO7, Oz and PO8
  </b></p>

To remove any line noise, a 60Hz notch filter was applied to all channels and the common ground and reference was set for all groups. Utilizing the g.USBamp Row Column Speller module, the function block parameters of the Signal Processing block and Single Character Speller were set. Starting with the P300 Signal processing mask, this block buffered EEG data for each ID-Flash obtained. A specified number of flashes were set where each character flashes M times. Once each character ID was obtained, the character with the strongest P300 response was relayed to the output ID. While setting a high value for ‘M’ allows for higher classifier accuracy, it comes at the cost of spelling time per character. Depending on the skill of the subject, M could be lower to expedite training. In this instance, M was set to 15 target flashes over 8 channels, along with a buffer length of 800ms which compensated for the experience of a beginner subject. Moving on to the single character flash speller, each row and column of letters flashed across a 6×6 Character Matrix (**Figure 2**) in a random sequential order for 100ms (flash time) with 75ms between characters (dark time). The subject’s task was to perform copy spelling by focusing on specific letters whenprompted and mentally count how many times each letter flashed. A series of target words were chosen to be trained on; the more letters used for the classifier generation, the higher accuracy of the feature classification algorithm. Upon completing the copy spelling mode, all associated labels were stored with the collected training data. Below is the full schematic of the Speller Simulink Model used for all phases of the experiment shown in **Figure 3**. Note that the ID-Flash produced from the Single Character Speller contains a feedback loop going back to the Signal Processing block. The outputs from channels nine, ten and eleven contained the ID of the character that has flashed, the time when the target or non-target letter has flashed and the target information of copy spelling, respectively and were stored in the `session1.mat file`.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698480-1fe52880-c47d-11eb-8aaf-02bc113b96e9.png">
</p>

<p><b> Figure 2. A 6×6 Character Speller Matrix consisting of 26 letters and 10 numbers. Values 1-6 in channel nine identify the rows, and values 7-12 identify the columns. The target character ‘N’ for example, corresponds to index 3 (row) or index 8 (column). </b></p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698666-59b62f00-c47d-11eb-8f8e-54d023081d34.png">
</p>

<p align="center"><b> 
  Figure 3. P300 Speller Simulink Model 
  </b></p>


To generate an SVM classifier, the .mat file from the copy spelling session was loaded into the G.BSanalyze classification toolbox and sampled at a rate of 256Hz. Another copy spelling session was performed to train the classifier. The EEG data collected at the end of the training classifier session was saved to calculate the average target vs. non-target ERP responses. Next, the Simulink module was configured to test the accuracy of the BCI system. Free spelling was performed with a sequence of random flashes the same flash and dark times from copy spelling were retained. The subject’s task was to spell a word consisting of 5 or more characters. As the subject focused on each desired word during the free spelling session, the processing module determined and displayed the characters it believed the subject was focusing on. This process continued until the
subject was able to spell the target word completely. To test the accuracy of the BCI system during free spelling, the subjects progress was monitored in terms of percent accuracy. A typical ERP waveform contains several components post stimulus. The cited example illustrated in **Figure 4**, shows the most prominent part of the waveform at point P3, the P300 wave. This response is characterized by a latency of 250ms to 500ms. In this case, the P300 signal exhibited negative deflection because the positive and negative leads were inverted. The transition into the P300 signal between points N2 and P3 occurred approximately at 300ms, hence the origin of the name. The calculated ERP responses will be compared to theory in the results section.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698705-68044b00-c47d-11eb-8225-cf215a1b1984.png">
</p>

<p><b>
Figure 4. A typical theorical depiction of the P300 waveform located at P3 on the ERP response. The time is indicated in milliseconds (x-axis) and the Potential is measured in microvolts (y-axis). 
  </b></p>

## Results
Channels ten and eleven were used as triggers to parse through the EEG data shown in **Figure 5**. Recall that the 10th channel signified the time point when the target or non-target letter has flashed, and the 11th channel indicated target only flashes during copy spelling for each time the row or target character flashed. All triggers encoded all events with a ‘1’ while any time in between was otherwise ‘0’. By finding the indices of the events indicated by these channels, the onset of all flashes was found and separated into target and non-target flashes, see Appendix 1A of `EEG_P300_Speller.m`.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698740-75213a00-c47d-11eb-9265-575dc4e1d8e2.png">
</p>

<p><b>
Figure 5. Copy spelling raw EEG data for channels 1-8. The bottom sequence (Ch. 10) is a display of the target flashes with respect to time. 
  </b></p>

## Copy Spelling
To obtain a clear visual of the target and non-target ERP responses, the signals were cut 100ms before the stimulus and 700ms post target flash. The average ERP responses were calculated for all 8 channels. **Figure 6** displays the target vs. non-target responses for the respective channels in a concise 2×4 grid. Notably, the ERP components of the target measurements increase in strength laterally down the longitudinal fissure of the brain and are most visible across the channels over the occipital region (reference Figure 1). Channels Fz and Cz are anterior and distal to the visual cortex so the contrast between target and non-target signals is not very prominent. The last three channels (PO7, Oz and PO8) however, are proximal to the occipital lobe and adequately show the non-inverted ERP target response.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698831-941fcc00-c47d-11eb-9337-9d2835857667.png">
</p>

<p><b>
Figure 6. Average ERP responses for all eight channel measurements. Target and non-target responses are plotted in red and blue, respectively. The channels along the longitudinal fissure from distal to proximal with respect to the occipital lobe are: Fz, Cz, Pz, Oz. 
</b></p>

## Free Spelling
The P300 waveform is characterized by a positive deflection in voltage with a latency of 250ms to 500ms post stimulus. The inflection point inscribed between the N200 and P300 waves, usually occurred near 300ms. To include the contribution of every measurement, the average over all channels was calculated and plotted in **Figure 7**. The effect of taking an overall average shifted the apexes of the N200 and P300 waves to the correct times, retained the characteristic profile of the ERP components and demonstrated the discriminability between target and non-target stimuli. Considering the reference in **Figure 4**, the only major difference is the lack of an inverted potential which is subject to the ground reference in the experimental setup. In general, the P300 wave is prominent, free of noise and manifests itself 250ms to 500ms post stimulus.

<p align="center">
  <img src="https://user-images.githubusercontent.com/25239215/120698867-a26de800-c47d-11eb-85c5-908b3892e3b6.png">
</p>

<p><b>
Figure 7. Overall Average of the Target and Non-Target ERP Responses. The P300 wave is clearly distinguishable in the Target signal (Red) in comparison to the Non-Target signal (Blue). Averaging all eight channels factors in the spatial mapping relevance of each individual electrode. 
</b></p>

Upon completing the free spelling task, the subject was able to spell a 6-character word with 100% accuracy after the second attempt. The term accuracy is used very loosely in this context because the subject’s task was to write words from the character matrix arbitrarily but made sense grammatically. From the perspective of the algorithm, it did not know the true target per iteration, nor did it rely on past input to predict the future target and as a result, the true accuracy could not be calculated. Nonetheless, the results are still impressive because the classifier is relying on the correlation between the P300 signal strength and the source of the Target stimuli based on its
position in the character matrix. For more robust results future work could include incorporating a language model to expedite the prediction of each target word on step in the future.
