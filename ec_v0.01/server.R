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
      print(input$selecao_sexo)
      if('Casos_M_total' %in% input$selecao_sexo){
        print('Masculino presente')
        p <- p + geom_line(aes_string(y = dados_filtrados$Casos_M_total), color = 'lightblue')
      }
      if('Casos_F_total' %in% input$selecao_sexo){
        p <- p +  geom_line(aes_string(y = dados_filtrados$Casos_F_total), color = 'pink')
      }
      if('Casos_total' %in% input$selecao_sexo){
        p <- p + geom_line(aes_string(y = dados_filtrados$Casos_total), color = 'purple')
      }
      
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








