library(shiny)
library(ggplot2)
library(bslib)
library(shinyWidgets)
library(tidyverse)

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

nomes_faixa_etaria <- c(
  'Todas', 'Menor que 1 ano','De 1 a 4 anos','De 5 a 9 anos','De 10 a 14 anos','De 15 a 19 anos','De 20 a 39 anos',
  'De 40 a 59 anos','De 60 a 64 anos','De 65 a 69 anos','De 70 a 79 anos','80 anos ou mais'
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


#Definindo cards de plots
 cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("serie_temp_chik")
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
              choices = c(nomes_faixa_etaria_masc),
              multiple = TRUE)

#ui
ui <- page_sidebar(
  title = "EC1 - Gabriel",
  sidebar = list(
    selecionar_ufs,
    selecionar_sexo,
    selecionar_idade
  ),
  navset_card_underline(
    title = 'Séries temporais',
    nav_panel('Testando', cards[[1]])
  )
)