# CLYVO VET - Database Challenge

Projeto desenvolvido para a disciplina **Mastering Relational and Non-Relational Database** da FIAP.

## Integrantes

- Lucas Rafael Solimene - RM 565194
- Samyr Couto Oliveira - RM 565562
- Henrique Teixeira Cesar - RM 563088

## Sobre o projeto

O **CLYVO VET** é um sistema de gestão veterinária com banco de dados Oracle.

O projeto armazena informações de:

- Usuários
- Responsáveis
- Veterinários
- Clínicas
- Pets
- Consultas
- Vacinas
- Lembretes
- Sensores
- Leituras
- Logs de erro
- Auditoria

Também possui rotinas em **PL/SQL** para validação, relatórios, tratamento de exceções e auditoria.

## Principais recursos

- Function `fn_consulta_json`
- Function `fn_validar_cpf`
- Procedure `pr_consulta_pet_json`
- Procedure `pr_relatorio_leituras`
- Trigger `trg_auditoria_consulta`
- Tabela `LOG_ERRO`
- Tabela `AUDITORIA`
- Monitoramento de temperatura e atividade por sensores

## Estrutura do repositório

```text
Database-Challenge/
│
├── Dockerfile.oracle
├── banco_dados_challenge.pdf
├── README.md
└── docker-entrypoint-initdb.d/
    └── sql_challenge.sql