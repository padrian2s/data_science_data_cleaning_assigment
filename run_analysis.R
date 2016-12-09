#define some consts
x_test_file_name <- 'test/X_test.txt'
y_test_file_name <- 'test/Y_test.txt'

x_train_file_name <- 'test/X_test.txt'
y_train_file_name <- 'test/Y_test.txt'
subject_test_file_name <- 'train/subject_train.txt'
subject_test_file_name <- 'test/subject_test.txt'

#read data into dframes
feature_names <- read.table('features.txt')
test_x <- read.table(x_test_file_name)
test_y <- scan(y_test_file_name)
test_subjects <- scan(subject_test_file_name)
train_x <- read.table(x_train_file_name)
train_y <- scan(y_train_file_name)
train_subjects <- scan(subject_test_file_name)

names(test_x) <- feature_names$V2
names(train_x) <- feature_names$V2

train_x$activity <- train_y
test_x$activity <- test_y
train_x$subject <- train_subjects
test_x$subject <- test_subjects

# Merge data sets
data_set <- rbind(train_x, test_x)

mean_std_col <- grepl('(-std\\(\\)|-mean\\(\\))', feature_names$V2)
mean_std_col <- append(mean_std_col, TRUE)
mean_std_col <- append(mean_std_col, TRUE)
mean_stddev <- data_set[, mean_std_col]

# refactor act names into factors
activity_lbl <- read.table("activity_labels.txt")
mean_stddev$activity_label <- factor(mean_stddev$activity, labels=activity_lbl$V2, levels=c(1:6))

tidy_data.frame <- data.frame()
activities <- sort(unique(mean_stddev$activity))
subjects <- sort(unique(mean_stddev$subject))

for (subj in subjects) {
  for (act in activities) {
    subset <- mean_stddev[mean_stddev$subject==subj & mean_stddev$activity == act,]
    m_subject_activity <- as.data.frame(lapply(subset[,1:66],FUN=mean))
    m_subject_activity$subject <- subj
    m_subject_activity$activity <- act
    m_subject_activity$activity_label <- activity_lbl[act,2]
    # complete tidying data frame
    tidy_data.frame <- rbind(tidy.frame, m_subject_activity)
  }
}
write.table(tidy_data.frame, file="tidy-data.csv")
