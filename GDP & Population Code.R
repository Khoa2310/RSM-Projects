# Package gganimate is used to make animated graphics
#install.packages("gganimate", dependencies = TRUE)
library(wbstats)
wb_indicators

# Set working directory
dir <- "~/Documents/BAM/Projects/GDP & Population/"
dirRslt <- paste0(dir, "Result")

# Find available indicators, and identify relevant columns
dfIndicators <- wb_indicators()

# Download the preferred data
dfWorld <-
  wb_data(indicator = c("SP.ADO.TFRT", "NY.GDP.PCAP.KD",
                        "SP.POP.TOTL", "SP.DYN.LE00.IN",
                        "EN.ATM.GHGT.KT.CE", "EN.POP.DNST"),
          country = "countries_only",
          start_date = 1960, end_date = 2024)

# Adjust column names
colnames(dfWorld)[colnames(dfWorld) == "SP.ADO.TFRT"]       <- "AFR" # Adolescent Fertility rate
colnames(dfWorld)[colnames(dfWorld) == "NY.GDP.PCAP.KD"]    <- "GDP"
colnames(dfWorld)[colnames(dfWorld) == "SP.POP.TOTL"]       <- "Population_Total"
colnames(dfWorld)[colnames(dfWorld) == "SP.DYN.LE00.IN"]    <- "Life_Ex"
colnames(dfWorld)[colnames(dfWorld) == "EN.ATM.GHGT.KT.CE"] <- "CO2"
colnames(dfWorld)[colnames(dfWorld) == "EN.POP.DNST"]       <- "Population_Density"

# Columns are renamed for convenience
library(gganimate)

# Make the bubble plot, and store it in object ’p’
p <- ggplot(dfWorld , aes(x=GDP , y=Life_Ex , color=country , size=Population_Density) + 
  geom_point(aes(group=country), show.legend = FALSE)
p

# Make animated graphic
p.anim01 <- p + transition_time(as.integer(date)) + 
  ggtitle("Year: {frame_time}") +
  shadow_wake(wake_length = 0.1, alpha=FALSE)

p.anim01

# Export to mp4
animate(p.anim01,
        width = 800,
        height = 600,
        res = 120,
        renderer = av_renderer(paste0(dirRslt ," Session05WorldAnimated01.mp4")))

mdlA <- Life_Ex ~ Population_Density + GDP
rsltA <- lm(mdlA, data = dfWorld)
stargazer(rsltA, type = "text")
