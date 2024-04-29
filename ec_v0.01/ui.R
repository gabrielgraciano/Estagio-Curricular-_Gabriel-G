library(shiny)
library(ggplot2)
library(bslib)
library(shinyWidgets)

nomes_ufs <- c("Rondônia", "Acre", "Amazonas", "Roraima",
               "Pará", "Amapá", "Tocantins", "Maranhão", "Piauí", "Ceará", "Rio Grande do Norte",
               "Paraíba", "Pernambuco", "Alagoas", "Sergipe", "Bahia", "Minas Gerais", "Espírito Santo",
               "Rio de Janeiro", "São Paulo", "Paraná", "Santa Catarina", "Rio Grande do Sul", 
               "Mato Grosso do Sul", "Mato Grosso", "Goiás", "Distrito Federal")

 cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("serie_temp_chagas")
  )
)

#color_by <- varSelectInput(
 # "color_by", "Color by",
  #dados_chagas['SG_UF_NOT'],
  #selected = "Rio de Janeiro"
#)

selecionar_ufs <- 
  pickerInput('selecao_uf', 'Selecione a UF de interesse',
              choices = c(nomes_ufs),
              multiple = TRUE)


ui <- page_sidebar(
  title = "EC1 - Gabriel",
  sidebar = selecionar_ufs,
  navset_card_underline(
    title = 'Séries temporais',
    nav_panel('Testando', cards[[1]])
  )
)