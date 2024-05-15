library(lubridate)
library(dplyr)
library(ggplot2)

server <- function(input, output) {
  
  dados_plot <- reactive({
    req(input$update)
    
    # Ensure correct data transformation and summarization
    dados_dengue %>%
      filter(CS_SEXO %in% input$sexo) %>%
      filter(SG_UF %in% input$uf) %>%
      filter(idade_anos >= input$idade[1] & idade_anos <= input$idade[2]) %>%
      filter(DT_SIN_PRI >= as.Date(input$data[1]) & DT_SIN_PRI <= as.Date(input$data[2])) %>%
      mutate(YearMonth = as.Date(format(DT_SIN_PRI, '%Y-%m-01'))) %>%
      group_by(YearMonth) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      arrange(YearMonth)
  })
  
  output$monthplot <- renderPlot({
    dados_plot <- req(dados_plot())
    
    p <- ggplot(dados_plot, aes(x = YearMonth, y = log(Count))) +
      geom_line(group = 1, color = 'blue') +
      geom_point(color = 'red') +
      labs(title = 'Casos de Dengue mês a mês',
           x = 'Ano-mês',
           y = 'Número de casos') +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      scale_x_date(date_breaks = '1 year', date_labels = '%Y-%m')  # Ensure this matches the data's format
    
    p
  })
}


