library(lubridate)
library(dplyr)
library(ggplot2)

server <- function(input, output) {
  
 " dados_plot <- reactive({
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
  })"
  
  data <- reactive({
    req(input$uf, input$data)
    req(input$update)
    
    query_time_series <- sprintf(
      
      "
      SELECT 
        STR_TO_DATE(CONCAT(YEAR(DT_SIN_PRI), '-', LPAD(MONTH(DT_SIN_PRI), 2, '0'), '-01'), '%%Y-%%m-%%d') AS YearMonth,
        COUNT(*) AS NumberOfCases
      FROM 
        notifications
      WHERE 
        SG_UF = '%s' AND
        DT_SIN_PRI BETWEEN '%s' AND '%s' AND
        idade_anos BETWEEN '%s' AND '%s'
      GROUP BY 
        STR_TO_DATE(CONCAT(YEAR(DT_SIN_PRI), '-', LPAD(MONTH(DT_SIN_PRI), 2, '0'), '-01'), '%%Y-%%m-%%d')
      ORDER BY 
        YearMonth
    ", input$uf, format(input$data[1]), format(input$data[2]), format(input$idade[1]), format(input$idade[2]))
    
    db_data <- dbGetQuery(mysqlconnection, query_time_series)
    
  })
  
  
  output$tabela <- renderTable({
    data()
  })
  
  output$monthplot <- renderPlot({
    dengue_cases <- data()
    dengue_cases$YearMonth <- as.Date(dengue_cases$YearMonth)
    plot <- ggplot(dengue_cases, aes(x = YearMonth, y = NumberOfCases, group = 1)) +  # Ensure grouping if necessary
      geom_line(color = "blue") +  # Draw lines connecting the points
      geom_point(color = "red") +  # Add points at each data point
      labs(title = "Dengue Case Counts Over Time",
           x = "Year-Month",
           y = "Number of Cases") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for readability
    plot
  })
}


