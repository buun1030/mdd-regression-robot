***Settings***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    ../resources/verification_library.py

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
    Sleep    15s
    Wait Until Keyword Succeeds    5 minutes    5s
    ...    Post Batch Process Complete    ${session_id}    ${case_id}

Post Batch Process Complete
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/case-datasources/api/v1/callback/batch-process-complete    json=${payload}    headers=${headers}
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

Call Triggering Module Sync
    [Arguments]    ${session_id}    ${case_id}    ${task_id}    ${field_name}    ${triggering_module_name}    ${reference_key}=${EMPTY}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}    task_id=${task_id}    field_name=${field_name}    triggering_module_name=${triggering_module_name}    reference_key=${reference_key}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/call-triggering-module-sync    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    RETURN    ${response}

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
        ${response}=    Wait Until Keyword Succeeds    5x    3s
        ...    Post Get Task Detail    ${session_id}    ${task_id}
        Set To Dictionary    ${task_detail_map}    ${task_id}=${response.json()}[data]
    END
    RETURN    ${task_detail_map}

Post Get Task Detail
    [Arguments]    ${session_id}    ${task_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    task_id=${task_id}    all_task_mode=${False}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-task-detail    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    RETURN    ${response}

Edit Task Data
    [Arguments]    ${session_id}    ${payload}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/edit-task-data    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0

Verify Tasks
    [Arguments]    ${session_id}    ${case_id}
    ${task_ids}=    Get Task Ids    ${session_id}    ${case_id}
    FOR    ${task_id}    IN    @{task_ids}
        Wait Until Keyword Succeeds    5x    3s
        ...    Verify Single Task    ${session_id}    ${task_id}
    END

Verify Single Task
    [Arguments]    ${session_id}    ${task_id}
    ${detail_response}=    Post Get Task Detail    ${session_id}    ${task_id}
    ${detail_data}=    Set Variable    ${detail_response.json()}[data]
    ${task}=    Set Variable    ${detail_data['task']}
    IF    '${task['status']}' != 'claimed'
        Log    Skipping ${task_id}: status=${task['status']} (auto-released or already verified)
        RETURN
    END
    ${verifying_fields_raw}=    Get From Dictionary    ${detail_data}    verifying_fields    default=${{[]}}
    ${required_fields_raw}=    Get From Dictionary    ${detail_data}    required_fields    default=${{[]}}
    ${verifying_fields}=    Build Field Payload List    ${verifying_fields_raw}    filter_empty=${False}
    ${required_fields}=    Build Field Payload List    ${required_fields_raw}    filter_empty=${True}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    task_id=${task_id}    verifying_fields=${verifying_fields}    required_fields=${required_fields}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/verify-task-data    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    ${code}=    Set Variable    ${response.json()}[code]
    Should Be Equal As Integers    ${code}    0

Get Booking Detail
    [Arguments]    ${session_id}    ${case_id}
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-booking-report-detail    json=${payload}    headers=${headers}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}[data]

Send Case To External
    [Arguments]    ${session_id}    ${case_id}
    # manual rebook แบบเดียวกับที่ ops กด retry (autoFromSystem = false -> retry 1 ครั้ง)
    # synchronous: response กลับหลัง connector ทำงานจบทั้ง flow (รวม upload เอกสาร)
    # จึงต้องตั้ง timeout ยาว และไม่บังคับ status เพราะ booking อาจพังซ้ำได้ตามที่ตั้งใจ
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/send-case-to-external
    ...    json=${payload}    headers=${headers}    expected_status=any    timeout=180
    Log    send-case-to-external -> HTTP ${response.status_code}: ${response.text}
    RETURN    ${response}

Get Booking Latest Status
    [Arguments]    ${session_id}    ${case_id}
    # คืน latest_status หรือ '' ถ้ายังไม่มี booking report row
    # (taskpool insert row เป็น WAITING ตอน case กลายเป็น completed แล้วค่อยยิง
    #  /results ใน goroutine ดังนั้นมีช่วงที่ยังไม่มี row หรือยังเป็น WAITING)
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${session_id}
    &{payload}=    Create Dictionary    case_id=${case_id}
    ${response}=    POST On Session    alias=thinker-session    url=/question-taskpool/api/v1/get-booking-report-detail    json=${payload}    headers=${headers}    expected_status=any
    IF    ${response.status_code} != 200
        RETURN    ${EMPTY}
    END
    ${data}=    Get From Dictionary    ${response.json()}    data    default=${None}
    IF    ${data} == ${None}
        RETURN    ${EMPTY}
    END
    RETURN    ${data['latest_status']}

Get National ID From Answers
    [Arguments]    ${answers}
    FOR    ${answer}    IN    @{answers}
        IF    '${answer["field_name"]}' == '_customerInfo.nationalIdNumber'
            RETURN    ${answer['field_value']}
        END
    END
    Fail    National ID not found in answers