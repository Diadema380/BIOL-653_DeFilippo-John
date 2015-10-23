ls()
rm(list = ls())
graphics.off()
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current.R')
get.ready()

# Select get.set one at a time, complete  plot.prep, est.lgcl.folder, denct.folder..., then proceed to next parent folder and repeat all functions, go, plot.prep, estlgcl, and plots

#get.set('St-Croix_FC')
#get.set('Diadema')
#get.set('Lucunter')
#get.set('Tripneustes')
#get.set('Control')
get.set('Laminarin')
#get.set('LPS')
#get.set('Peptidoglycan')
#get.set('Beaches_Diadema')
#get.set('Years_Diadema')
#get.set('FL-SC_Diadema')

go()
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/estlgcl.folder.R')
# sends argument of SS, 1 to transform.estlgcl to remove cells with SS <=1
#estlgcl.folder('St-Croix_FC')
#estlgcl.folder('Control')
estlgcl.folder('Laminarin')
#estlgcl.folder('LPS')
#estlgcl.folder('Peptidoglycan')
#estlgcl.folder('Beaches_Diadema')
#estlgcl.folder('Years_Diadema')
#estlgcl.folder('FL-SC_Diadema')

source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/2. Decide on limits and transformation//estlgcl.noplots.R')
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/lines.plot.R)
lines.plot('St-Croix_FC')

source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/denct.folder.R')
#denct.folder('St-Croix_FC')
#denct.folder('Control')
denct.folder('Laminarin')
#denct.folder('LPS')
#denct.folder('Peptidoglycan')
#denct.folder('Beaches_Diadema')
#denct.folder('Years_Diadema')
#denct.folder('FL-SC_Diadema')

# Adjust the x-limits in dect.xlim based on what the denct.folder plots looks like. If plot fine as is, #-out plot and print code
# For treatments, are not interested in comparing EV and SS, already have those from St-Croix_FC - just look at FL1
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/denct.xlim.folder.R')

#denct.xlim.folder('St-Croix_FC')
#denct.xlim.folder('Control')
denct.xlim.folder('Laminarin')
#denct.xlim.folder('LPS')
#denct.xlim.folder('Peptidoglycan')

# de.gate() creates 2D plotDens of EV/SS, FL1/SS, and FL2/SS, deconstructs them into 1D density plots, determines the x-values between the peaks, uses those to draw vertical lines between the peaks, calulates the percentage of cells in the gated regions, and puts those into a plot legend.
#
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/de.gate.R')
#de.gate('St-Croix_FC')
#de.gate('Control')
#de.gate('Laminarin')
#de.gate('Peptidoglycan')

# If de.gate has trouble with FL1 it will fail with errors like argument is of length zero. Use de.gate_rev instead, which skips FL1, just does EV/SS and FL2/SS
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/de.gate_rev.R')
#de.gate_rev('Control')
#de.gate_rev('Laminarin')
#de.gate_rev('LPS')
#de.gate_rev('Peptidoglycan')

# Then need to gate FL1 manually - see gate_FL1.txt
# This doesn't print to PDF, so will need to save each of the plots as PDFs
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/gate.FL1_script.R')
graphics.off()

# flowDensity creates a 2D plot with stats for one quadrant, so have to run it 4 times, varying the T/F positions of each of the four possibilites to get all four quadrants.
# Then will have to put the four quadrants stats onto one plot
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/flow.denct.R')
# If flowDensity() fails with error like argument is of length zero, flowDensity_script.R - it has manual gate values that should let the plot work.
# flow.denct('Control')
graphics.off()
#flow.denct('St-Croix_FV')
#flow.denct('Control')
#flow.denct('Laminarin')
#flow.denct('LPS')
#flow.denct('Peptidoglycan')
graphics.off()
# These are the manually determined flowDensity() gates
#source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/Control.flowDensity_script.R')
#source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/Laminarin.flowDensity_script.R')
#source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/LPS.flowDensity_script.R')
#source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/3. Plot/Peptidoglycan.flowDensity_script.R')


# 1-factor ANOVA, Pairwise t-test, Tukey HSD
source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/4. Analysis/data.anova.R')
data.anova('Control')
data.anova('Laminarin')
data.anova('Peptidoglycan')
data.anova('LPS')
#data.anova('Diadema')
#data.anova('Lucunter')
#data.anova('Tripneustes')

source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/4. Analysis/data.anova_lgcl.R')
data.anova_lgcl('Control', 2.7)
data.anova_lgcl('Laminarin', 2.7)
data.anova_lgcl('LPS', 2.7)
data.anova_lgcl('Peptidoglycan', 2.7)
data.anova_lgcl('Diadema', 2.7)
data.anova_lgcl('Lucunter', 2.7)
data.anova_lgcl('Tripneustes', 2.7)

#source('/Users/John/Desktop/Flow analysis in R stuff/flow-functions_current/4. Analysis/data.anova_lgcl.rev.R')
#data.anova_lgcl.cells('Control')
#data.anova_lgcl.cells('Laminarin')
#data.anova_lgcl.rev('LPS')
#data.anova_lgcl.cells('Peptidoglycan')
#data.anova_lgcl.cells('Diadema')
#data.anova_lgcl.cells('Lucunter')
#data.anova_lgcl.cells('Tripneustes')

version