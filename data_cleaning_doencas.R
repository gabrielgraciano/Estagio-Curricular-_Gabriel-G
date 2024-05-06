library(ggplot2)
library(dplyr)

dados_chik <- read.csv('dados/dados_chik.csv')

dados_chik$Ano <- as.numeric(dados_chik$Ano)
dados_chik$Casos_total <- as.numeric(dados_chik$Casos_total)
dados_chik$Casos_M_total <- as.numeric(dados_chik$Casos_M_total)
dados_chik$Casos_F_total <- as.numeric(dados_chik$Casos_F_total)
dados_chik$Casos_1M <- as.numeric(dados_chik$Casos_1M)
dados_chik$Casos_1_4M <- as.numeric(dados_chik$Casos_1_4M)
dados_chik$Casos_5_9M <- as.numeric(dados_chik$Casos_5_9M)
dados_chik$Casos_10_14M <- as.numeric(dados_chik$Casos_10_14M)
dados_chik$Casos_15_19M <- as.numeric(dados_chik$Casos_15_19M)

class(dados_chik$Casos_1M)

somando <- function(...) {
  total <- 0
  for (valor in list(...)) {
    valor <- replace(valor, is.na(valor), 0)  # Substitui NA por 0
    total <- total + valor
  }
  return(total)
}

# Exemplo de uso da função somando
resultado <- somando(3, NA, 5, 7, NA, 10)
print(resultado)  # Deve imprimir 25




testando_dados <- dados_chik%>%
  select(c(Ano, UF), ends_with('M'))

testando_dados <- testando_dados %>%
  mutate(soma_dados_testando = rowSums(cbind(Casos_1M, Casos_1_4M), na.rm = TRUE))



View(testando_dados)
  
class(testando_dados$Casos_1M)
class(testando_dados$Casos_1_4M)


  dados_masculinos_1 <- dados_masculinos_1%>%
  mutate(dados_faixa_etaria_masculino = sum(nomes_faixa_etaria_masc))
View(testando_dados)


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
