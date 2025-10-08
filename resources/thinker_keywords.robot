***Settings***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

***Variables***
${THINKER_BASE_URL}    https://moneydd-dev.thinkerfint.com

***Keywords***
Create Thinker Session
    Create Session    alias=thinker-session    url=${THINKER_BASE_URL}    verify=${False}
    Evaluate    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)    urllib3

Login
    [Arguments]    ${email}    ${password}
    &{headers}=    Create Dictionary    Content-Type=application/json
    &{payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    alias=thinker-session    url=/authentication/api/v1/login    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${session_id}=    Set Variable    ${response.json()}[data][session_id]
    RETURN    ${session_id}

Apply For Product
    [Arguments]    ${session_id}    ${product_name}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    product_name=${product_name}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/apply-for-product    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${case_id}=    Set Variable    ${response.json()}[data][case_id]
    RETURN    ${case_id}

Answer Questions
    [Arguments]    ${session_id}    ${case_id}    ${answers_payload}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}    answers=${answers_payload}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/answer-question    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0

Submit Case
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/case-datasources/api/v1/cases/submit    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${message}=    Set Variable    ${response.json()}[message]
    Should Be Equal As Strings    ${message}    processing

Complete Batch Process
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    Sleep    10s
    ${response}=    POST On Session    alias=thinker-session    url=/case-datasources/api/v1/callback/batch-process-complete    json=${payload}    headers=${headers}    expected_status=any
    FOR    ${i}    IN RANGE    3
        Exit For Loop If    ${response.status_code} == 200
        Sleep    5s
        ${response}=    POST On Session    alias=thinker-session    url=/case-datasources/api/v1/callback/batch-process-complete    json=${payload}    headers=${headers}    expected_status=any
    END
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Strings    ${code}    0

Get Case Detail
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-case-detail    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}[data]

Claim Case
    [Arguments]    ${session_id}    ${case_id}
    Sleep    5s
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/claim-case    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0
    RETURN    ${response.json()}[data]

Release Case
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/release-case    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0

Get Task Ids
    [Arguments]    ${session_id}    ${case_id}
    Sleep    5s
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    @{task_ids}=    Create List
    FOR    ${task}    IN    @{case_detail['all_tasks']}
        IF    '${task['status']}' == 'claimed'
            Append To List    ${task_ids}    ${task['task_id']}
        END
    END
    RETURN    ${task_ids}

Get Task Details
    [Arguments]    ${session_id}    ${case_id}
    Sleep    10s
    ${task_ids}=    Get Task Ids    ${session_id}    ${case_id}
    &{task_detail_map}=    Create Dictionary
    FOR    ${task_id}    IN    @{task_ids}
        &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
        &{payload}=    Create Dictionary    task_id=${task_id}    all_task_mode=${False}
        ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-task-detail    json=${payload}    headers=${headers}
        Status Should Be    200    ${response}
        Set To Dictionary    ${task_detail_map}    ${task_id}=${response.json()}[data]
    END
    RETURN    ${task_detail_map}

Edit Task Data
    [Arguments]    ${session_id}    ${payload}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/edit-task-data    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0

Verify Tasks
    [Arguments]    ${session_id}    ${case_id}
    ${task_details}=    Get Task Details    ${session_id}    ${case_id}
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
        @{verifying_fields}=    Create List
        IF    'verifying_fields' in $detail_data
            FOR    ${field_i}    IN    @{detail_data['verifying_fields']}
                ${field}=    Set Variable    ${field_i['field']}
                &{field_data}=    Create Dictionary    field_name=${field['field_name']}    field_value=${field['current_value']}
                Append To List    ${verifying_fields}    ${field_data}
            END
        END
        @{required_fields}=    Create List
        IF    'required_fields' in $detail_data
            FOR    ${field_i}    IN    @{detail_data['required_fields']}
                ${field}=    Set Variable    ${field_i['field']}
                &{field_data}=    Create Dictionary    field_name=${field['field_name']}    field_value=${field['current_value']}
                Append To List    ${required_fields}    ${field_data}
            END
        END
        &{payload}=    Create Dictionary    task_id=${task_id}    verifying_fields=${verifying_fields}    required_fields=${required_fields}
        ${task}=    Set Variable    ${detail_data['task']}
        IF    '${task['status']}' == 'claimed'
            ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/verify-task-data    json=${payload}    headers=${headers}
            Status Should Be    200    ${response}
            ${code}=    Set Variable    ${response.json()}[code]
            Should Be Equal As Integers    ${code}    0
        END
    END

Get Booking Detail
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-booking-report-detail    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}[data]

Get National ID From Answers
    [Arguments]    ${answers}
    FOR    ${answer}    IN    @{answers}
        IF    '${answer["field_name"]}' == '_customerInfo.nationalIdNumber'
            RETURN    ${answer['field_value']}
        END
    END
    Fail    National ID not found in answers