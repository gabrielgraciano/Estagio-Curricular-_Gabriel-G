library(shiny)
library(ggplot2)
library(bslib)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(arrow)

#Definindo dicionários para melhorar a estética dos picker inputs
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



nomes_faixa_etaria_masc <- c(
  'Todas' = 'Casos_M_total',
  'Menor que 1 ano' = 'Casos_1M',
  'De 1 a 4 anos' = 'Casos_1_4M',
  'De 5 a 9 anos' = 'Casos_5_9M',
  'De 10 a 14 anos' = 'Casos_10_14M',
  'De 15 a 19 anos' = 'Casos_15_19M',
  'De 20 a 39 anos' = 'Casos_20_39M',
  'De 40 a 59 anos' = 'Casos_40_59M',
  'De 60 a 64 anos' = 'Casos_60_64M',
  'De 65 a 69 anos' = 'Casos_65_69M',
  'De 70 a 79 anos' = 'Casos_70_79M',
  '80 anos ou mais' = 'Casos_80M'
)

nomes_faixa_etaria_fem <- c(
  'Todas' = 'Casos_F_total',
  'Menor que 1 ano' = 'Casos_1F',
  'De 1 a 4 anos' = 'Casos_1_4F',
  'De 5 a 9 anos' = 'Casos_5_9F',
  'De 10 a 14 anos' = 'Casos_10_14F',
  'De 15 a 19 anos' = 'Casos_15_19F',
  'De 20 a 39 anos' = 'Casos_20_39F',
  'De 40 a 59 anos' = 'Casos_40_59F',
  'De 60 a 64 anos' = 'Casos_60_64F',
  'De 65 a 69 anos' = 'Casos_65_69F',
  'De 70 a 79 anos' = 'Casos_70_79F',
  '80 anos ou mais' = 'Casos_80F'
)

nomes_faixa_etaria <- list(
  'Todas' = c('Casos_F_total', 'Casos_M_total', 'Casos_total'),
  'Menor que 1 ano' = c('Casos_1F', 'Casos_1M', 'Casos_1'),
  'De 1 a 4 anos' = c('Casos_1_4F', 'Casos_1_4M', 'Casos_1_4'),
  'De 5 a 9 anos' = c('Casos_5_9F', 'Casos_5_9M', 'Casos_5_9'),
  'De 10 a 14 anos' = c('Casos_10_14F', 'Casos_10_14M', 'Casos_10_14'),
  'De 15 a 19 anos' = c('Casos_15_19F', 'Casos_15_19M', 'Casos_15_19'),
  'De 20 a 39 anos' = c('Casos_20_39F', 'Casos_20_39M', 'Casos_20_39'),
  'De 40 a 59 anos' = c('Casos_40_59F', 'Casos_40_59M', 'Casos_40_59'),
  'De 60 a 64 anos' = c('Casos_60_64F', 'Casos_60_64M', 'Casos_60_64'),
  'De 65 a 69 anos' = c('Casos_65_69F', 'Casos_65_69M', 'Casos_65_69'),
  'De 70 a 79 anos' = c('Casos_70_79F', 'Casos_70_79M', 'Casos_70_79'),
  '80 anos ou mais' = c('Casos_80F', 'Casos_80M', 'Casos_80')
)




#Definindo cards de plots
 cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("serie_temp_chik")
    
  ),
  card(
    full_screen = TRUE,
    card_header('Tabelas'),
    card_header('Tabelass'),
    tableOutput('tabelachik')
  )
)

#Definindo pickerInputs para o aplicativo - posso associar à pagina?
selecionar_ufs <- 
  pickerInput('selecao_uf', 'Selecione a UF de interesse',
              choices = c(nomes_ufs),
              multiple = TRUE,
              options =  list("max-options" = 2))

selecionar_sexo <-
  pickerInput('selecao_sexo', 'Selecione o sexo',
              choices = c(nomes_sexo),
              multiple = TRUE)

selecionar_idade <-
  pickerInput('selecao_idade', 'Selecione o intervalo de faixa etária desejado',
              choices = c(nomes_faixa_etaria),
              multiple = TRUE)

selecionar_ano <-
  pickerInput('selecao_ano', 'Selecione os anos de interesse',
              choices = unique(dados_chik$Ano),
              multiple = F)

#ui
ui <- page_sidebar(
  title = "EC1 - Gabriel",
  sidebar = list(
    selecionar_ufs,
    selecionar_sexo,
    selecionar_idade,
    selecionar_ano
  ),
  navset_card_underline(
    title = 'Séries temporais',
    nav_panel('Testando', cards[[1]]),
    nav_panel('Estatística Descritiva', cards[[2]])
  )
)