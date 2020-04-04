library(tidyverse)

data <- readr::read_csv("data/covid19_case_summary_2020-04-03.csv")

state_data <- dplyr::filter(data, attribute == "Statewide") %>%
  dplyr::select(Metric = metric, number = value)

county_data <- data %>%
  dplyr::filter(description == "Case Counts by County" & metric == "Cases") %>%
  dplyr::mutate(County = stringr::str_remove(attribute, " County$")) %>%
  dplyr::filter(County !=  "Grand Total")

time_data <- dplyr::filter(data, grepl("^2020", attribute)) %>%
  dplyr::mutate(
    date = as.Date(trunc(strptime(attribute, format = "%Y-%m-%d", tz = "MST"), "day")),
    sum  = cumsum(value)
  ) %>%
  dplyr::select(date, value, sum)

# Barchart by Age & Outcome ----
data %>%
  dplyr::filter(
    description == "Case Counts by Age Group, Hospitalizations, and Deaths" &
      attribute != "Note") %>%
  tidyr::separate(attribute, into = c("Age", "Outcome"), sep = ", ") %>%
  dplyr::select(Age, Outcome, Cases = value) %>%
  ggplot(aes(x = Age, y = Cases, group = Outcome)) +
  geom_bar(stat = "identity", aes(fill = Outcome)) +
  ggtitle("Case Proportion by Age & Outcome")

# Barchart by County ----
county_data %>%
  ggplot(aes(y = value, x = reorder(County, -value))) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by County", x = "County")

# Epidemic Cases by Time ----
time_data %>%
  tidyr::pivot_longer(cols = c(value, sum), names_to = "metric") %>%
  ggplot(aes(x = date, y = value, group = metric, color = metric)) +
  geom_point(size = 2) +
  geom_smooth(method = "loess", se = FALSE, size = 0.5) +
  scale_x_date(breaks = time_data$date) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by Date", x = "")
