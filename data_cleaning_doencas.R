library(ggplot2)
library(dplyr)

dados_chik <- read.csv('dados/dados_chik.csv')

dados_chik$Ano <- as.numeric(dados_chik$Ano)
dados_chik$Casos_total <- as.numeric(dados_chik$Casos_total)
dados_chik$Casos_M_total <- as.numeric(dados_chik$Casos_M_total)
dados_chik$Casos_F_total <- as.numeric(dados_chik$Casos_F_total)

dados_chik%>%
  filter(UF == 'São Paulo')%>%
  ggplot(aes(x = Ano, y = Casos_total))+
  geom_point()

dados_chik%>%
  filter(UF == 'Minas Gerais')%>%
  ggplot(aes(x = Ano, y = Casos_total))+
  geom_line()

View(dados_chik)

nomes_sexo <- c(
  'Masculino' = 'Casos_M_total',
  'Feminino' = 'Casos_F_total',
  'Ambos' = 'Casos_total'
)

# Filtrar os dados para São Paulo
dados_sp <- dados_chik %>%
  filter(UF == 'São Paulo')

# Plotar o gráfico de linhas
ggplot(dados_sp, aes(x = Ano)) +
  geom_line(aes_string(y = nomes_sexo['Masculino']), color = 'lightblue') +
  geom_line(aes_string(y = nomes_sexo['Feminino']), color = 'pink') +
  geom_line(aes_string(y = nomes_sexo['Ambos']), color = 'brown') +
  labs(title = 'Casos de Chikungunya em São Paulo por Ano e Sexo',
       x = 'Ano',
       y = 'Número de Casos') +
  scale_color_manual(values = c('lightblue', 'pink', 'brown'), 
                     labels = c('Masculino', 'Feminino', 'Ambos'))



########guardando
ggplot(dados_filtrados, aes(x = Ano, y = input$selecao_sexo)) +
  geom_line() +
  labs(title = "Número de casos de Chikungunya ao longo do tempo",
       x = "Ano",
       y = "Número de Casos") +
  scale_y_continuous(labels = scales::comma)

