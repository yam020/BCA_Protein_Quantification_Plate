# message 
message("Hello, Welcome!")
message("Please set working direcotry before you run the code")

# import packages 
library(ggplot2)
library(dplyr)
library(tidyr)

# choose a file 
fname <- file.choose()
# import the selected file 
excel <- read.csv(fname)

# user input
# standard position
pos <- readline("standard position: ")
# standard concentration
poscon <- readline("standard concentration: ")
# volume of each sample
volume <- readline("volume for each sample: ")
# trime down the white space and turn into numeric value
pos <- trimws(unlist(str_split(pos, ",")))
poscon <- as.numeric(trimws(unlist(str_split(poscon, ","))))
volume <- as.numeric(trimws(unlist(volume)))
  
# indicate the concentration position in number fashion
posrdy <- vector()
posrdx <- vector()
for (x in pos){
  y <- utf8ToInt(x)[1]-64
  posrdy <- c(posrdy, y)
  x <- utf8ToInt(x)[2]-47
  posrdx <- c(posrdx, x)
}

# record the concentration position 
posrd <- vector()
i <- 1
while(i<length(posrdx)+1){
  rd <- excel[posrdy[i], posrdx[i]]
  posrd <- c(posrd, rd)
  i <- i+1
}

# perform linear regression for concentration
a <- as.numeric(coef(lm(posrd~poscon))[[1]])
a <- round(a, digits=4)
b <- as.numeric(coef(lm(posrd~poscon))[[2]])
b <- round(b, digits=4)
rsq <- summary(lm(posrd~poscon))$r.squared
rsq <- round(rsq, digits=4)

# plot the concentration graph and save the plot 
condata <- cbind(data.frame(posrd), poscon)
conplot <- ggplot(condata, aes(poscon, posrd, group = 1)) +
              geom_point() + 
              geom_smooth(method = "lm",se=FALSE, col='purple') +
              xlab("Concentration(ug/ml)") + 
              ylab("A562") 
label_equ <- paste0("y= ",b, "x", "+", a)
label_rsq <- paste0("R2 = ", rsq) 
## annotate the plot 
conplot + annotate("text", x = c(750, 750), 
                    y = c(0.2, 0.15), label = c(label_equ, label_rsq))
ggsave("concentration.pdf")

# use the equation to quantify 
func <- function(x){
  return ((x-a)/b*volume/1000)
}

# reorientation 
# stack the dataframe 
excel[,c(2:13)] <- sapply(excel[,c(2:13)], func) 
excelt <- stack(data.frame(t(excel[, c(2:13)])))
alphabet <- c("A", "B", "C", "D", "E", "F", "G", "H")
aname <- vector()
for (x in alphabet){
  aname <- c(aname,paste0(x,1:12))
}
fdf <- data.frame(cbind(excelt$values, aname))
# indicate which rows needed to be reverse 
Usual <- c("A", "C", "E", "G")
REV <- c("B", "D", "F", "H")
combines <- sort(c(Usual, REV))
# create a two column dataframe with correct fraction order 
cleandata <- data.frame(Readings=double(),Position=character())
for (x in combines){
  if (x %in% Usual) {
    A <- fdf[grep(x, fdf$aname),]
    cleandata <- rbind(cleandata, A)
  }
  if (x %in% REV){
    B <- fdf[grep(x, fdf$aname),]
    B <- B[order(nrow(B):1),]
    cleandata <- rbind(cleandata, B)
  }
}
# convert to numeric 
cleandata$V1 <- as.numeric(cleandata$V1)
# convert to the plate formate 
evector <- c()
for (x in combines){
  A <- t(cleandata[grep(x, cleandata$aname),])[1,]
  evector <- rbind(evector, A)
}
evector <- data.frame(evector)
rownames(evector) <- combines
colnames(evector) <- gsub("X", "", colnames(evector))
write.csv(evector,"results.csv")
# get rid of the concentration position 
for (x in pos){
  cleandata <- cleandata[-grep(x, cleandata$aname),]
}

# plot the fraction 
ggplot(cleandata, aes(aname, V1, group = 1)) + 
  geom_point() + 
  geom_line()+
  xlab("Fraction") + 
  ylab("Protein (ug)") +
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.x = element_text(angle=90, hjust=1, size = 6))
# save the plot 
ggsave("fraction.pdf")