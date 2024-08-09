library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
library(plotly)
library(RMySQL)
library(leaflet)
library(sf)
library(rmapshaper)
library(highcharter)
library(gganimate)#para corrida de barras
library(transformr)#para corrida de barras
library(gifski)#para corrida de barras
library(jsonlite)#para corrida de barras
library(shinyjs)
library(png)



# Definindo cards de plots
cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    highchartOutput("monthplot")
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
  ),
  card(
    full_screen = TRUE,
    card_header('Mapa_Incidencia'),
    leafletOutput('mapa_incid')
  ),
  card(
    full_screen = TRUE,
    card_header('Treemap'),
    highchartOutput('treemap')
  ),
  card(
    full_screen = TRUE,
    card_header('Bar Chart Race'),
    imageOutput('bar_chart_race')
  )
)

# Inputs
selecionar_sexo <- selecionar_sexo <- pickerInput("sexo", "Selecione o sexo:", choices = c('Masculino', 'Feminino', 'Ambos'), multiple = TRUE)

selecionar_uf <- pickerInput(
  "uf", 
  "Selecione a UF:", 
  choices = c(
    'Todos',  # Adiciona a opção 'Todos'
    'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal', 
    'Espírito Santo', 'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 
    'Minas Gerais', 'Pará', 'Paraíba', 'Paraná', 'Pernambuco', 'Piauí', 
    'Rio de Janeiro', 'Rio Grande do Norte', 'Rio Grande do Sul', 'Rondônia', 
    'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe', 'Tocantins'
  ), multiple = TRUE
)

selecionar_idade <- pickerInput("faixa_etaria", "Selecione a faixa etária:", 
                                choices = c('Todos',
                                            '0-4',
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

tipo_mapa <-  radioButtons('tipo_mapa', 'Selecione o tipo de mapa', choices = c("Casos Absolutos", "Incidência"))

selecionar_doenca_serie_temporal <- pickerInput('doenca_st', "Selecione a doença de interesse",
                                 choices = c("Dengue", "Doença de Chagas",
                                             "Esquistossomose", "Envenenamento por picada de cobra",
                                             "Febre chikungunya", "Hanseníase",
                                             "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                             "Raiva humana"))

selecionar_doenca_piramide_etaria <- pickerInput('doenca_pe', "Selecione a doença de interesse",
                                                choices = c("Dengue", "Doença de Chagas",
                                                            "Esquistossomose", "Envenenamento por picada de cobra",
                                                            "Febre chikungunya", "Hanseníase",
                                                            "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                                            "Raiva humana"))

selecionar_doenca_estatistica_descritiva <- pickerInput('doenca_ed', "Selecione a doença de interesse",
                                                choices = c("Dengue", "Doença de Chagas",
                                                            "Esquistossomose", "Envenenamento por picada de cobra",
                                                            "Febre chikungunya", "Hanseníase",
                                                            "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                                            "Raiva humana"))

selecionar_doenca_mapa_incidencia <- pickerInput('doenca_mi', "Selecione a doença de interesse",
                                                choices = c("Dengue", "Doença de Chagas",
                                                            "Esquistossomose", "Envenenamento por picada de cobra",
                                                            "Febre chikungunya", "Hanseníase",
                                                            "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                                            "Raiva humana"))

selecionar_doenca_treemap <- pickerInput('doenca_tr', "Selecione a doença de interesse",
                                                choices = c("Dengue", "Doença de Chagas",
                                                            "Esquistossomose", "Envenenamento por picada de cobra",
                                                            "Febre chikungunya", "Hanseníase",
                                                            "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                                            "Raiva humana"))

selecionar_doenca_animacao_barras <- pickerInput('doenca_ba', "Selecione a doença de interesse",
                                                choices = c("Dengue", "Doença de Chagas",
                                                            "Esquistossomose", "Envenenamento por picada de cobra",
                                                            "Febre chikungunya", "Hanseníase",
                                                            "Leishmaniose visceral", "Leishmaniose tegumentar americana",
                                                            "Raiva humana"))

ui <- page_sidebar(
  title = 'DTNs no Brasil',
  sidebar = list(
    useShinyjs(), 
    # Movido para fora dos conditionalPanel
    # Movido para fora dos conditionalPanel
    conditionalPanel(
      condition = "input.navset == 'Série temporal'",
      selecionar_doenca_serie_temporal,
      selecionar_uf,
      selecionar_sexo,
      selecionar_idade
      
    ),
    conditionalPanel(
      condition = "input.navset == 'Pirâmide Etária'",
      selecionar_doenca_piramide_etaria,
      selecionar_uf,
      selecionar_ano
      
    ),
    conditionalPanel(
      condition = "input.navset == 'Estatística Descritiva'",
      selecionar_doenca_estatistica_descritiva,
      selecionar_uf
      
    ),
    conditionalPanel(
      condition = "input.navset == 'Mapa Incidência'",
      selecionar_doenca_mapa_incidencia,
      selecionar_ano,
      tipo_mapa
    ),
    conditionalPanel(
      condition = "input.navset == 'Treemap'",
      selecionar_doenca_treemap,
      selecionar_uf,
      selecionar_ano
    ),
    conditionalPanel(
      condition = "input.navset == 'Animação - barras'",
      selecionar_doenca_animacao_barras,
      selecionar_uf,
      tipo_mapa
    ),
    botao
  ),
  navset_card_underline(
    id = "navset",
    title = 'Análises',
    nav_panel('Série temporal', cards[[1]]),
    nav_panel('Pirâmide Etária', cards[[2]]),
    nav_panel('Estatística Descritiva', cards[[3]]),
    nav_panel('Mapa Incidência', cards[[4]]),
    nav_panel('Treemap', cards[[5]]),
    nav_panel('Animação - barras', cards[[6]])
  ),
  tags$div(id = "loading", style = "display:none;", class = "modal", 
           tags$div(class = "modal-content", 
                    tags$h4("Gerando Gráfico..."), 
                    tags$p("Por favor, aguarde."))),
  
  # CSS para o modal de carregamento
  tags$head(
    tags$style(HTML("
      .modal {
        display: block;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0,0,0);
        background-color: rgba(0,0,0,0.4);
      }
      .modal-content {
        position: relative;
        background-color: #fefefe;
        margin: auto;
        padding: 0;
        border: 1px solid #888;
        width: 80%;
        box-shadow: 0 5px 15px rgba(0,0,0,0.5);
        animation-name: animatetop;
        animation-duration: 0.4s
      }
      @keyframes animatetop {
        from {top:-300px; opacity:0} 
        to {top:0; opacity:1}
      }
    "))
  )
)