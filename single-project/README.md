# **Timbu Project Controller**

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/RodrigoAPimentel/timbu-project-controller)
![GitHub repo size](https://img.shields.io/github/repo-size/RodrigoAPimentel/timbu-project-controller)
![Github All Contributors](https://img.shields.io/github/contributors/RodrigoAPimentel/timbu-project-controller)
![Language](https://img.shields.io/github/languages/count/RodrigoAPimentel/timbu-project-controller)
![Top Language](https://img.shields.io/github/languages/top/RodrigoAPimentel/timbu-project-controller)
![Commit Activity](https://img.shields.io/github/commit-activity/m/RodrigoAPimentel/timbu-project-controller)
![GitHub last commit (master)](https://img.shields.io/github/last-commit/RodrigoAPimentel/timbu-project-controller/master)

Conjunto de configurações e ferramentas para Controlar e auxiliar no desenvolvimento conteneirizado de aplicações backend e frontend. Com um simples comando é possivel iniciar com o Docker o backend, frontend, nginx e Stack de Monitoramento ou apenas os projetos.

- [Instalação/Configuração](#Instalação/Configuração)
- [Uso](#Uso)

---

## **Instalação/Configuração**

1. Coloque a pasta **_bin_** na raiz do projeto.
2. Modifique o nome do arquivo **_.env.example_** para **_.env_** e configure as variaveis com os correspondentes valores. Mova o **_.env_** para a raiz do projeto.

> #### **_P.S: Lembre-se de incluir o arquivo .env no .gitignore para que não seja comitado no repositorio pois possui informações sensiveis._**

---

## **Uso**

**./execution.sh {up|down} [--all] [--prune]**

- **./execution.sh up** -> _Inicia os containers Docker interativamente._
- **./execution.sh down** -> _Para os containers Docker interativamente._
- **./execution.sh up --all** -> _Inicia todos os containers Docker._
- **./execution.sh down --all** -> _Para todos os containers Docker._
- **./execution.sh down --all --prune** -> _Para todos os containers Docker e limpa o sistema._
