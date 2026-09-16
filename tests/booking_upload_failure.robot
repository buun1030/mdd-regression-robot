***Settings***
Resource    ../resources/normal_keywords.robot
Resource    ../resources/global_setup.robot
Suite Setup    Global Suite Setup

***Test Cases***
Run Normal A02 P-Loan Booking Failed From Document Upload Rejected By Mambu
    [Documentation]    ตรวจว่าเมื่อ thinker-connector upload เอกสารเข้า Mambu ไม่สำเร็จ
    ...                booking จะถูก stamp เป็น FAILED และ case กลายเป็น book_error
    ...                และ retry ต้องไม่สร้าง loan account ซ้ำ
    ...
    ...                วิธีจำลอง: ตั้ง _documents.5.name เป็น "evil.exe" ซึ่งเป็นนามสกุล
    ...                ที่ไม่อยู่ใน whitelist ของ Mambu ทำให้ POST /documents ตอบ
    ...                HTTP 400 errorCode 972 FILE_EXTENSION_NOT_ALLOWED
    ...                ส่วน content ยังเป็น base64 png ที่ใช้ได้จริง เพื่อให้พังที่ขั้น
    ...                upload เท่านั้น ไม่ใช่ขั้นดึงไฟล์จาก file-service
    ...
    ...                _documents.5.* เป็น slot ของ loan account (3-31) ที่ถูก upload
    ...                ใน afterLoanAccountCreated หลัง POST /loans สำเร็จแล้ว ดังนั้น
    ...                loan จะถูกสร้างใน Mambu ก่อนที่ upload จะพัง
    ...
    ...                เทสนี้ครอบ 2 พฤติกรรมที่แก้ไปใน op-872:
    ...                1. connector propagate upload error กลับมาแทนที่จะกลืน
    ...                   (ก่อนแก้ได้ latest_status = COMPLETED)
    ...                2. idempotency guard - onResult ยิง loans:search ด้วย
    ...                   _thinker.caseId ก่อนสร้าง loan ถ้าเจอแล้วให้ reuse
    ...                   (ก่อนแก้ retry 5 ครั้งได้ loan 5 ใบ + เผาเลขสัญญา 5 เลข)
    [Tags]    booking    upload-failure

    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=
    ...    Normal Workflow Expecting Book Error    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO}

    Log    Step 14: ยืนยันว่า loan ถูกสร้างใน Mambu ใบเดียว (ไม่ซ้ำจากการ retry)
    ${loans}=    Search Loans By Case Id    ${case_id}
    ${loan_count}=    Get Length    ${loans}
    FOR    ${loan}    IN    @{loans}
        Log    loan id=${loan['id']} encodedKey=${loan['encodedKey']} state=${loan['accountState']}
    END

    # taskpool ยิง POST /results ซ้ำ 5 ครั้ง (Booking.MaxRetries = 5)
    # แต่ onResult มี idempotency guard ที่ยิง loans:search ด้วย _thinker.caseId
    # ก่อนสร้าง loan ถ้าเจอแล้วจะ reuse encodedKey เดิมโดยไม่ขอเลขสัญญาใหม่
    # ดังนั้นถึงจะ retry 5 รอบก็ต้องได้ loan ใบเดียว
    #
    # ถ้าเจอมากกว่า 1 ใบแปลว่า guard ใช้ไม่ได้ผล -> ทุกรอบที่ retry จะเผาเลขสัญญา
    # ทิ้งหนึ่งเลขและทิ้ง orphan loan ไว้ให้ ops ตามปิดเอง
    Should Be Equal As Integers    ${loan_count}    1
    ...    Expected exactly 1 loan for case ${case_id} (idempotency guard should make booking retry reuse the existing loan) but found ${loan_count}

    # upload พังก่อนถึงขั้น approve เพราะ afterLoanAccountCreated await uploads
    # ก่อนเรียก approveLoan -> loan ต้องค้างที่ PENDING_APPROVAL ไม่ใช่ APPROVED
    ${loan_state}=    Set Variable    ${loans}[0][accountState]
    Should Be Equal As Strings    ${loan_state}    PENDING_APPROVAL
    ...    Expected loan to stay PENDING_APPROVAL when document upload failed but got '${loan_state}'

Run Normal A02 P-Loan Old Customer Booking Failed From Client Document Replace Rejected By Mambu
    [Documentation]    ตรวจเส้น "ลูกค้าเก่า" ที่ beforeSending เรียก
    ...                retreiveAndReplaceClientDocuments แทน retrieveAndUploadDocuments
    ...
    ...                ขั้นตอน:
    ...                1. รัน flow ลูกค้าใหม่ให้ book สำเร็จก่อน เพื่อสร้าง client
    ...                   พร้อมเอกสาร _documents.1 (ID_DOCUMENT) และ _documents.2 (CLIENT)
    ...                   ใน Mambu แล้ว disburse/repay ผ่าน Mambu Workflow เพื่อให้
    ...                   _customerInfo.foundSuccessLoan = FOUND ตามที่ scenario ลูกค้าเก่าคาดหวัง
    ...                2. สมัครใหม่ด้วยเลขบัตรประชาชนเดิม -> beforeSending เข้าสาขาที่เจอ
    ...                   client อยู่แล้ว -> เรียก retreiveAndReplaceClientDocuments
    ...                3. poison _documents.2.name เป็น evil.exe ให้ Mambu ปฏิเสธตอน upload
    ...
    ...                ต่างจากเทสเส้น loan account 2 จุด:
    ...                - ความพังเกิดใน beforeSending ซึ่งอยู่ก่อน POST /loans
    ...                  ดังนั้น loan ต้องไม่ถูกสร้างเลย (ไม่ใช่ 1 ใบแบบเทสแรก)
    ...                - retreiveAndReplaceClientDocuments ลบเอกสารเดิมทิ้งก่อน upload
    ...                  ตัวใหม่ ถ้า upload พังแล้วไม่มีการกู้คืน เอกสารของลูกค้าจะหายไป
    ...
    ...                เทสนี้จะแดงจนกว่า dev จะแก้ retreiveAndReplaceClientDocuments
    ...                ให้ propagate error เหมือนที่ทำกับ retrieveAndUploadDocuments แล้ว
    ...                (op-872 แก้เฉพาะตัวหลัง ตัวนี้ยังเป็น fire-and-forget อยู่)
    [Tags]    booking    upload-failure    old-customer

    Log    Step A: รัน flow ลูกค้าใหม่ให้ book สำเร็จก่อน
    ${scenario_new}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_SCENARIO}
    ${customer_info_national_id_answer}=    Normal Workflow    ${scenario_new}
    Mambu Workflow    ${customer_info_national_id_answer}    ${scenario_new['repayment_amount']}    10
    Log    Step A: ลูกค้าใหม่ book สำเร็จแล้ว

    Log    Step B: เก็บสถานะเอกสารของ client ไว้เทียบทีหลัง
    ${id_number}=    Get National ID From Answers    ${customer_info_national_id_answer}
    ${clients}=      Get Client By Id Number    ${id_number}
    ${client_count}=    Get Length    ${clients}
    Should Be Equal As Integers    ${client_count}    1
    ...    Expected exactly 1 Mambu client for national id ${id_number} but found ${client_count}
    ${client_key}=    Set Variable    ${clients}[0][encodedKey]
    ${docs_before}=   Get Client Documents Metadata    ${client_key}
    ${docs_before_count}=    Get Length    ${docs_before}
    Log    client ${client_key} มีเอกสาร ${docs_before_count} รายการก่อนสมัครรอบสอง
    FOR    ${doc}    IN    @{docs_before}
        Log    id=${doc['id']} ownerType=${doc['ownerType']} name=${doc['name']} notes=${doc['notes']}
    END
    Should Be True    ${docs_before_count} > 0
    ...    Expected client documents to exist after a successful booking, otherwise this test cannot prove anything about the replace path

    Log    Step C: สมัครใหม่ด้วยเลขบัตรเดิม พร้อม poison _documents.2.name
    ${scenario_old}=    Set Variable    ${NORMAL_P_LOAN_OLD_CUSTOMER_TERM_CLIENT_DOC_FAILURE_SCENARIO}
    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=
    ...    Normal Workflow Expecting Book Error    ${scenario_old}    ${customer_info_national_id_answer}

    Log    Step D: ต้องไม่มี loan ใหม่ เพราะพังใน beforeSending ก่อนถึง POST /loans
    ${loans}=    Search Loans By Case Id    ${case_id}
    ${loan_count}=    Get Length    ${loans}
    FOR    ${loan}    IN    @{loans}
        Log    loan id=${loan['id']} encodedKey=${loan['encodedKey']} state=${loan['accountState']}
    END
    Should Be Equal As Integers    ${loan_count}    ${scenario_old['booking_expected']['expected_loan_count']}
    ...    Expected no loan for case ${case_id} (client document replace fails inside beforeSending, before POST /loans) but found ${loan_count}

    Log    Step E: เอกสารเดิมของ client ต้องไม่หายไปจากการ replace ที่ล้มเหลว
    # retreiveAndReplaceClientDocuments ยิง deleteDocument ของเอกสารเดิมที่ label ตรงกัน
    # ก่อนจะ upload ตัวใหม่ ถ้า upload พังแล้วไม่มีการกู้คืน ลูกค้าจะเสียเอกสารไปฟรี ๆ
    # assertion นี้แยกประเด็นจาก booking status - ถ้าแดงตรงนี้แปลว่า propagate error
    # ได้แล้วแต่ยังมี data loss อยู่
    ${docs_after}=    Get Client Documents Metadata    ${client_key}
    ${docs_after_count}=    Get Length    ${docs_after}
    FOR    ${doc}    IN    @{docs_after}
        Log    id=${doc['id']} ownerType=${doc['ownerType']} name=${doc['name']} notes=${doc['notes']}
    END
    Should Be True    ${docs_after_count} >= ${docs_before_count}
    ...    Client documents dropped from ${docs_before_count} to ${docs_after_count} — the failed replace deleted the existing document without putting anything back
