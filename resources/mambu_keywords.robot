***Settings***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Variables    ../vars.yaml

***Variables***
${MAMBU_BASE_URL}    https://moneyddapp.sandbox.mambu.com/api
${MAMBU_API_KEY}     ${mambu-api-key}

***Keywords***
Create Mambu Session
    &{headers}=    Create Dictionary    Content-Type=application/json    Accept=application/vnd.mambu.v2+json    apikey=${MAMBU_API_KEY}
    Create Session    alias=mambu-session    url=${MAMBU_BASE_URL}    headers=${headers}    verify=${False}
    Evaluate    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)    urllib3

Get Client By Id Number
    [Arguments]    ${id_number}
    ${response}=    GET On Session    alias=mambu-session    url=/clients    params=idNumber=${id_number}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Search Loans By Account Holder Id
    [Arguments]    ${account_holder_id}
    &{filter_criteria}=    Create Dictionary    field=accountHolderId    operator=EQUALS_CASE_SENSITIVE    value=${account_holder_id}
    @{filter_criteria_list}=    Create List    ${filter_criteria}
    &{payload}=    Create Dictionary    filterCriteria=${filter_criteria_list}
    ${full_url}=    Catenate    SEPARATOR=/    ${MAMBU_BASE_URL}    loans:search
    ${response}=    POST On Session    alias=mambu-session    url=${full_url}    json=${payload}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Change Loan State
    [Arguments]    ${loan_id}    ${action}    ${notes}
    &{payload}=    Create Dictionary    action=${action}    notes=${notes}
    ${response}=    POST On Session    alias=mambu-session    url=/loans/${loan_id}:changeState    json=${payload}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Disburse Loan
    [Arguments]    ${loan_id}    ${notes}    ${amount}=${None}    ${percentage}=0    ${predefinedFeeKey}=8ae1e518938d05ef0193b9b11aae05ca
    IF    ${amount} != ${None}    
        &{fee}=    Create Dictionary    amount=${amount}    percentage=${percentage}    predefinedFeeKey=${predefinedFeeKey}
        @{fees}=    Create List    ${fee}
        &{payload}=    Create Dictionary    notes=${notes}    fees=${fees}
    ELSE
        &{payload}=    Create Dictionary    notes=${notes}
    END
    ${response}=    POST On Session    alias=mambu-session    url=/loans/${loan_id}/disbursement-transactions    json=${payload}
    Status Should Be    201    ${response}
    RETURN    ${response.json()}

Make Loan Repayment
    [Arguments]    ${loan_id}    ${amount}    ${notes}
    &{payload}=    Create Dictionary    amount=${amount}    notes=${notes}
    ${response}=    POST On Session    alias=mambu-session    url=/loans/${loan_id}/repayment-transactions    json=${payload}
    Status Should Be    201    ${response}
    RETURN    ${response.json()}
