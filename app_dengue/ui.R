library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
library(plotly)

age_intervals <- seq(0, 90, by = 5)

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
    plotlyOutput('piram_et')
  )
)

selecionar_sexo <- pickerInput("sexo", "Selecione o sexo:", choices = c('Masculino', 'Feminino', 'Ambos'), multiple = TRUE)

selecionar_uf <- pickerInput(
  "uf", 
  "Selecione a UF:", 
  choices = c(
    'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal', 
    'Espírito Santo', 'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 
    'Minas Gerais', 'Pará', 'Paraíba', 'Paraná', 'Pernambuco', 'Piauí', 
    'Rio de Janeiro', 'Rio Grande do Norte', 'Rio Grande do Sul', 'Rondônia', 
    'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe', 'Tocantins'
  ), multiple = TRUE
)


selecionar_idade <-  pickerInput("faixa_etaria", "Selecione a faixa etária:", 
                                 choices = c('0-4',
                                             '5-9',
                                             '10-14',
                                             '15-19',
                                             '20-24',
                                             '25-29',
                                             '30-34',
                                             '35-39',
                                             '40-44',
                                             '45-49',
                                             '50-54',
                                             '55-59',
                                             '60-64',
                                             '65-69',
                                             '70-74',
                                             '75-79',
                                             '80-84',
                                             '85-89',
                                             '90 ou mais'),
                                 multiple= TRUE)
                                 
                                 

selecionar_data <- dateRangeInput("data", "Selecione a data de início e fim da análise:",
                                  start = "2010-01-01", end = "2024-05-31",
                                  min = "2010-01-01", max = "2024-05-31")
selecionar_ano <- pickerInput('ano', 'Selecione o ano',
                              choices = c(2010:2024))

botao <- actionButton("update", "Atualizar plot")

ui <- page_sidebar(
  title = 'EC1 - Gabriel',
  sidebar = list(
    selecionar_uf,
    selecionar_sexo,
    selecionar_idade,
    selecionar_data,
    selecionar_ano,
    botao
  ),
  navset_card_underline(
    title = 'Análises',
    nav_panel('Série temporal', cards[[1]]),
    nav_panel('Estatística descritiva', cards[[2]])
  )
)

