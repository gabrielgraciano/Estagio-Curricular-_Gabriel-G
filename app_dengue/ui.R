library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
#Definindo cards de plots
cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("monthplot")
    
  ),
  card(
    full_screen = TRUE,
    card_header('Tabelas'),
    tableOutput('tabela')
  )
)

selecionar_sexo <- pickerInput("sexo", "Selecione o sexo:", choices = unique(dados_dengue$CS_SEXO))

selecionar_uf <- pickerInput("uf", "Selecione a UF:", choices = unique(dados_dengue$SG_UF))

selecionar_idade <- sliderInput('idade', 'Selecione o intervalo de idade desejado', min = 0, max = 100, value= c(0,100))

selecionar_data <- dateRangeInput("data", "Selecione a data de início e fim da análise:",
               start = min(dados_dengue$DT_NOTIFIC),
               end = max(dados_dengue$DT_NOTIFIC))

botao <- actionButton("update", "Atualizar plot")

ui <- page_sidebar(
  title = 'EC1 - Gabriel',
  sidebar = list(
    selecionar_uf,
    selecionar_sexo,
    selecionar_idade,
    selecionar_data,
    botao
  ),
  navset_card_underline(
    title = 'Análises',
    nav_panel('Série temporal', cards[[1]]),
    nav_panel('Estatística descritiva', cards[[2]])
  )
)
