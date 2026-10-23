# Instalação

Verifique se o Python está instalado:

```bash
python --version

Python 3.14.4
```

Acesse a pasta do projeto:

```bash
cd robot-serverest-crud
```

Crie um ambiente virtual:

```bash
apt install python3.14-venv


```bash
python -m venv .venv
```

Ative o ambiente virtual.

Windows:

```bash
.venv\Scripts\activate
```

Linux/macOS:

```bash
source .venv/bin/activate

(.venv) ➜  robot-serverest-crud git:(main) ✗ 
```

### Arquivo `requirements.txt`


```text
robotframework
robotframework-requests
```

Instale as dependências:


```bash
pip install -r requirements.txt
```

## Cenários de teste

- Cadastro de usuário.
- Consulta de usuário.
- Atualização dos dados de usuário.
- Exclusão de usuário.
- Validação dos status HTTP e das respostas da API.

## Autor

Projeto desenvolvido para fins de estudo e prática de automação de testes de API.

Configuração das requisições

Crie o arquivo `resources/serverest.resource`.


```robot
*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}       https://serverest.dev
${USERS_ENDPOINT}    /usuarios

*** Keywords ***
Criar Sessao ServeRest
    Create Session
    ...    serverest
    ...    ${BASE_URL}
    ...    verify=True

Gerar Usuario
    [Arguments]    ${nome}    ${email}    ${password}    ${administrador}=false

    &{usuario}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}

    RETURN    ${usuario}

Validar Status HTTP
    [Arguments]    ${resposta}    ${status_esperado}

    Should Be Equal As Integers
    ...    ${resposta.status_code}
    ...    ${status_esperado}
```

Esse arquivo centraliza a configuração da API, a criação do payload e a validação do status HTTP, facilitando a reutilização das keywords.

## 5. Testes automatizados de CRUD

Crie o arquivo `tests/usuarios.robot`.


```robot
*** Settings ***
Resource         ../resources/serverest.resource
Suite Setup      Criar Sessao ServeRest
Suite Teardown   Delete All Sessions
Test Tags        api    serverest    crud

*** Test Cases ***
CT01 - Cadastrar Usuario
    ${sufixo}=    Evaluate    __import__('uuid').uuid4().hex
    ${email}=     Set Variable    qa_${sufixo}@teste.com
    ${usuario}=   Gerar Usuario
    ...    Usuario QA
    ...    ${email}
    ...    senha123
    ...    false

    ${resposta}=    POST On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}
    ...    json=${usuario}
    ...    expected_status=201

    Validar Status HTTP    ${resposta}    201
    Should Be Equal    ${resposta.json()}[message]
    ...    Cadastro realizado com sucesso

    ${id_usuario}=    Set Variable
    ...    ${resposta.json()}[_id]

    Set Suite Variable    ${ID_USUARIO}    ${id_usuario}
    Set Suite Variable    ${EMAIL_USUARIO}    ${email}

CT02 - Consultar Usuarios
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Dictionary Should Contain Key
    ...    ${resposta.json()}
    ...    usuarios

CT03 - Consultar Usuario Cadastrado
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Should Be Equal
    ...    ${resposta.json()}[nome]
    ...    Usuario QA

    Should Be Equal
    ...    ${resposta.json()}[email]
    ...    ${EMAIL_USUARIO}

CT04 - Atualizar Usuario
    &{usuario_atualizado}=    Gerar Usuario
    ...    Usuario QA Atualizado
    ...    ${EMAIL_USUARIO}
    ...    senha456
    ...    false

    ${resposta}=    PUT On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    json=${usuario_atualizado}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Should Be Equal    ${resposta.json()}[message]
    ...    Registro alterado com sucesso

CT05 - Validar Atualizacao do Usuario
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=200

    Should Be Equal
    ...    ${resposta.json()}[nome]
    ...    Usuario QA Atualizado

CT06 - Excluir Usuario
    ${resposta}=    DELETE On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Should Be Equal    ${resposta.json()}[message]
    ...    Registro excluído com sucesso

CT07 - Validar Exclusao do Usuario
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=400

    Validar Status HTTP    ${resposta}    400
    Should Be Equal    ${resposta.json()}[message]
    ...    Usuário não encontrado
```

Observação: os textos das mensagens e os status esperados seguem o comportamento usual da ServeRest. Caso a API apresente mensagens diferentes na versão atual, ajuste as asserções conforme a resposta real.

Os testes acima compartilham o usuário criado no primeiro caso. Por isso, devem ser executados na ordem apresentada e como uma única suíte. Para execução paralela ou independente, o ideal é que cada teste crie e limpe seus próprios dados.

## 6. Executando os testes

Na raiz do projeto, execute:

```bash
robot -d results tests/
```

O Robot Framework gera relatórios automaticamente:

`results/log.html`

Detalhamento das requisições, keywords e falhas.

`results/report.html`

Resumo da execução, quantidade de testes aprovados e reprovados.

`results/output.xml`

Resultados estruturados para integração com pipelines de CI/CD.

Para executar apenas os testes com a tag `crud`:

bash
```
robot -d results -i crud tests/
```

## 7. Arquivo `.gitignore`

text
```

.venv/
__pycache__/
*.pyc
results/
```