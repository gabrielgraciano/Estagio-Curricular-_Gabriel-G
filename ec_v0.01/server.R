server <- function(input, output) {
  
  output$serie_temp_chik <- renderPlot({
    dados_filtrados <- dados_chik %>%
      filter(UF %in% input$selecao_uf)
    
    cores <- c('lightblue', 'pink', 'brown')

    # Verificar se alguma UF foi selecionada
    if (length(input$selecao_uf) == 0) {
      return(
        ggplot() +
          geom_text(aes(0.5, 0.5, label = "Nenhum dado disponível para a UF selecionada"),
                    color = "red", size = 5) +
          theme_void()
      )
    }
    
    # Construir a string para o eixo y
    #y_var <- switch(input$selecao_sexo,
      #              "Masculino" = "Casos_M_total",
         #           "Feminino" = "Casos_F_total",
          #          "Ambos" = "Casos_total")
    
    # Plotar o gráfico apenas se houver dados disponíveis para a UF selecionada
    if (nrow(dados_filtrados) > 0) {
      p <- ggplot(dados_filtrados, aes(x = Ano))
      for (sexo in input$selecao_sexo){
        p <- p + geom_line(aes_string(y = sexo, color = sexo), data = dados_filtrados)
      }
      p <- p + labs(title = 'Casos de Chikungunya por ano e sexo',
                    x = 'Ano',
                    y = 'Número de casos')
        
      p
      
        
    } else {
      # Se não houver dados disponíveis, exibir uma mensagem informativa
      ggplot() + 
        geom_text(aes(0.5, 0.5, label = "Nenhum dado disponível para a UF selecionada"),
                  color = "red", size = 5) +
        theme_void()
    }
  })
}








