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
    # endpoint นี้ใช้ได้เฉพาะ client (/loans/{id}/documentsMetadata -> 404)
    # ถ้าจะดูเอกสารของ loan account ให้ใช้ Get Loan Account Documents Metadata
    #
    # คืนเอกสารที่ ownerType เป็น CLIENT และ ID_DOCUMENT ของ client รายนี้
    # ซึ่งก็คือ _documents.2.* และ _documents.1.* ที่ upload ใน beforeSending
    ${response}=    GET On Session    alias=mambu-session    url=/clients/${client_key}/documentsMetadata
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Get Loan Account Documents Metadata
    [Arguments]    ${loan_encoded_key}
    # endpoint เดียวกับที่ thinker-connector ใช้เช็คไฟล์ซ้ำก่อน upload (opj-1559)
    # ต้องใช้ query param ชื่อ "entity" เท่านั้น ยืนยันกับ sandbox แล้ว (2026-10-09):
    #   entity=LOAN_ACCOUNT      -> 200 + list เอกสาร
    #   entityType=LOAN_ACCOUNT  -> 500 errorCode 6 INTERNAL_ERROR
    # ownerKey ต้องเป็น encodedKey ของ loan (ไม่ใช่เลขสัญญา)
    # limit=1000 เพราะ default ของ Mambu คือ 50 ซึ่งน้อยกว่าจำนวน slot ถ้ามีไฟล์ซ้ำ
    &{params}=    Create Dictionary    entity=LOAN_ACCOUNT    ownerKey=${loan_encoded_key}    limit=1000
    ${response}=    GET On Session    alias=mambu-session    url=/documents/documentsMetadata    params=${params}
    Status Should Be    200    ${response}
    RETURN    ${response.json()}

Documents Should Not Be Duplicated
    [Arguments]    ${documents}
    # ทีมใช้ notes (label ภาษาไทยของ slot + Password) เป็นตัวแยกว่าเอกสารซ้ำหรือไม่
    # ตรงกับ connector v1.0.35 ที่ dedupe ด้วย notes (ชื่อไฟล์ซ้ำกันได้ เช่น test.png หลาย slot)
    ${duplicates}=    Evaluate
    ...    [f"{len(v)}x {k!r} files={sorted({d.get('fileName') for d in v})}" for k, v in __import__('itertools').groupby(sorted($documents, key=lambda d: str(d.get('notes'))), key=lambda d: d.get('notes')) for v in [list(v)] if len(v) > 1]
    Should Be Empty    ${duplicates}
    ...    Found duplicated documents (same notes) after booking retry: ${duplicates}

Count Unique Document Notes
    [Arguments]    ${documents}
    ${count}=    Evaluate    len({d.get('notes') for d in $documents})
    RETURN    ${count}

Save Loan Documents Snapshot
    [Arguments]    ${documents}    ${case_id}    ${label}
    # เก็บ file list ของ loan ไว้เทียบทีหลัง -> ${OUTPUT DIR}/loan_documents/<case_id>_<label>.json
    # อยู่ข้าง log.html / output.xml ของรอบนั้น (ใช้ --outputdir results/<ชื่อรอบ> ให้แต่ละรอบแยกกัน)
    ${dir}=    Set Variable    ${OUTPUT DIR}${/}loan_documents
    Create Directory    ${dir}
    ${path}=    Set Variable    ${dir}${/}${case_id}_${label}.json
    ${rows}=    Evaluate
    ...    sorted([{k: d.get(k) for k in ('id', 'encodedKey', 'fileName', 'notes', 'fileSize', 'creationDate')} for d in $documents], key=lambda d: (str(d['creationDate']), str(d['id'])))
    ${content}=    Evaluate    __import__('json').dumps({'case_id': $case_id, 'label': $label, 'count': len($rows), 'unique_notes': len({r['notes'] for r in $rows}), 'documents': $rows}, ensure_ascii=False, indent=2)
    Create File    ${path}    ${content}    encoding=UTF-8
    Log    <a href="loan_documents/${case_id}_${label}.json">${case_id}_${label}.json</a> (${rows.__len__()} documents)    html=True
    RETURN    ${path}

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
