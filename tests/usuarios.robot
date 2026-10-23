*** Settings ***
Resource         ../resources/serverest.resource
Suite Setup      Criar Sessao ServeRest
Suite Teardown   Delete All Sessions
Test Tags        api    serverest    crud

*** Test Cases ***
CT01 - Validação de status HTTP e mensagens retornadas pela API.
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Dictionary Should Contain Key
    ...    ${resposta.json()}
    ...    usuarios
    ...    

CT02 - Cadastrar Usuario
    # ${sufixo}=    Evaluate    __import__('uuid').uuid4().hex
    # ${email}=     Set Variable    horadoqa_${sufixo}@teste.com
    ${email}=     Set Variable    horadoqa@teste.com
    ${usuario}=   Gerar Usuario
    ...    Usuario QA
    ...    ${email}
    ...    1q2w3e4r
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

CT03 - Consultar Usuarios
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Dictionary Should Contain Key
    ...    ${resposta.json()}
    ...    usuarios

CT04 - Consultar Usuario Cadastrado
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

CT05 - Atualizar Usuario
    &{usuario_atualizado}=    Gerar Usuario
    ...    Usuario QA Atualizado
    ...    ${EMAIL_USUARIO}
    ...    1q2w3e4r
    ...    false

    ${resposta}=    PUT On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    json=${usuario_atualizado}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Should Be Equal    ${resposta.json()}[message]
    ...    Registro alterado com sucesso

CT06 - Validar Atualizacao do Usuario
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=200

    Should Be Equal
    ...    ${resposta.json()}[nome]
    ...    Usuario QA Atualizado

CT07 - Excluir Usuario
    ${resposta}=    DELETE On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=200

    Validar Status HTTP    ${resposta}    200
    Should Be Equal    ${resposta.json()}[message]
    ...    Registro excluído com sucesso

CT08 - Validar Exclusao do Usuario
    ${resposta}=    GET On Session
    ...    serverest
    ...    ${USERS_ENDPOINT}/${ID_USUARIO}
    ...    expected_status=400

    Validar Status HTTP    ${resposta}    400
    Should Be Equal    ${resposta.json()}[message]
    ...    Usuário não encontrado
