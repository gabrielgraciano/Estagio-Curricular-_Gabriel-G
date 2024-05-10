library(ggplot2)
library(dplyr)

dados_chik <- read.csv('dados/dados_chik.csv')


#Transformando os dados em numeric: ~ essencial
coluna_a_manter <- 'UF'
dados_chik <- dados_chik %>%
  mutate_if(names(.) != coluna_a_manter, as.numeric) %>%
  mutate_all(~replace(., is.na(.), 0))



##########
#Estou tentnando montar o database adequado para a pirâmide etária
grupo_idade <- c('Menor que 1 ano',' Menor que 1 ano', 'De 1 a 4 anos', 'De 1 a 4 anos', 'De 5 a 9 anos' , 'De 5 a 9 anos', 
                 'De 10 a 14 anos', 'De 10 a 14 anos', 'De 15 a 19 anos', 'De 15 a 19 anos', 
                 'De 20 a 39 anos',  'De 20 a 39 anos', 'De 40 a 59 anos', 'De 40 a 59 anos', 
                 'De 60 a 64 anos', 'De 60 a 64 anos', 'De 65 a 69 anos', 'De 65 a 69 anos',
                 'De 70 a 79 anos', 'De 70 a 79 anos', '80 anos ou mais', '80 anos ou mais')
UF_piramide <- c(unique(dados_chik$UF)) #27 UFs
sexo_piramide <- c('Masculino', 'Feminino')
populacao_piramide <- c(dados_chik$Casos_1_4M, dados_chik$Casos_1_4F)
ano_piramide <- c(unique(dados_chik$Ano))

##############

dados_sp_2018 <- dados_chik %>%
  filter(UF == 'São Paulo' & Ano == 2018)

dados_sp_2018_masc <- dados_sp_2018 %>%
  select(contains('M'))

dados_sp_2018_masc

resultados <- list()

for (i in 1:11) {
  proporcao <- dados_sp_2018_masc[[i]] / dados_sp_2018_masc[[12]] * 100
  # Arredondar para 2 dígitos decimais se não for uma divisão exata
  if (proporcao %% 1 != 0) {
    proporcao <- round(proporcao, digits = 2)
  }
  # Converter para string com 2 dígitos decimais e adicionar o símbolo de %
  resultados[[i]] <- paste0(sprintf("%.2f", proporcao), "%")
}


tab_casos <- as.data.frame(cbind(
  c('Menor que 1 ano', 'De 1 a 4 anos', 'De 5 a 9 anos', 'De 10 a 14 anos',
    'De 15 a 19 anos', 'De 20 a 39 anos', 'De 40 a 59 anos', 'De 60 a 64 anos', 
    'De 65 a 69 anos', 'De 70 a 79 anos', '80 anos ou mais'),
  resultados
))

colnames(tab_casos) <- c('Faixa Etária', 'Porcentagem')
as.table(tab_casos)

library(DT)
library(formattable)
datatable(tab_casos)
formattable(tab_casos, bordered)




c(round(dados_novos[[1]]/dados_novos[[12]] * 100,digits =3), dados_novos[[2]]/dados_novos[[12]] * 100,
  dados_novos[[3]]/dados_novos[[12]] * 100, dados_novos[[4]]/dados_novos[[12]] * 100,
  dados_novos[[5]]/dados_novos[[12]] * 100, dados_novos[[6]]/dados_novos[[12]] * 100,
  dados_novos[[7]]/dados_novos[[12]] * 100, dados_novos[[8]]/dados_novos[[12]] * 100,
  dados_novos[[9]]/dados_novos[[12]] * 100, dados_novos[[10]]/dados_novos[[12]] * 100,
  dados_novos[[11]]/dados_novos[[12]] * 100)





dados_chik%>%
  filter(UF == 'São Paulo')%>%
  filter(Ano == 2019)%>%
  ggplot(aes(y = grupo_idade, x = ))




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
