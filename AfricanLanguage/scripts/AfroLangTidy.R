## This is my Tidy Tuesday repo for African Language Sentiment
## Created by: Chloe Mintlow
## Updated on 2023-03-12

## Load Data
library(here)
library(tidyverse)
library(tidytuesdayR)
library(lubridate)

## Read in Data
tuesdata <- tidytuesdayR::tt_load('2023-02-28')
afrisenti <- tuesdata$afrisenti
languages <- tuesdata$languages
language_scripts <- tuesdata$language_scripts
language_countries <- tuesdata$language_countries
country_regions <- tuesdata$country_regions

language_abbrevs <- c("amh", "arq", "ary", 
                      "hau", "ibo", "kin",
                      "oro", "pcm", "por",
                      "swa", "tir", "tso", 
                      "twi", "yor")
# amh == ama, por == pt-MZ, oro == orm

splits <- c("dev", "test", "train")

afrisenti <- purrr::map(
  language_abbrevs,
  \(language_abbr) {
    purrr::map(
      splits,
      \(split) {
        readr::read_tsv(
          paste0(
            "https://raw.githubusercontent.com/afrisenti-semeval/afrisent-semeval-2023/main/data/",
            language_abbr, "/", split, ".tsv"
          )
        ) |> 
          dplyr::mutate(
            language_abbreviation = language_abbr,
            intended_use = split
          )
      }
    ) |> 
      purrr::list_rbind()
  }
) |> 
  purrr::list_rbind()
View(afrisenti)

# oro has an extra column.
afrisenti |> 
  dplyr::filter(!is.na(ID)) |> 
  dplyr::count(language_abbreviation)

# Drop the extra column, and arrange the columns. Also recode the
# language_abbreviation to formal ISO codes.
afrisenti <- afrisenti |> 
  dplyr::mutate(
    language_iso_code = dplyr::recode(
      language_abbreviation,
      por = "pt-MZ",
      oro = "orm"
    )
  ) |> 
  dplyr::select(
    language_iso_code,
    tweet,
    label,
    intended_use
  ) |> 
  dplyr::arrange(language_iso_code, label, intended_use)

languages_untidy <- tibble::tribble(
  ~language, ~language_iso_code, ~region, ~country, ~script,
  "Amharic", "amh", "East Africa", "Ethiopia", "Ethiopic",
  "Algerian Arabic/Darja", "arq", "North Africa", "Algeria", "Arabic",
  "Hausa", "hau", "West Africa", "Nigeria", "Latin",
  "Hausa", "hau", "West Africa", "Ghana", "Latin",
  "Hausa", "hau", "West Africa", "Cameroon", "Latin",
  "Igbo", "ibo", "West Africa", "Nigeria", "Latin",
  "Kinyarwanda", "kin", "East Africa", "Rwanda", "Latin",
  "Moroccan Arabic/Darija", "ary", "Northern Africa", "Morocco", "Arabic",
  "Moroccan Arabic/Darija", "ary", "Northern Africa", "Morocco", "Latin",
  "Mozambican Portuguese", "pt-MZ", "Southeastern Africa", "Mozambique", "Latin",
  "Nigerian Pidgin", "pcm", "West Africa", "Nigeria", "Latin",
  "Nigerian Pidgin", "pcm", "West Africa", "Ghana", "Latin",
  "Nigerian Pidgin", "pcm", "West Africa", "Cameroon", "Latin",
  "Oromo", "orm", "East Africa", "Ethiopia", "Latin",
  "Swahili", "swa", "East Africa", "Tanzania", "Latin",
  "Swahili", "swa", "East Africa", "Kenya", "Latin",
  "Swahili", "swa", "East Africa", "Mozambique", "Latin",
  "Tigrinya", "tir", "East Africa", "Ethiopia", "Ethiopic",
  "Twi", "twi", "West Africa", "Ghana", "Latin",
  "Xitsonga", "tso", "Southern Africa", "Mozambique", "Latin",
  "Xitsonga", "tso", "Southern Africa", "South Africa", "Latin",
  "Xitsonga", "tso", "Southern Africa", "Zimbabwe", "Latin",
  "Xitsonga", "tso", "Southern Africa", "Eswatini", "Latin",
  "Yorùbá", "yor", "West Africa", "Nigeria", "Latin"
)

languages <- languages_untidy |> 
  dplyr::distinct(language_iso_code, language) |> 
  dplyr::arrange(language_iso_code, language)

language_countries <- languages_untidy |> 
  dplyr::distinct(language_iso_code, country) |> 
  dplyr::arrange(language_iso_code, country)

language_scripts <- languages_untidy |> 
  dplyr::distinct(language_iso_code, script) |> 
  dplyr::arrange(language_iso_code, script)

country_regions <- languages_untidy |> 
  dplyr::distinct(country, region) |> 
  dplyr::arrange(country, region)

# Save the data.
read.csv(afrisenti = "<afrisenti>")
write.csv(afrisenti, here::here("data", "2023","2023-02-28","afrisenti.csv"))
  

write.csv(
  languages,
  here::here(
    "data", "2023", "2023-02-28",
    "languages.csv"
  )
)

write.csv(
  language_scripts,
  here::here(
    "data", "2023", "2023-02-28",
    "language_scripts.csv"
  )
)

write.csv(
  language_countries,
  here::here(
    "data", "2023", "2023-02-28",
    "language_countries.csv"
  )
)

write.csv(
  country_regions,
  here::here(
    "data", "2023", "2023-02-28",
    "country_regions.csv"
  )
)

?write.csv
