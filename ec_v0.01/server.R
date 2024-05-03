server <- function(input, output) {
  
  #gerar plot de série temporal
  output$serie_temp_chik <- renderPlot({
    dados_filtrados <- dados_chik %>%
      filter(UF %in% input$selecao_uf[1])
  
    dados_filtrados_2 <- dados_chik%>%
      filter(UF %in% input$selecao_uf[2])
    
    #Não acabei!
    if('Masculino' %in% input$selecao_sexo){
      dados_masculinos_1 <- dados_filtrados%>%
        filter(nomes_faixa_etaria_masc %in% dados_filtrados)
    }

    # Verificar se alguma UF foi selecionada
    if (length(input$selecao_uf) == 0) {
      return(
        ggplot() +
          geom_text(aes(0.5, 0.5, label = "Nenhum dado disponível para a UF selecionada"),
                    color = "red", size = 5) +
          theme_void()
      )
    }
   
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
    }
    
    #Verifica se mais de uma UF foi selecionada
    if (nrow(dados_filtrados_2) > 0) {
      #Preciso trocar as cores para deixar o plot mais legível
      if('Casos_M_total' %in% input$selecao_sexo){
        print('Masculino presente')
        p <- p + geom_line(aes_string(y = dados_filtrados_2$Casos_M_total), color = 'blue')
      }
      if('Casos_F_total' %in% input$selecao_sexo){
        p <- p +  geom_line(aes_string(y = dados_filtrados_2$Casos_F_total), color = 'green')
      }
      if('Casos_total' %in% input$selecao_sexo){
        p <- p + geom_line(aes_string(y = dados_filtrados_2$Casos_total), color = 'purple')
      }
    }
    p
  })
}








