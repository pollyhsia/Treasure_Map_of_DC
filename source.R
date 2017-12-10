data <- read.csv("Washington_DC_Public_Art.csv", header = T)
colnames(data)[1] <- "lng"
colnames(data)[2] <- "lat"
str(data)    #ARTIST  ART_TYPE   NEIGHBORHOOD   MEDIUM   

for (i in names(data)){
  if (class(data[, i]) == "factor"){
    data[, i] <- as.character(data[, i])
  }
}
str(data) 
data[,"ART_TYPE"] <- gsub("Sculpture, installation", "Sculpture, Installation", 
                          data[,"ART_TYPE"])

data[,"NEIGHBORHOOD"] <- gsub("anacostia", "Anacostia", 
                          data[,"NEIGHBORHOOD"])

data[,"NEIGHBORHOOD"] <- gsub("downtown", "Downtown", 
                              data[,"NEIGHBORHOOD"])

data <- subset(data, ARTIST != "" & ART_TYPE != "" & NEIGHBORHOOD != "" & 
                 MEDIUM != "" & PROGRAM_SOURCE != "")
