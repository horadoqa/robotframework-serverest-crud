# Robot Framework ServeRest CRUD

Projeto de automação de testes de API utilizando [Robot Framework](<https://robotframework.org/>), Python e a API ServeRest, com foco nas operações CRUD de usuários.

## Objetivo

Praticar automação de testes de API, validando as principais operações de gerenciamento de usuários:

- **Create:** cadastrar um novo usuário.
- **Read:** consultar usuários cadastrados e buscar um usuário específico.
- **Update:** atualizar os dados de um usuário.
- **Delete:** excluir um usuário.
- **Assertions:** validar status HTTP, mensagens e conteúdo das respostas.

## Tecnologias utilizadas

- [Robot Framework](<https://robotframework.org/>)
- [Python](<https://www.python.org/>)
- [RequestsLibrary](<https://marketsquare.github.io/robotframework-requests/>)
- [ServeRest API](<https://serverest.dev>)

A biblioteca `RequestsLibrary` será utilizada para enviar requisições HTTP, como `GET`, `POST`, `PUT` e `DELETE`.

## Estrutura do projeto

```text
robot-serverest-crud/
├── resources/
│   └── serverest.resource
├── tests/
│   └── usuarios.robot
├── results/
├── requirements.txt
├── .gitignore
└── README.md
```

## Instalação

Clone o repositório:

```
git clone https://github.com/horadoqa/robot-serverest-crud.git
```

Acesse a pasta do projeto:

```
cd robot-serverest-crud
```

Crie e ative um ambiente virtual, se desejar, e instale as dependências:

```
pip install -r requirements.txt
```

## Execução dos testes

Execute toda a suíte:

```
robot -d results tests/
```

Execute apenas os testes com a tag `crud`:

```
robot -d results -i crud tests/
```

## Relatórios

Após a execução, consulte:

- `results/report.html`: resumo dos resultados.
- `results/log.html`: detalhes da execução.
- `results/output.xml`: resultados estruturados.

## Cenários de teste

- CT01 - Validação de status HTTP e mensagens retornadas pela API.
- CT02 - Cadastrar Usuario.
- CT03 - Consultar Usuarios
- CT04 - Consultar Usuario Cadastrado
- CT05 - Atualizar Usuario
- CT06 - Validar Atualizacao do Usuario
- CT07 - Excluir Usuario
- CT08 - Validar Exclusao do Usuario

## Autor

Projeto desenvolvido para fins de estudo e prática de automação de testes de API com Robot Framework e Python.