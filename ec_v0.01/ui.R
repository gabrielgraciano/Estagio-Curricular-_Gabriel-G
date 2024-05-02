library(shiny)
library(ggplot2)
library(bslib)
library(shinyWidgets)
library(tidyverse)


nomes_ufs <- c("Rondônia", "Acre", "Amazonas", "Roraima",
               "Pará", "Amapá", "Tocantins", "Maranhão", "Piauí", "Ceará", "Rio Grande do Norte",
               "Paraíba", "Pernambuco", "Alagoas", "Sergipe", "Bahia", "Minas Gerais", "Espírito Santo",
               "Rio de Janeiro", "São Paulo", "Paraná", "Santa Catarina", "Rio Grande do Sul", 
               "Mato Grosso do Sul", "Mato Grosso", "Goiás", "Distrito Federal")

nomes_sexo <- c(
  'Masculino' = 'Casos_M_total',
  'Feminino' = 'Casos_F_total',
  'Ambos' = 'Casos_total'
)
 cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("serie_temp_chik")
  )
)

selecionar_ufs <- 
  pickerInput('selecao_uf', 'Selecione a UF de interesse',
              choices = c(nomes_ufs),
              multiple = TRUE)

selecionar_sexo <-
  pickerInput('selecao_sexo', 'Selecione o sexo',
              choices = c(nomes_sexo),
              multiple = TRUE)

ui <- page_sidebar(
  title = "EC1 - Gabriel",
  sidebar = selecionar_ufs,
  selecionar_sexo,
  navset_card_underline(
    title = 'Séries temporais',
    nav_panel('Testando', cards[[1]])
  )
)