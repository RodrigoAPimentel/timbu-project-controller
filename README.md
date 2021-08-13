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
  - [Timbu](#Timbu)
  - [Projetos](#Projetos)
- [Uso](#Uso)

---

RodrigoAPimentel
timbu-project-controller

jabuti-environment-cli

## **Instalação/Configuração**

### **- Timbu**

1. Baixe o **Timbu** na mesma pasta aonde esta os projetos.
2. Modifique o nome do arquivo **_.env.example_** para **_.env_** e configure as variaveis com os correspondentes valores.

### **- Projetos**

1. Copie o conteudo da pasta **_project-configurations_** para dentro da pasta do respectivo projeto (backend || frontend).
2. Modifique o nome do arquivo **_.env.example_** para **_.env_** e configure as variaveis com os correspondentes valores, caso seja necessario acrescente as variaveis desejaveis

> #### **_P.S: Lembre-se de incluir o arquivo .env no .gitignore para que não seja comitado no repositorio pois possui informações sensiveis._**

---

## **Uso**

- **./execution-manager.sh up:** _Inicia os projetos e nginx;_
- **./execution-manager.sh up -m:** _Inicia os projetos, nginx e Stack de Monitoramento;_
- **./execution-manager.sh down:** _Para exclue todos os containers inciados;_
