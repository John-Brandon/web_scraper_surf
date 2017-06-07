#!/usr/bin/env Rscript
#
# Hobby surfy code project
#
message("Loading Required Packages.")
suppressMessages(library(rvest))      # Web scraping
# library(purrr) %>% suppressMessages()       # Map along vector(s) of inputs to function calls (split-apply-combine)
suppressMessages(library(tidyverse))    # Includes pipes %>% in R
suppressMessages(library(magrittr))   # Bi-directional pipes %<>%
rm(list = ls())

# source("./R/Emoji_unicode.R")  # Returns a set of emoji unicode

removeWords <- function(str, stopwords) {
  # borrowed from stackoverflow
  x <- unlist(strsplit(str, " "))
  paste(x[!x %in% stopwords], collapse = " ")
}

get_surflie_status = function(beach, main_url){  # -----------------------------
  # Scrape surfline.com status for a given sampling location.
  # Status examples: "poor", "fair to good", "good", etc.
  # Used SelectorGadget browser plug-in to manually ID css_selector with beach status.
  # See also: https://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/
  # On return, the posting status is prettified, eg blank first space removed
  css_selector_1 = "#observed-spot-conditions-summary"
  css_selector_2 = "#observed-spot-conditions"
  posted_status = paste0(main_url, beach) %>%
    read_html() %>%
    html_node(css = css_selector_1) %>%
    html_node(css = css_selector_2) %>%
    html_text() %>%
    removeWords("Conditions")
  posted_status
}

surflie_url = "http://www.surfline.com/surf-report/"
surflie_spots = c("ocean-beach-sf-northern-california_4127/",
                  "south-ocean-beach-northern-california_4128/",
                  "pacifica-lindamar-northern-california_5013/",
                  "mavericks-northern-california_4152/",
                  "steamer-lane-central-california_4188/",
                  "cowells-central-california_4189/",
                  "pleasure-point-central-california_4190/",
                  "38th-ave-central-california_4191/",
                  "lower-trestles-southern-california_4740/",
                  "upper-trestles-southern-california_4738/")

spot_names = c(   "ocean-beach-sf    ",
                  "south-ocean-beach ",
                  "pacifica-lindamar ",
                  "mavericks-northern",
                  "steamer-lane      ",
                  "cowells           ",
                  "pleasure-point    ",
                  "38th-ave          ",
                  "lower-trestles    ",
                  "upper-trestles    "
                  )

message("Starting to Scrape...")
message(Sys.time())
cat("\n")
cat("Location          |  Conditions","\n")
cat("-------------------------------","\n")
status = NULL
for (ii in seq_along(surflie_spots)) {
  status = get_surflie_status(main_url = surflie_url, beach = surflie_spots[ii])
  cat(spot_names[ii], " ", status, "\n")
}

cat("\n")
message("Surflie scrape complete")

# get_surflie_status(main_url = surflie_url, surflie_spots[1])

# debugging
# css_selector_1 = "#observed-spot-conditions-summary"
# css_selector_2 = "#observed-spot-conditions"
# css_selector_3 = "#observed-wave-range"
# beta_html = paste0(surflie_url, surflie_spots[3]) %>% read_html(x = .)
# beta_html %>%
#   html_node(x = ., css = css_selector_1) %>%
#   html_node(x = ., css = css_selector_2) %>%
#   html_text()
#
# # observed wave range returning meters? WTF?
# beta_html %>%
#   html_node(x = ., css = css_selector_3) %>%
#   html_text()
#
# beta_html %>%
#   html_node(x = ., css = "#observed-wave-description") %>%
#   html_text()
#
#
#
#
#
#
