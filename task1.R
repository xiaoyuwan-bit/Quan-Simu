setwd("C:/Users/xiaoyuwan/Downloads")
rm(list=ls())
#### Load required libraries
library(haven)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggmosaic)
library(readr)
library(data.table)

#### Point the filePath to where you have downloaded the datasets to and #### assign the data files to data.tables
transactionData<-read.csv("QVI_transaction_data.csv")
customerData<-read.csv("QVI_purchase_behaviour.csv")
str(transactionData)
str(customerData)
head(transactionData)

### Convert DATE column to a date format
###A quick search online tells us that CSV and Excel integer dates begin on 30 Dec 1899
transactionData$DATE<-as.Date(transactionData$DATE,origin="1899-12-30")
###Examine PROD_NAME
table(transactionData$PROD_NAME)

#### Examine the words in PROD_NAME to see if there are any incorrect entries 
#### such as products that are not chips
productWords<-data.table(unlist(strsplit(unique(transactionData[,"PROD_NAME"]),"")))
setnames(productWords,'words')

###Removing digits & special characters
productWords<-productWords[!grepl("[[:digit:]]|[[:punct:]]",words)]
productWords[words==""]<-NA
productWords<-productWords[complete.cases(productWords),]
#### Let's look at the most common words by counting the number of times a word appears and 
### sorting them by this frequency in order of highest to lowest frequency
productWords<-data.frame(sort(table(productWords),decreasing=TRUE))

transactionData<-data.table(transactionData)

#### Remove salsa products
transactionData[,SALSA:=grepl('slasa', tolower(PROD_NAME))]
transactionData<-transactionData[SALSA==FALSE,][,SALSA:=NULL]
summary(transactionData)


###Summarise the data to check for nulls and possible outliers
sum(is.na(transactionData))
outlier<-transactionData[PROD_QTY==200]


#### Filter the dataset to find the outlier
table(outlier)
#### Let's see if the customer has had other transactions
outlierPurchase<-transactionData[LYLTY_CARD_NBR==226000,]

#### Filter out the customer based on the loyalty card number
transactionData<-transactionData[LYLTY_CARD_NBR!=226000]

#### Filter out the customer based on the loyalty card number
tranData<-table(transactionData$DATE)

#### Count the number of transactions by date
tranData<-data.frame(tranData)
setnames(tranData,c('Date',"Freq"))
tranData<-na.omit(tranData)
a=count(unique(tranData))
a

#### Create a sequence of dates and join this the count of transactions by date
Date<-seq(as.Date("2018-07-01"),as.Date("2019-06-30"),by="day")
data_seq<-table(Date)
date_seq<-data.frame(Date)

transaction_by_date<-merge(x=data_seq,y=tranData,by="Date",all.x=TRUE)
transaction_by_date<-transaction_by_date[!names(transaction_by_date)%in%c("Freq.x")]
setnames(transaction_by_date,c("Date","N"))
transaction_by_date[is.na(transaction_by_date)]<-0
transaction_by_date$Date<-as.Date(transaction_by_date$Date)

#### Setting plot themes to format graphs
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))
#### Plot transactions over time
ggplot(transaction_by_date, aes(x = Date, y = N)) +
  geom_line() +
  labs(x = "Day", y = "Number of transactions", title = "Transactions over time") +
  scale_x_date(breaks = "1 month") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

#### Plot transactions over time
december <- transaction_by_date[transaction_by_date$Date >= as.Date("2018-12-01") & 
                                  transaction_by_date$Date < as.Date("2019-01-01"), ]
ggplot(december,aes(x=Date,y= N)) +
  geom_line() +
  labs(x = "Day", y ="Number of transactions",title="Transactions over time (December)")+
  scale_x_date(breaks = "1 day") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
b<-december[which.min(december$N),]
b

#### Pack size
#### We can work this out by taking the digits that are in PROD_NAME
transactionData[, PACK_SIZE := parse_number(PROD_NAME)]

#### Always check your output #### Let's check if the pack sizes look sensible 
transactionData[, .N, PACK_SIZE][order(PACK_SIZE)]

#### Let's plot a histogram of PACK_SIZE since we know that it is a categorical 
ggplot(transactionData, aes(x = PACK_SIZE)) +
  geom_histogram(binwidth = 10, fill = "blue", color = "black") +
  labs(x = "Pack Sizes", y = "Frequency", title = "Histogram of Pack Sizes") +
  theme_minimal()
summary(transactionData$PACK_SIZE)

#### Brands
transactionData[, BRAND := tstrsplit(PROD_NAME, " ", keep = 1)]
#### Clean brand names 
transactionData[BRAND == "RED", BRAND := "RRD"]
transactionData[BRAND == "Cheetos", BRAND := "Cheezels"]
transactionData[BRAND == "Dorito", BRAND := "Doritos"]
transactionData[BRAND == "Grain", BRAND := "GrnWves"]
transactionData[BRAND == "Infuzions", BRAND := "Infzns"]
transactionData[BRAND == "Smith", BRAND := "Smiths"]
transactionData[BRAND == "Snbts", BRAND := "Sunbites"]
transactionData[BRAND == "Snbts", BRAND := "Sunbites"]
transactionData[BRAND == "Tostitos", BRAND := "Twisties"]
transactionData[BRAND == "Woolworths", BRAND := "WW"]
#### Check again
brand<-table(transactionData$BRAND)
brand<-as.data.frame(brand)
colnames(brand)<-c("brand","N")
brand<-brand %>%arrange(desc(N))
ggplot(brand, aes(x = reorder(brand, N), y = N, fill = brand)) +
  geom_bar(stat = "identity", width = 0.7) +
  coord_flip() +  # Flip coordinates for horizontal bars
  labs(x = "Brands", y = "Frequency", title = "Brands by Frequency") +
  theme_minimal() +
  theme(legend.position = "none",  # Remove legend
        axis.text.y = element_text(size = 8))  # Adjust text size if needed
  

### Examining customer data
sum(is.na(customerData))
summary(customerData)

###Examining life stage
lifestyle<-table(customerData$LIFESTAGE)
lifestyle<-as.data.frame(lifestyle)
colnames(lifestyle)<-c("lifestyle","N")
lifestyle<-lifestyle %>% arrange(desc(N))
ggplot(lifestyle,aes(x=reorder(lifestyle,N),y=N,fill=lifestyle))+
  geom_bar(stat="identity")+
  coord_flip() + 
  labs(x="Lifestyle",y="Frequency", title="Distribution of Customers over Lifestyle")+
  theme_minimal()

###Examing premium
premium<-table(customerData$PREMIUM_CUSTOMER)
premium<-as.data.frame((premium))
colnames(premium)<-c("premium","N")
premium<-premium %>% arrange(desc(N))
ggplot(premium,aes(x=reorder(premium,N),y=N,fill=premium))+
  geom_bar(stat="identity")+
  labs(x="premium",y="Frequency", title="Distribution of Customers over premium-Customer")+
  theme_minimal()
#### Merge transaction data to customer data
data <- merge(transactionData, customerData, all.x = TRUE)
sum(is.na(data))
fwrite(data, paste0("C:/Users/xiaoyuwan/Downloads","QVI_data.csv"))

## Data analysis on customer segments 

#chips by life stage
chipsbylife<-aggregate(data$TOT_SALES,by=list(lifestage=data$LIFESTAGE),FUN=sum)
ggplot(chipsbylife,aes(x=reorder(lifestage,x),y=x,fill=lifestage))+
  geom_bar(stat="identity")+
  labs(x="Lifestage",y="Frequency",title = "Total Sales by Lifestage")+
  theme_minimal()
# # of chips by premium 
chipsbypremium<-aggregate(data$TOT_SALES,by=list(premium=data$PREMIUM_CUSTOMER),FUN=sum)
ggplot(chipsbypremium,aes(x=reorder(premium,x),y=x,fill=premium))+
  geom_bar(stat="identity")+
  labs(x="Lifestage",y="Frequency",title = "Total Sales by Customer Premium")+
  theme_minimal()

###How many customers are in each segment
customer_segments <- data[, .(
  CustomerCount = uniqueN(LYLTY_CARD_NBR)
), by = .(LIFESTAGE, PREMIUM_CUSTOMER)]



ggplot(customer_segments,aes(x=PREMIUM_CUSTOMER,y=LIFESTAGE,fill = CustomerCount))+
  geom_tile()+
  geom_text(aes(label = CustomerCount), color = "black", size = 3) +
  scale_fill_gradient(low="grey99",high = "red")+
  labs(x="Premium Customer",y="Lifestage",title="Numebr of Each Segment (Customer Premium x Life Stage)")+
  theme_bw()+theme(axis.text.x=element_text(size=9, angle=0, vjust=0.3),
                   axis.text.y=element_text(size=9),
                   plot.title=element_text(size=11))

###How many chips are bought per customer by segment
chip_segments <- data[, .(
  chip_totalsal = mean(PROD_QTY)
), by = .(LIFESTAGE, PREMIUM_CUSTOMER)]

ggplot(chip_segments,aes(x=PREMIUM_CUSTOMER,y=LIFESTAGE,fill = chip_totalsal))+
  geom_tile()+
  geom_text(aes(label = chip_totalsal), color = "black", size = 3) +
  scale_fill_gradient(low="grey99",high = "purple")+
  labs(x="Premium Customer",y="Lifestage",title="Numebr of Chips Purchased by Each Segment (Customer Premium x Life Stage)")+
  theme_bw()+theme(axis.text.x=element_text(size=9, angle=0, vjust=0.3),
                   axis.text.y=element_text(size=9),
                   plot.title=element_text(size=11))

###What's the average chip price by customer segment
ave_price <- data[, .(
  ave_price = mean(TOT_SALES)
), by = .(LIFESTAGE, PREMIUM_CUSTOMER)]
ggplot(ave_price,aes(x=PREMIUM_CUSTOMER,y=LIFESTAGE,fill = ave_price))+
  geom_tile()+
  geom_text(aes(label = ave_price), color = "black", size = 3) +
  scale_fill_gradient(low="grey99",high = "navy")+
  labs(x="Premium Customer",y="Lifestage",title="Average number of Unit Purchased by Each Segment (Customer Premium x Life Stage)")+
  theme_bw()+theme(axis.text.x=element_text(size=9, angle=0, vjust=0.3),
                   axis.text.y=element_text(size=9),
                   plot.title=element_text(size=11))

#### Perform an independent t-test between mainstream vs premium and budget midage 
## The t-test results in P-value of unit price for mainstream, young and 
mainstream<-ave_price[ave_price$PREMIUM_CUSTOMER=="Mainstream"]
premium<-ave_price$PREMIUM_CUSTOMER=="Premium"
budget<-ave_price$PREMIUM_CUSTOMER=="Budget"

## t-test between mainstream vs Premium and mainstream vs Budget
mainstream <- subset(data, PREMIUM_CUSTOMER == 'Mainstream')$TOT_SALES
premium <- subset(data, PREMIUM_CUSTOMER == 'Premium')$TOT_SALES
budget <- subset(data, PREMIUM_CUSTOMER == 'Budget')$TOT_SALES

t_test_mainstream_premium <- t.test(mainstream, premium)
t_test_mainstream_budget <- t.test(mainstream, budget)

t_test_mainstream_premium
t_test_mainstream_budget

#### Deep dive into Mainstream, young singles/couples 
main_you<-subset(data, PREMIUM_CUSTOMER == 'Mainstream'& LIFESTAGE=="YOUNG SINGLES/COUPLES")$BRAND
main_you<-as.data.frame(main_you)
main_you<-table(main_you)
main_you<-data.frame(main_you)
ggplot(main_you,aes(x=reorder(main_you,Freq),y=Freq,fill=main_you))+
  geom_bar(stat="identity",width=0.5)+
  labs(x="brand",y="Count",title="Mainstream Younth Preference")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

