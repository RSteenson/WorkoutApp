# Load libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(dplyr)
library(stringr)
library(rmarkdown)
library(htmltools)
library(knitr)
library(kableExtra)
library(lubridate)

# Load functions
source("R/set_exercises.R")

# Load data
exercises <- read.csv("data/exercises.csv", stringsAsFactors = FALSE)

# Identify current numbers of each exercise type
n_warmup = length(which(exercises$Type=="Warm-up"))
n_exercises = nrow(exercises[-which(exercises$Type %in% c("Warm-up", "Cool-down")),])
n_cooldown = length(which(exercises$Type=="Cool-down"))
