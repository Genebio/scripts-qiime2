browseVignettes("ALDEx2")
library(ALDEx2)

otu_table <- read.csv('ok128_ancom2_otu_table.csv', header = TRUE)
str(otu_table)
dim(otu_table)
metadata <- read.table('ok128_ancom2_metadata.tsv', header = TRUE)
metadata <- metadata[metadata$Sample.ID%in%otu_table$Sample.ID,]
dim(metadata)
OTUs <- otu_table$'Sample.ID'
otu_table <- t(as.data.frame(otu_table[,-1], row.names = OTUs))
otu_table <- as.data.frame(otu_table)
dim(otu_table)
mm <- model.matrix(~genotype_num+(time|Mouse_num), metadata)
dim(mm)
#mm <- model.matrix(~genotype_num+(1|time), metadata)
x <- aldex.clr(otu_table, mm, mc.samples = 16, verbose = TRUE)
glm.test <- aldex.glm(x, mm)

conds <- c(metadata$genotype)
x_conds <- aldex.clr(otu_table, conds, mc.samples = 16, verbose = TRUE)
x_conds.tt <- aldex.ttest(x_conds, verbose=TRUE)

str(x_conds.tt)
rownames(glm.test)[which(x_conds.kw$glm.eBH<0.05)]
min(x_conds.kw$glm.eBH)

str(aldex.effect(x_conds))
max(abs(aldex.effect(x_conds)$effect))
par(mfrow=c(1,2))
plot(glm.test[,"model.genotype_num Pr(>|t|).BH"], x_conds.kw$kw.eBH, log="xy",
     xlab="glm model", ylab="kw.eBH")
plot(glm.test[,"model.genotype_num Pr(>|t|).BH"], x_conds.kw$glm.eBH, log="xy",
     xlab="glm model", ylab="glm.eBH")

good_taxa <- glm.test[glm.test[,"model.genotype_num Pr(>|t|).BH"]<0.05]
min(glm.test[,"model.genotype_num Pr(>|t|).BH"])