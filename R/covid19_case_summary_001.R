library(tidyverse)

data <- readr::read_csv("data/covid19_case_summary_2020-03-27.csv")

county_data <- data %>%
  dplyr::filter(description == "Case Counts by County" & metric == "Cases") %>%
  dplyr::mutate(County = stringr::str_remove(attribute, " County$")) %>%
  dplyr::filter(County !=  "Grand Total")

time_data <- dplyr::filter(data, grepl("^2020", attribute)) %>%
  dplyr::mutate(
    date = as.Date(trunc(strptime(attribute, format = "%Y-%m-%d", tz = "MST"), "day"))
  )

county_data %>%
  ggplot(aes(y = value, x = County)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by County") +
  NULL

time_data %>%
  ggplot(aes(x = date, y = value)) +
  geom_point(size = 2) +
  geom_smooth(method = "loess", se = FALSE) +
  ggplot2::scale_x_date(breaks = time_data$date) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by Date") +
  NULL
