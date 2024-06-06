library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
library(plotly)
library(RMySQL)

# Definindo a conexão MySQL
mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname = 'dengue',
                            host = '127.0.0.1',
                            port = 3306,
                            user = 'root',
                            password = '43047464')


# Definindo cards de plots
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
  ),
  card(
    full_screen = TRUE,
    card_header('Estatística Descritiva'),
    plotOutput('barplot_porcentagem')
  )
)

# Inputs
selecionar_sexo <- selecionar_sexo <- pickerInput("sexo", "Selecione o sexo:", choices = c('Masculino', 'Feminino', 'Ambos'), multiple = TRUE)

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

selecionar_idade <- pickerInput("faixa_etaria", "Selecione a faixa etária:", 
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

selecionar_ano <- pickerInput('ano', 'Selecione o ano',
                              choices = c(2010:2024))

botao <- actionButton("update", "Atualizar plot")

ui <- page_sidebar(
  title = 'EC1 - Gabriel',
  sidebar = list(
    conditionalPanel(
      condition = "input.navset == 'Série temporal'",
      selecionar_uf,
      selecionar_sexo,
      selecionar_idade,
      selecionar_ano,
      botao
    ),
    conditionalPanel(
      condition = "input.navset == 'Pirâmide Etária'",
      selecionar_uf,
      selecionar_ano,
      botao
    ),
    conditionalPanel(
      condition = "input.navset == 'Estatística Descritiva",
      selecionar_uf,
      botao
    )
  ),
  navset_card_underline(
    id = "navset",
    title = 'Análises',
    nav_panel('Série temporal', cards[[1]]),
    nav_panel('Pirâmide Etária', cards[[2]]),
    nav_panel('Estatística Descritiva', cards[[3]])
  )
)