#===============================
#Project 1:Comcast Telecom Consumer Complaints
#Thapelo Madiba Masebe 
# May 2025
#===============================

#Packages installs and loads

install.packages("janitor")

# Load required libraries
library(tidyr)
library(lubridate)
library(caret)
library(randomForest)
library(corrplot)
library(forcats)
library(ggpubr)
library(ggplot)
library(readxl)
library(dplyr)
library(janitor)

# 1. DATA IMPORT & CLEANING ----

# Read data
raw <- read_csv("Comcast Telecom Complaints data.csv", 
                na = c("", "NA", "undefined")) %>%
clean_names()

# Inspect structure
str(raw)

# Parse date column (handle both dmy mdy formats)
raw <- raw %>%
mutate(
  date_parsed = parse_date_time(date, orders = c("dmy", "mdy"))
)

raw <- raw %>%
  mutate(
    datetime = as.POSIXct(date_parsed) + as.numeric(time)
  )

bad_dates <- raw %>% filter(is.na(date_parsed)) %>% select(date) %>% distinct()
print(bad_dates)

# Check for N in parsed dates
sum(is.na(raw$date_parsed))

# Check for missing dates
if(any(is.na(raw$date_parsed))) {
  warning("Some dates could not be parsed.")
}

if(any(is.na(raw$date_parsed)))  {
  warning("Some dates could not be parsed.")
}



# Clean status field for consistency
raw <- raw %>%
  mutate(
    status_clean = str_to_title(str_trim(status)),
    received_via = str_to_title(str_trim(received_via))
  )

#4. Status Recoding

  raw <- raw %>%
  mutate(
    status_cat = case_when(
      status %in% c("Open", "Pending") ~ "Open",
      status %in% c("Closed", "Solved") ~ "Closed",
      TRUE ~ NA_character_
    )
  )


#2. FEATURE ENGINEERING ----

# Create month and day features
data <- raw %>%
  mutate(
    month = floor_date(date_parsed, "month"),
    day = date_parsed
  )

str(data)

  # 3. TREND CHARTS ----

## 3a. Daily Trend
daily_trend <- data %>%
  count(day) %>%
  filter(!is.na(day))

ggplot(daily_trend, aes(x = day, y = n)) +
  geom_line(color = "#0072B2") +
  labs(title = "Daily Complaint Volume",
       x = "Date", y = "Number of Complaints")

## 3b. Monthly Trend
monthly_trend <- data %>%
  count(month) %>%
  filter(!is.na(month))

monthly_trend$month <- as.Date(monthly_trend$month)

ggplot(monthly_trend, aes(x = month, y = n)) +
  geom_col(fill = "#D55E00") +
  scale_x_date(date_labels = "%b %", date_breaks = "1 month") +
  labs(
    title = "Monthly Complaint Volume",
    x = "Month",
    y = "Number of Complaints"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# 4. COMPLAINT TYPE CATEGORIZATION ----

# Define function for complaint type extraction
get_complaint_type <- function(text) {
  text <- tolower(text)
  case_when(
    str_detect(text, "internet|speed|wifi|connectiv|outage|throttl|bandwidth") ~ "Internet",
    str_detect(text, "bill|charg|overcharg|refund|payment|credit|fee|price|rate|cost") ~ "Billing",
    str_detect(text, "service|customer service|support|agent|representative|call|help") ~ "Customer",
    str_detect(text, "data cap|usage cap|limit|overage|300gb|meter") ~ "Data Cap",
    str_detect(text, "monopoly|competition|exclusive|bundle|bundling") ~ "Monopoly/Competition",
    TRUE ~ "Other"
  )
}

library(stringr)

data <- data %>%
  mutate(complaint_type = map_chr(customer_complaint, get_complaint_type))

# Frequency table
type_freq <- data %>%
  count(complaint_type, sort = TRUE)

print(type_freq)


# 5. STATUS RE-CATEGORIZATION (OPEN/CLOSED) ----

data <- data %>%
  mutate(
    status_cat = case_when(
      status_clean %in% c("Open", "Pending") ~ "Open",
      status_clean %in% c("Closed", "Solved") ~ "Closed",
      TRUE ~ NA_character_
    )
  )

stopifnot(all(data$status_cat %in% c("Open", "Closed", NA)))

# 6. STATE-WISE STATUS ANALYSIS ----

state_status <- data %>%
  filter(!is.na(state), !is.na(status_cat)) %>%
  count(state, status_cat) %>%
  group_by(state) %>%
  mutate(total = sum(n),
         pct = n / total * 100) %>%
  ungroup()

# Stacked bar chart
ggplot(state_status, aes(x = reorder(state, -total), y = n, fill = status_cat)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "State-wise Complaint Status",
       x = "State", y = "Number of Complaints", fill = "Status")

# State with maximum complaints
top_state <- state_status %>%
  group_by(state) %>%
  summarise(total = sum(n)) %>%
  arrange(desc(total)) %>%
  slice(1)
cat("State with most complaints:", top_state$state, "(", top_state$total, ")\n")

# State with highest % unresolved (open) complaints (min threshold: 10 complaints)
unresolved_pct <- state_status %>%
  filter(status_cat == "Open") %>%
  filter(total >= 10) %>% # Avoid tiny states
  arrange(desc(pct)) %>%
  slice(1)
cat("State with highest % open complaints:", unresolved_pct$state, 
    sprintf("(%.1f%% open)", unresolved_pct$pct), "\n")


# 7. RESOLUTION PERCENTAGE BY CHANNEL ----

library(tidyr)

resolution_by_channel <- data %>%
  filter(received_via %in% c("Internet", "Customer Care Call")) %>%
  group_by(received_via, status_cat) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = status_cat, values_from = count, values_fill = 0) %>%
  mutate(
    total = Open + Closed,
    pct_resolved = Closed / total * 100
  )

print(resolution_by_channel)

# 8. Key Insights

top_state <- state_status %>%
  group_by(state) %>%
  summarise(total = sum(n)) %>%
  arrange(desc(total)) %>%
  slice(1)

unresolved_pct <- state_status %>%
  filter(status_cat == "Open") %>%
  filter(total >=10) %>% # Avoid tiny states
  arrange(desc(pct)) %>%
  slice(1)

cat("* Top complaint type:", type_freq$complaint_type[1], "with", type_freq$n[1], "complaints\n")
cat("* State with most complaints:", top_state$state, "(", top_state$total, ")\n")
cat("* State with highest % open complaints:", unresolved_pct$state, 
    sprintf("(%.1f%% open)", unresolved_pct$pct), "\n")
cat("* Resolution rate via Internet:", 
    round(resolution_by_channel$pct_resolved[resolution_by_channel$received_via == "Internet"], 1), "%\n")
cat("* Resolution rate via Customer Care Call:", 
    round(resolution_by_channel$pct_resolved[resolution_by_channel$received_via == "Customer Care Call"], 1), "%\n")

# 9. EXPORT TABLES/FIGURES  ----

write_csv(type_freq, "complaint_type_frequency.csv")
ggsave("monthly_trend.png")
ggsave("statewise_status.png")