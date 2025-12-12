# Banco-de-Dados

# 🛩️ Análise de Ocorrências Aeronáuticas no Brasil

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Status](https://img.shields.io/badge/Status-Concluído-success)
![License](https://img.shields.io/badge/License-MIT-green)

Projeto acadêmico de **Fundamentos de Banco de Dados** desenvolvido no IF Baiano - Campus Guanambi, focado na exploração e otimização de uma base de dados real de ocorrências aeronáuticas brasileiras disponibilizada pela FAB.

## 📋 Sobre o Projeto

Este trabalho teve como objetivo aplicar conceitos fundamentais de modelagem relacional e SQL em um contexto real e desafiador: uma base de dados governamental com inconsistências estruturais, formatos mistos e registros incompletos.

**Diferencial:** Ao invés de trabalhar com dados idealizados, optamos por **preservar a estrutura original** e implementar melhorias incrementais, simulando um ambiente profissional real onde nem sempre é possível redesenhar sistemas completamente.

## 👥 Equipe

- **Arthur Guimarães Miranda Prates**
- **Daniel da Silva Oliveira**
- **Davi Monteiro Carvalho**
- **Jâmerson de Souza Silva**

**Orientadora:** Prof.ª Sarah Moniky Silva Ribeiro

## 🎯 Objetivos Alcançados

- ✅ Importação e estruturação de base de dados real da FAB
- ✅ Definição de chaves primárias e estrangeiras
- ✅ Implementação de constraints de integridade
- ✅ Conversão de tipos de dados (VARCHAR → DATE)
- ✅ Desenvolvimento de consultas SQL complexas
- ✅ Análises estatísticas sobre segurança aeronáutica
- ✅ Documentação técnica completa

## 📊 Estrutura da Base de Dados

```
tabela_ocorrencia (principal)
├── tabela_tipo_ocorrencia
├── tabela_aeronave
├── tabela_fator_contribuinte
└── tabela_recomendacao_seguranca
```

**Relacionamentos:** 1:N entre ocorrências e suas tabelas periféricas

## 🛠️ Tecnologias Utilizadas

- **MySQL 8.0** - Sistema Gerenciador de Banco de Dados
- **MySQL Workbench** - Interface de desenvolvimento
- **SQL** - Linguagem de consulta e manipulação

## 🚀 Como Executar

### Pré-requisitos

- MySQL Server 8.0 ou superior
- MySQL Workbench (recomendado)
- Base de dados disponível em: [dados.gov.br](https://dados.gov.br/dados/conjuntos-dados/ocorrencias-aeronauticas-da-aviacao-civil-brasileira)

### Passo a Passo

1. **Clone o repositório**
```bash
git clone https://github.com/danieloliveira33/Banco-de-Dados.git
cd Banco-de-Dados
```

2. **Crie o banco de dados**
```bash
mysql -u root -p < schema_setup.sql
```

3. **Importe os dados**
- Baixe os CSVs do portal de dados abertos
- Importe via MySQL Workbench (Table Data Import Wizard)

4. **Execute as conversões e consultas**
```bash
mysql -u root -p acidentes_aeronaves < data_conversion.sql
mysql -u root -p acidentes_aeronaves < queries.sql
```

## 🔍 Principais Desafios e Soluções

### 1. Inconsistência Referencial
**Problema:** Chaves estrangeiras apontando para registros inexistentes  
**Solução:** Uso temporário de `SET FOREIGN_KEY_CHECKS = 0` para tolerar inconsistências pré-existentes

### 2. Formatos de Data Mistos
**Problema:** Datas armazenadas em VARCHAR com formatos `dd/mm/yyyy` e `yyyy-mm-dd`  
**Solução:** Conversão com REGEXP para identificar formato + STR_TO_DATE() específico

### 3. Valores NULL Massivos
**Problema:** Campos importantes com alta proporção de valores nulos  
**Solução:** Uso de filtros `WHERE campo IS NOT NULL` nas análises

## 📈 Consultas e Análises Desenvolvidas

### Consultas Básicas
- Listagem de todas as ocorrências
- Aeronaves por ocorrência específica
- Recomendações de segurança por ocorrência
- Inserção de novos registros com integridade referencial

### Análises Estatísticas
- Ranking de fabricantes com mais ocorrências
- Fases de voo mais críticas (decolagem, pouso, cruzeiro)
- Distribuição geográfica de incidentes
- Aeroportos de origem com maior incidência
- Evolução temporal de ocorrências
- Análise de fatalidades por classificação

## 📊 Exemplos de Queries

### Ocorrências por Estado
```sql
SELECT 
    ocorrencia_uf,
    COUNT(*) as total_ocorrencias
FROM tabela_ocorrencia
GROUP BY ocorrencia_uf
ORDER BY total_ocorrencias DESC;
```

### Top 10 Aeroportos com Mais Acidentes
```sql
SELECT 
    aeronave_voo_origem, 
    COUNT(*) as frequencia
FROM tabela_aeronave
GROUP BY aeronave_voo_origem
ORDER BY frequencia DESC
LIMIT 10;
```

### Fases de Voo Mais Perigosas
```sql
SELECT 
    aeronave_fase_operacao,
    COUNT(*) as total,
    ROUND(COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM tabela_aeronave), 2) as percentual
FROM tabela_aeronave
WHERE aeronave_fase_operacao IS NOT NULL
GROUP BY aeronave_fase_operacao
ORDER BY total DESC;
```

## 🎓 Aprendizados

### Técnicos
- Modelagem relacional em contextos não idealizados
- Implementação de constraints de integridade
- Conversão e normalização de dados
- Otimização de queries complexas
- Uso de JOINs, agregações e subconsultas

### Profissionais
- Trabalho com dados reais e suas imperfeições
- Tomada de decisão em ambientes com limitações
- Documentação técnica de problemas e soluções
- Análise crítica de estruturas legadas
- Simulação de cenários corporativos reais


## 🤝 Contribuições

Este é um projeto acadêmico, mas sugestões e melhorias são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova análise'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request

**Nota:** Os dados utilizados são públicos e disponibilizados pela Força Aérea Brasileira através do portal de dados abertos do governo federal. Este projeto tem fins exclusivamente acadêmicos e educacionais.
