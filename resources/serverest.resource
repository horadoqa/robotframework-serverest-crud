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
    