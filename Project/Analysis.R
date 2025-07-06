data <- ai_dev_productivity
dim(data)
str(data)
summary(data)
head(data)
any(is.na(data)) #boş verimiz yoktur
rowSums(is.na(data))

par(mfrow=c(3, 3))
for (col_name in names(data)) {
  hist(data[[col_name]],
       main = paste("Histogram of", col_name),
       xlab = col_name,
       col = "skyblue",
       border = "white")
}
#Correlation 
library(corrplot)
cor_matrix <- cor(data)
corrplot(cor_matrix, method = "color", type = "upper", 
         tl.cex = 0.8, tl.col = "black", addCoef.col = "black")

cor(data$coffee_intake_mg, data$hours_coding)

library(ggplot2)

ggplot(data, aes(x = hours_coding, y = coffee_intake_mg, color = factor(task_success))) +
  geom_point(alpha = 1, size = 2) +
  labs(title = "Coding Hours & Coffee Intake vs Task Success", x = "Hours Coding", y = "Coffee Intake (mg)", color = "Task Success") +
  theme_light()


plot(data$coffee_intake_mg, data$hours_coding ,
     main='Cafein Intake vs Coding Hours',
     xlab='Caffein Intake(mg)',
     ylab='Coding Hours')

plot(data$cognitive_load, data$ai_usage_hours)


##2 CLUSTER##

data2 <- data[c("hours_coding", "coffee_intake_mg", "distractions", "sleep_hours", "commits", "bugs_reported", "ai_usage_hours", "cognitive_load")]
#Scale the data before clustering
scaled_data <- scale(data2)
#Elbow method for optimal k to do kmeans
fviz_nbclust(scaled_data, kmeans, method = "wss") + labs(title = "Elbow Method for Optimal k")

#Applying kmeans with k=3
kmeans_result <- kmeans(scaled_data, centers = 3)
#PCA to visualize the clusters
fviz_cluster(kmeans_result, data = scaled_data,
             geom = "point",
             ellipse.type = "norm",)

#Add the cluster info 
data2$cluster <- as.factor(kmeans_result$cluster)
#Avg values for the clusters
aggregate(. ~ cluster, data = data2, FUN = mean)





#Finding outliers
outliers_list <- lapply(data, function(x) boxplot.stats(x)$out); 
outliers_list
sapply(outliers_list, length)

#visualization of outliers by 
par(mfrow = c(3, 3))
for (col in names(data2)) {
  boxplot(data2[[col]], main = paste("Boxplot of", col))
}




#scale data before logistic regression
scaled_data <- as.data.frame(scale(data2))
scaled_data$task_success <- data$task_success

#Drawing logistic regression line for coffe_intake
log_model_based_coffe <- glm(task_success ~ coffee_intake_mg, data = scaled_data, family = "binomial")
summary(log_model_based_coffe)
ggplot(scaled_data, aes(x = hours_coding, y = task_success)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5, color = "steelblue") +  
  stat_smooth(method = "glm", method.args = list(family = "binomial"), formula = y ~ x, se = TRUE, color = "darkred", size = 1.2) +
  theme_minimal()


#Drawing logistic regression line logistic for hours_coding
log_model_based_coding <- glm(task_success ~ hours_coding, data = scaled_data, family = "binomial")
summary(log_model_based_coding)
ggplot(scaled_data, aes(x = hours_coding, y = task_success)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5, color = "steelblue") +  
  stat_smooth(method = "glm", method.args = list(family = "binomial"), formula = y ~ x, se = TRUE, color = "darkred", size = 1.2) +
  theme_minimal()

#Drawing regression line logistic for both
log_model_based_both <- glm(task_success ~ hours_coding + coffee_intake_mg, data = scaled_data, family = "binomial")
summary(log_model_based_both)
ggplot(scaled_data, aes(x = hours_coding, y = task_success)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5, color = "steelblue") +  
  stat_smooth(method = "glm", method.args = list(family = "binomial"), formula = y ~ x, se = TRUE, color = "darkred", size = 1.2) +
  theme_minimal()

#log model
log_model <- glm(task_success ~ coffee_intake_mg, data = data, family = "binomial")
summary(log_model)
#draw line
ggplot(data, aes(x = coffee_intake_mg, y = task_success)) +
  geom_point(alpha = 0.4, color = "steelblue") +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = TRUE, color = "darkred") +
  labs(
    title = "Logistic Regression Curve: Coffee Intake vs Task Success",
    x = "Coffee Intake (scaled)",
    y = "Probability of Task Success"
  ) 
  theme_minimal()

#Odds ratio and confint
exp(coef(log_model))
exp(confint(log_model))

#labeling the data based on predictions that comes from logistic reg
data$predicted_prob <- predict(log_model, type = "response")
data$predicted_class <- ifelse(scaled_data$predicted_prob > 0.5, 1, 0)
#confusion matrix
conf_matrix <- table(Predicted = data$predicted_class, Actual = scaled_data$task_success)
conf_matrix

#accuracy of the model 
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("Accuracy Ratio: ", round(accuracy * 100, 2), "%"))

library(pROC)
#AUC ROC
roc_obj <- roc(scaled_data$task_success, scaled_data$predicted_prob)
auc_val <- auc(roc_obj); auc_val
