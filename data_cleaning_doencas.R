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

cores_sexo <- c('lightblue', 'pink', 'brown')

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





# Definir as cores para cada sexo
cores <- c('lightblue', 'pink', 'brown')

# Criar um gráfico vazio
p <- ggplot(dados_sp, aes(x = Ano))

# Adicionar linhas para cada sexo usando um loop for
for (sexo in nomes_sexo) {
  p <- p + geom_line(aes_string(y = sexo, color = sexo), data = dados_sp) +
    scale_color_manual(values = cores[match(sexo, nomes_sexo)])
}

# Adicionar rótulos aos eixos e título
p <- p + labs(title = 'Casos de Chikungunya em São Paulo por Ano e Sexo',
              x = 'Ano',
              y = 'Número de Casos') +
  scale_color_identity()

# Exibir o gráfico
print(p)
