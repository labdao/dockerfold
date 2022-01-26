library(tidyverse)
library(here)
library(readxl)
library(seqinr)

# setting seed 
set.seed(1234134)

# reading data
input <- read_excel(here::here("data/external/test.xlsx"))

# defining amino acids
standard_aa <- c("A", "R", "N", "D", "C", "Q", "E", "G", "H", "I", "L", "K", "M", "F", "P", "S", "T", "W", "Y", "V")
non_aa <- LETTERS[!(LETTERS %in% standard_aa)]

# dropping non-standard AA and padding to 20mer
input <-input %>% mutate(fasta_in = str_remove_all(input$sequence, "[BJOUXZ]")) %>% 
  mutate(n = nchar(fasta_in),
         n_pad = 25-n) %>%
  mutate(n_pad = if_else(n_pad < 0, 0, n_pad)) %>%
  rowwise() %>%
  mutate(pad = standard_aa[sample.int(length(standard_aa), n_pad, replace = TRUE)] %>% paste(collapse = "")) %>%
  mutate(padded_out = paste0(fasta_in, pad))

# writing fasta file
input %>% 
  mutate(sequence = if_else(sequence == "ANON", paste0(sequence, "_", pad), sequence)) %>%
  mutate(fasta = purrr::map2(sequence, padded_out, ~ write.fasta(.y, .x, 
                                                     here::here(paste0("data/interim/", .x, ".fasta")), 
                                                     open = "w", nbchar = 1000, as.string = FALSE)))

       