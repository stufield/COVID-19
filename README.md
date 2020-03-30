
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Outbreak Summary

### March 28, 2020

![cases](https://img.shields.io/badge/Cases-2307-success.svg?style=flat-square&logo=appveyor)
![tested](https://img.shields.io/badge/People_Tested-14470-success.svg?style=flat-square&logo=appveyor)
![pct\_pos](https://img.shields.io/badge/Case_Rate-15.9%25-success.svg?style=flat-square&logo=appveyor)
![deaths](https://img.shields.io/badge/Deaths-47-success.svg?style=flat-square&logo=appveyor)
![counties](https://img.shields.io/badge/Counties-47-success.svg?style=flat-square&logo=appveyor)
![hospitalization](https://img.shields.io/badge/Hospitalizations-326-success.svg?style=flat-square&logo=appveyor)

### [stufield.github.io/COVID-19](https://stufield.github.io/COVID-19)

# COVID-19 Pandemic - Colorado

This page highlights the `COVID-19` cases in Colorado both through time
and by county (CO has 64 counties).

Data is obtained from the Colorado Department of Public Health &
Environment (CDPHE).

See the `CDPHE` [website](https://covid19.colorado.gov/case-data) for
more information and raw case data.

-----

## Cases by Sex

| Sex     | Percent |
| :------ | :------ |
| Female  | 52.06%  |
| Male    | 47.42%  |
| Unknown | 0.52%   |

## Cases by Age

``` r
dplyr::filter(data, description == "Case Counts by Age Group" & metric == "Percent") %>% 
  dplyr::select(Age = attribute, Percent = value) %>%
  ggplot(aes(x = Age, y = Percent)) +
  geom_bar(stat = "identity") +
  ggtitle("Case Proportion by Age")
```

![](README_files/figure-gfm/age_data-1.png)<!-- -->

## COVID-19 Cases by County

``` r
county_data %>%
  ggplot(aes(y = value, x = reorder(County, -value))) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Cases", title = "Colorado Cases by County", x = "County")
```

![](README_files/figure-gfm/county-1.png)<!-- -->

## COVID-19 Cases Over Time

``` r
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
