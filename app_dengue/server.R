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
  
  dados_fx_et <- reactive({
    req(input$update)
    
    query_fx_et <- sprintf(
      "SELECT * FROM dengue_piramide_etaria WHERE UF = '%s' AND year = '%s'",
      input$uf, input$ano
    )
    dados_fx_et <- dbGetQuery(mysqlconnection, query_fx_et)
    
    # Garantir que 'counting' seja numérico, escrevi errado, escrevi couting
    dados_fx_et$couting <- as.numeric(dados_fx_et$couting)
    
    levels_faixa_etaria <- c('0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', 
                             '40-44', '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', 
                             '75-79', '80-84', '85-89', '90 ou mais')
    dados_fx_et$faixa_etaria <- factor(dados_fx_et$faixa_etaria, levels = levels_faixa_etaria, ordered = TRUE)
    
    
    # Verificar se há linhas após a consulta
    if (nrow(dados_fx_et) == 0) {
      showNotification("Nenhum dado encontrado para os parâmetros selecionados.", type = "error")
      return(NULL)
    }
    
    return(dados_fx_et)
  })
  
  dados_barplot <- reactive({
    req(input$uf)
    req(input$update)
    
    # Query
    query_barplot <- sprintf("
    select 
        year,
        uf,
        sex,
        sum(counting) as total_count
    from 
        dengue_ano
    where
        sex IN ('Masculino', 'Feminino') and
        uf = '%s' AND
        uf not in ('Ignorado')
    group by
        year, uf, sex
    order by
        year, uf, sex", input$uf)
    
    dados_barplot <- dbGetQuery(mysqlconnection, query_barplot)
    
    return(dados_barplot)
  })
  
  "
SELECT 
    year,
    uf,
    sex,
    SUM(counting) AS total_count
FROM 
    dengue_ano
WHERE
   sex IN ('Masculino', 'Feminino') AND
   uf NOT IN ('Ignorado')
GROUP BY 
    year, uf, sex
ORDER BY 
    year, uf, sex;
"
  
  data <- reactive({
    req(input$uf, input$sexo, input$faixa_etaria)
    req(input$update)
    
    # Definir o filtro de sexo com base na entrada do usuário
    sex_filter <- if ("Ambos" %in% input$sexo) {
      "'Masculino', 'Feminino'"
    } else {
      paste0("'", paste(input$sexo, collapse = "','"), "'")
    }
    
    # Definir o filtro de UF com base na entrada do usuário
    uf_filter <- paste0("'", paste(input$uf, collapse = "','"), "'")
    
    # Construir a consulta SQL para obter os casos de dengue
    query_dengue <- sprintf("
      SELECT 
          year,
          uf,
          sex,
          faixa_etaria,
          SUM(counting) AS total_count
      FROM 
          dengue_ano
      WHERE 
          uf IN (%s) AND
          sex IN (%s) AND
          faixa_etaria IN (%s)
      GROUP BY 
          year, uf, sex, faixa_etaria
    ", uf_filter, sex_filter, paste0("'", paste(input$faixa_etaria, collapse = "','"), "'"))
    
    # Construir a consulta SQL para obter os dados populacionais
    query_population <- sprintf("
      SELECT 
          year,
          uf,
          sex,
          faixa_etaria,
          SUM(counting) AS total_count
      FROM 
          population
      WHERE 
          uf IN (%s) AND
          sex IN (%s) AND
          faixa_etaria IN (%s)
      GROUP BY 
          year, uf, sex, faixa_etaria
    ", uf_filter, sex_filter, paste0("'", paste(input$faixa_etaria, collapse = "','"), "'"))
    
    # Executar as consultas e buscar os dados
    dengue_data <- dbGetQuery(mysqlconnection, query_dengue)
    population_data <- dbGetQuery(mysqlconnection, query_population)
    
    # Unir os dois datasets em year, uf, sex, e faixa_etaria
    merged_data <- merge(dengue_data, population_data, by = c('year', 'uf', 'sex', 'faixa_etaria'), suffixes = c('_dengue', '_pop'))
    
    # Calcular a taxa de incidência por 100,000, agrupando por ano, uf e sexo
    incidence <- merged_data %>%
      group_by(year, uf, sex) %>%
      summarise(total_count_dengue = sum(total_count_dengue), total_count_pop = sum(total_count_pop)) %>%
      mutate(incidence_rate = round((total_count_dengue / total_count_pop) * 100000, 2)) %>%
      ungroup()
    
    # Calcular a taxa de incidência para "Ambos"
    if ("Ambos" %in% input$sexo) {
      total_incidence <- merged_data %>%
        group_by(year, uf) %>%
        summarise(total_count_dengue = sum(total_count_dengue), total_count_pop = sum(total_count_pop)) %>%
        mutate(sex = "Ambos",
               incidence_rate = round((total_count_dengue / total_count_pop) * 100000, 2)) %>%
        ungroup()
      
      incidence <- bind_rows(incidence, total_incidence)
    }
    
    return(incidence)
  })
  
  

  
  output$piram_et <- renderPlotly({
    dados_fx_et <- dados_fx_et()
    
    # Verificar se os dados não são nulos
    req(dados_fx_et)
    
    # Verificar se há linhas após a filtragem por sexo
    dados_masculino <- dados_fx_et[dados_fx_et$sex == "Masculino", ]
    dados_feminino <- dados_fx_et[dados_fx_et$sex == "Feminino", ]
    
    if (nrow(dados_masculino) == 0 & nrow(dados_feminino) == 0) {
      showNotification("Nenhum dado encontrado para os sexos selecionados.", type = "error")
      return(NULL)
    }
    
    # Create the plotly plot directly
    piramide <- plot_ly() %>%
      add_trace(data = dados_masculino,
                x = ~-couting, y = ~faixa_etaria, type = 'bar', orientation = 'h',
                name = 'Male', marker = list(color = '#049899')) %>%
      add_trace(data = dados_feminino,
                x = ~-couting, y = ~faixa_etaria, type = 'bar', orientation = 'h',
                name = 'Female', marker = list(color = '#ed9400')) %>%
      layout(
        barmode = 'overlay',
        xaxis = list(title = 'População', showticklabels = FALSE, tickvals = seq(-max(abs(dados_fx_et$couting)), max(abs(dados_fx_et$couting)), by = 10000),
                     ticktext = abs(seq(-max(abs(dados_fx_et$couting)), max(abs(dados_fx_et$couting)), by = 10000))),
        yaxis = list(title = 'Faixa Etária'),
        title = sprintf("Pirâmide etária para o ano de %s", input$ano),
        legend = list(title = list(text = 'Sexo')),
        annotations = list(
          x = 1,
          y = -0.1,
          text = 'Fonte: Datasus - coleta realizada em 14/05/2024',
          showarrow = FALSE,
          xref = 'paper',
          yref = 'paper',
          xanchor = 'right',
          yanchor = 'auto',
          xshift = 0,
          yshift = 0,
          font = list(size = 10)
        )
      )
    
    piramide
  })
  
  output$barplot_porcentagem <- renderPlot({
    dados_barplot <- dados_barplot()
    
    barplot_dados <- dados_barplot%>%
      group_by(year)%>%
      mutate(percentage = total_count/ sum(total_count) * 100)%>%
      ggplot(aes(x = factor(year), y = percentage, fill = sex))+
      geom_bar(stat = 'identity', position = 'fill')+
      scale_y_continuous(labels = scales::percent_format())+
      labs(title = paste0("Distribuição Percentual de Casos de Dengue por Ano em ", unique(dados_barplot$uf)),
           x = "Ano",
           y = "Porcentagem",
           fill = "Sexo") +
      theme_minimal()+
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1), # Rotacionar os rótulos do eixo x para melhor legibilidade
        panel.grid.major.x = element_blank(), # Remover as linhas de grade principais no eixo x
        panel.grid.minor.x = element_blank()  # Remover as linhas de grade menores no eixo x
      )
    barplot_dados
  } 
  )
  
  output$monthplot <- renderPlot({
    dengue_cases <- data()
    
    # Criar rótulos de cor baseados na combinação de uf e sexo
    dengue_cases <- dengue_cases %>%
      mutate(label = paste(uf, sex, sep = ", "))
    
    # Criar uma paleta de cores baseada nos rótulos
    unique_labels <- unique(dengue_cases$label)
    color_palette <- setNames(rainbow(length(unique_labels)), unique_labels)
    
    # Filtrar os dados com base nos sexos selecionados
    filtered_cases <- dengue_cases %>% filter(sex %in% input$sexo)
    
    plot <- ggplot(filtered_cases, aes(x = year, y = incidence_rate, color = label, group = label)) +
      geom_line() +
      geom_point() +
      labs(title = "Incidência de Dengue em UFs Selecionadas",
           x = "Ano",
           y = "Taxa de Incidência por 100,000 Pessoas",
           color = "UF, Sexo") +
      theme_minimal() +
      scale_color_manual(values = color_palette) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotacionar rótulos do eixo x para melhor visibilidade
    
    plot
  })
}




