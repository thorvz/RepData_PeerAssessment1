################################
# Load and preprocess the data #
################################
setwd("~/Personal-Folder/Study-Git/reprod-research-wk1a/RepData_PeerAssessment1")
activity_df <- read.csv("activity.csv", header=T, sep=",")

#####################################################
# Get the mean total number of steps taken per day? #
#####################################################
steps_per_day_df <- aggregate(activity_df$steps, by=list(activity_df$date), FUN=sum)
names(steps_per_day_df) <- c("date","steps")
hist(steps_per_day_df$steps, 
     main="Number of steps per day",
     breaks=10, 
     col="orange", 
     xlab="Steps")
mean_steps_per_day <- mean(steps_per_day_df$steps, na.rm=T)
median_steps_per_day <- median(steps_per_day_df$steps, na.rm=T)

##############################################################################
# Get the average daily activity pattern, average of the 288 5 min intervals #
##############################################################################
mean_steps_per_5min_df <- aggregate(activity_df$steps, by=list(activity_df$interval), FUN=mean, na.rm=T)
names(mean_steps_per_5min_df) <- c("interval","mean_steps")
plot(mean_steps_per_5min_df$interval,
     mean_steps_per_5min_df$mean_steps, 
     ylab="Steps", 
     type="l", 
     xlab="Interval",
     main="Average per 5 minute interval",
     col="red") 
interval_with_max_steps <- mean_steps_per_5min_df[mean_steps_per_5min_df$mean_steps==max(mean_steps_per_5min_df$mean_steps),1]

#############################
# Substitute missing values #
#############################
num_rows_missing_vals <- nrow(activity_df) - sum(complete.cases(activity_df))
# there are 288 intervals per day and 61 full days, merge the dataframes into a new set 
activity_df_clean <- merge(activity_df,mean_steps_per_5min_df,by.x="interval",by.y="interval",all=FALSE)
activity_df_clean$steps <- ifelse(is.na(activity_df_clean$steps),activity_df_clean$mean_steps,activity_df_clean$steps)
steps_per_day_df_clean <- aggregate(activity_df_clean$steps, by=list(activity_df_clean$date), FUN=sum)
names(steps_per_day_df_clean) <- c("date","steps")
hist(steps_per_day_df_clean$steps, 
     main="Number of steps per day - Cleaned Data",
     breaks=10, 
     col="orange", 
     xlab="Steps")
mean_steps_per_day_clean <- mean(steps_per_day_df_clean$steps)
median_steps_per_day_clean <- median(steps_per_day_df_clean$steps)

########################################################################################
# Deterine if there is a difference in activity patterns between weekdays and weekends #
########################################################################################
# date is a factor, convert to date data type
activity_df_clean$date <- strptime(activity_df_clean$date, "%Y-%m-%d")
# get the 2 data subsets (for weekdays and for weekends)
Weekdays_df <- subset(activity_df_clean,weekdays(activity_df_clean$date) %in% c("Monday","Tuesday","Wednesday","Thursday","Friday"))
Weekends_df <- subset(activity_df_clean,weekdays(activity_df_clean$date) %in% c("Saturday","Sunday"))
mean_steps_per_5min_weekday_df <- aggregate(Weekdays_df$steps, by=list(Weekdays_df$interval), FUN=mean, na.rm=T)
mean_steps_per_5min_weekend_df <- aggregate(Weekends_df$steps, by=list(Weekends_df$interval), FUN=mean, na.rm=T)
names(mean_steps_per_5min_weekday_df) <- c("interval","mean_steps")
names(mean_steps_per_5min_weekend_df) <- c("interval","mean_steps")
plot(mean_steps_per_5min_weekday_df$interval,
     mean_steps_per_5min_weekday_df$mean_steps, 
     ylab="Steps", 
     type="l", 
     xlab="Interval",
     main="Average per 5 minute interval on Weekdays",
     col="red") 
plot(mean_steps_per_5min_weekend_df$interval,
     mean_steps_per_5min_weekend_df$mean_steps, 
     ylab="Steps", 
     type="l", 
     xlab="Interval",
     main="Average per 5 minute interval on Weekends",
     col="red") 

