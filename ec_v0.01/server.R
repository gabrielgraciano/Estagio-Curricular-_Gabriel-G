server <- function(input, output) {
  
  #gerar plot de série temporal
  output$serie_temp_chik <- renderPlot({
    
######################################################################################
    #Data handling
    dados_filtrados <- dados_chik %>%
      filter(UF %in% input$selecao_uf[1])
  
    dados_filtrados_2 <- dados_chik%>%
      filter(UF %in% input$selecao_uf[2])
    
    

    
    #Para dados masculinos
    if('Casos_M_total' %in% input$selecao_sexo){
      print('Aqui está rodando')
      dados_filtrados <- dados_filtrados%>%
        select(c(Ano, UF), contains('M'))
      dados_filtrados <- dados_filtrados%>%
        mutate(dados_faixa_etaria_masculino =rowSums(cbind(dados_filtrados[[input$selecao_idade[1]]], 
                                                           dados_filtrados[[input$selecao_idade[2]]]), na.rm = TRUE))
      dados_filtrados <- dados_filtrados%>%
        select(c(Ano, UF), contains('F'))
      dados_filtrados <- dados_filtrados%>%
        mutate(dados_faixa_etaria_feminina_teste = rowSums(cbind(dados_filtrados[[input$selecao_idade[1]]],
                                                                 dados_filtrados[[input$selecao_idade[2]]]), na.rm = TRUE))
    }
    
    if('Casos_M_total' %in% input$selecao_sexo){
      print('Aqui está rodando')
      dados_filtrados_2 <- dados_filtrados_2%>%
        select(c(Ano, UF), contains('M'))
      dados_filtrados_2 <- dados_filtrados_2%>%
        mutate(dados_faixa_etaria_masculino =rowSums(cbind(dados_filtrados_2[[input$selecao_idade[1]]], 
                                                           dados_filtrados_2[[input$selecao_idade[2]]]), na.rm = TRUE))
    }
    
    #Para dados femininos
    if('Casos_F_total' %in% input$selecao_sexo){
      print('Aqui está rodando')
      dados_filtrados <- dados_filtrados%>%
        select(c(Ano, UF), contains('F'))
      dados_filtrados <- dados_filtrados%>%
        mutate(dados_faixa_etaria_feminino =rowSums(cbind(dados_filtrados[[input$selecao_idade[1]]], 
                                                          dados_filtrados[[input$selecao_idade[2]]]), na.rm = TRUE))
    }
    
    if('Casos_F_total' %in% input$selecao_sexo){
      print('Aqui está rodando')
      dados_filtrados_2 <- dados_filtrados_2%>%
        select(c(Ano, UF), contains('F'))
      dados_filtrados_2 <- dados_filtrados_2%>%
        mutate(dados_faixa_etaria_feminino =rowSums(cbind(dados_filtrados_2[[input$selecao_idade[1]]], 
                                                          dados_filtrados_2[[input$selecao_idade[2]]]), na.rm = TRUE))
    }

    
###########################################################################
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
        p <- p + geom_line(aes_string(y = dados_filtrados$dados_faixa_etaria_masculino), color = 'lightblue') + theme_minimal()
      }
      if('Casos_F_total' %in% input$selecao_sexo){
        p <- p +  geom_line(aes_string(y = dados_filtrados$dados_faixa_etaria_feminina_teste), color = 'pink') + theme_minimal()
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
        p <- p + geom_line(aes_string(y = dados_filtrados_2$dados_faixa_etaria_masculino), color = 'blue') + theme_minimal()
      }
      if('Casos_F_total' %in% input$selecao_sexo){
        p <- p +  geom_line(aes_string(y = dados_filtrados_2$dados_faixa_etaria_feminino), color = 'green') + theme_minimal()
      }
      if('Casos_total' %in% input$selecao_sexo){
        p <- p + geom_line(aes_string(y = dados_filtrados_2$Casos_total), color = 'purple')
      }
    }
    p
  })
}








