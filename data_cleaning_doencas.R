library(ggplot2)
library(dplyr)

dados_chik <- read.csv('dados/dados_chik.csv')

#Transformando os dados em numeric: ~ essencial
coluna_a_manter <- 'UF'
dados_chik <- dados_chik %>%
  mutate_if(names(.) != coluna_a_manter, as.numeric)







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
