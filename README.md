
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Outbreak Summary

### April 28, 2020

![cases](https://img.shields.io/badge/Cases-14316-success.svg?style=flat-square&logo=appveyor)
![tested](https://img.shields.io/badge/People_Tested-67094-success.svg?style=flat-square&logo=appveyor)
![pct\_pos](https://img.shields.io/badge/Case_Rate-21.3%25-success.svg?style=flat-square&logo=appveyor)
![deaths](https://img.shields.io/badge/Deaths-736-success.svg?style=flat-square&logo=appveyor)
![counties](https://img.shields.io/badge/Counties-56-success.svg?style=flat-square&logo=appveyor)
![hospitalization](https://img.shields.io/badge/Hospitalizations-2571-success.svg?style=flat-square&logo=appveyor)

### [stufield.github.io/COVID-19](https://stufield.github.io/COVID-19)

# COVID-19 Pandemic - Colorado

This page highlights the `COVID-19` cases in Colorado both through time
and by county (CO has 64 counties).

Data is obtained from the Colorado Department of Public Health &
Environment (CDPHE).

See the `CDPHE` [website](https://covid19.colorado.gov/case-data) for
more information and raw case data.

-----

## Summary

| Metric           | number |
| :--------------- | -----: |
| Cases            |  14316 |
| Hospitalizations |   2571 |
| Counties         |     56 |
| People Tested    |  67094 |
| Deaths           |    736 |
| Outbreaks        |    149 |

## Cases by Sex

| Sex            | Percent |
| :------------- | :------ |
| Female         | 50.96%  |
| Male           | 47.69%  |
| Male to Female | 0.01%   |
| Unknown        | 1.34%   |

## Cases by Age

``` r
covid_data %>%
  dplyr::filter(
    description == "Cases of COVID-19 Reported in Colorado by Age Group, Hospitalization, and Outcome" &
      !is.na(value)) %>% 
  tidyr::separate(attribute, into = c("Age", "Outcome"), sep = ", ") %>%
  dplyr::select(Age, Outcome, Cases = value) %>%
  ggplot(aes(x = Age, y = Cases, group = Outcome)) +
  geom_bar(stat = "identity", aes(fill = Outcome)) +
  ggtitle("Case Proportion by Age & Outcome")
```

![](README_files/figure-gfm/age_data-1.png)<!-- -->

## COVID-19 Cases by County

``` r
covid_data %>%
  dplyr::filter(description == "Colorado Case Counts by County" & metric == "Cases") %>%
  dplyr::mutate(County = stringr::str_remove(attribute, " County$")) %>%
  dplyr::filter(County !=  "Grand Total") %>%
  ggplot(aes(y = value, x = reorder(County, -value))) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by County", x = "County")
```

![](README_files/figure-gfm/county-1.png)<!-- -->

## COVID-19 Cases Over Time

``` r
time_data <- covid_data %>% 
  dplyr::filter(
    description == "Cases of COVID-19 in Colorado by Date Reported to the State" & 
      !is.na(value)) %>% 
  dplyr::mutate(
    date = as.Date(trunc(strptime(attribute, format = "%Y-%m-%d", tz = "MST"), "day")),
    total = cumsum(value)
  )
time_data %>%
  ggplot(aes(x = date, y = value)) +
  geom_point(size = 2) +
  geom_smooth(method = "loess", se = FALSE) +
  scale_x_date(breaks = time_data$date) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by Date", x = "")
```

![](README_files/figure-gfm/time-1.png)<!-- -->

-----

Created by [Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.1) and
R version 3.6.3 (2020-02-29).
