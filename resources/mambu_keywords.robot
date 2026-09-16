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

Get Client Documents Metadata
    [Arguments]    ${client_key}
    # ใช้ได้เฉพาะ client เท่านั้น - Mambu v2 ไม่มี endpoint แบบเดียวกันสำหรับ loan
    # account (/loans/{id}/documentsMetadata -> 404 INVALID_API_OPERATION)
    #
    # คืนเอกสารที่ ownerType เป็น CLIENT และ ID_DOCUMENT ของ client รายนี้
    # ซึ่งก็คือ _documents.2.* และ _documents.1.* ที่ upload ใน beforeSending
    ${response}=    GET On Session    alias=mambu-session    url=/clients/${client_key}/documentsMetadata
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Count Documents By Notes Prefix
    [Arguments]    ${documents}    ${notes_prefix}
    # เอกสารในระบบตั้งชื่อไฟล์ซ้ำกันเยอะ (test.png หลาย slot) ตัวที่แยกประเภทจริง
    # คือ label ภาษาไทยที่อยู่หน้าสุดของ notes จึงต้อง group ด้วย notes ไม่ใช่ name
    ${count}=    Set Variable    ${0}
    FOR    ${doc}    IN    @{documents}
        ${notes}=    Get From Dictionary    ${doc}    notes    default=${EMPTY}
        IF    $notes is not None and str($notes).startswith($notes_prefix)
            ${count}=    Evaluate    ${count} + 1
        END
    END
    RETURN    ${count}

Search Loans By Case Id
    [Arguments]    ${case_id}
    # thinker-connector เก็บ case_id ไว้ใน custom field _thinker.caseId ของ loan
    # (results.service.ts -> beforeSending: _thinker: {caseId: rawResult.case_id})
    # ยืนยันแล้วว่า Mambu search ด้วย field นี้ได้ (EQUALS -> เจอ)
    #
    # ต้องใช้วิธีนี้เพราะ Mambu v2 ไม่มี endpoint ลิสต์เอกสารของ loan account
    # (/loans/{id}/documentsMetadata -> 404 INVALID_API_OPERATION) เลยยืนยัน
    # ผลการ upload ตรง ๆ ไม่ได้ ทำได้แค่ยืนยันว่า loan ถูกสร้างจริง
    &{filter_criteria}=    Create Dictionary    field=_thinker.caseId    operator=EQUALS    value=${case_id}
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
