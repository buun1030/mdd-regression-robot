***Settings***
Resource    ../resources/normal_keywords.robot
Resource    ../resources/global_setup.robot
Library     ../resources/evidence_library.py
Suite Setup    Global Suite Setup

***Variables***
# opj-1559 (กันเอกสารซ้ำตอน retry) ถูกถอดออกจาก tag dev v1.0.32
# รันโดยไม่เช็คซ้ำ: robot -v CHECK_UPLOAD_DEDUPE:False ...
${CHECK_UPLOAD_DEDUPE}    ${True}
# Step 20-21: แก้เอกสาร slot ที่พัง + manual rebook (send-case-to-external) แล้วเทียบ file list ก่อน/หลัง
# ปิด: robot -v CHECK_MANUAL_RETRY:False ...
${CHECK_MANUAL_RETRY}    ${True}

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
    ...                เทสนี้ครอบ 6 พฤติกรรม:
    ...                1. (op-872) connector propagate upload error กลับมาแทนที่จะกลืน
    ...                   (ก่อนแก้ได้ latest_status = COMPLETED)
    ...                2. (op-872) idempotency guard - onResult ยิง loans:search ด้วย
    ...                   _thinker.caseId ก่อนสร้าง loan ถ้าเจอแล้วให้ reuse
    ...                   (ก่อนแก้ retry 5 ครั้งได้ loan 5 ใบ + เผาเลขสัญญา 5 เลข)
    ...                3. (opf-1566) ลำดับใหม่ create client -> create loan -> approve
    ...                   -> upload ดังนั้น upload พังแล้ว loan ต้องเป็น APPROVED
    ...                   (ก่อนแก้ upload อยู่ก่อน approve -> ค้าง PENDING_APPROVAL)
    ...                4. เอกสารต้องครบทุก slot (ยกเว้น evil.exe) ไม่หาย
    ...                5. (opj-1559) retry แล้วต้องไม่ upload เอกสารเดิมซ้ำ
    ...                   connector เช็คเอกสารเดิมของ loan ก่อน upload (key = notes)
    ...                   (ก่อนแก้ retry 5 ครั้งได้เอกสารซ้ำ ~5 ชุด)
    ...                   ปิดได้ด้วย -v CHECK_UPLOAD_DEDUPE:False
    ...                6. แก้ชื่อไฟล์ slot ที่พังให้ถูก แล้ว manual rebook (send-case-to-external)
    ...                   -> booking COMPLETED, loan ยัง 1 ใบ, เอกสารเพิ่มมา 1 ใบ (slot ที่แก้)
    ...                   เอกสารเดิมไม่ถูก upload ซ้ำ — file list ก่อน/หลังเก็บที่
    ...                   ${OUTPUT DIR}/loan_documents/ ปิดได้ด้วย -v CHECK_MANUAL_RETRY:False
    [Tags]    booking    upload-failure

    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=
    ...    Normal Workflow Expecting Book Error    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO}

    Log    Step 14: เก็บหลักฐานรอบแรกจากระบบ (file list #1 + evidence) ก่อน assert ใดๆ
    # เก็บก่อนเสมอ เพื่อให้มีไฟล์เทียบแม้เทสแดงตั้งแต่ Step 13 หรือ step ถัดไป
    ${loans}=    Search Loans By Case Id    ${case_id}
    ${loan_count}=    Get Length    ${loans}
    FOR    ${loan}    IN    @{loans}
        Log    loan id=${loan['id']} encodedKey=${loan['encodedKey']} state=${loan['accountState']}
    END
    ${booking_detail}=    Get Booking Detail    ${session_id}    ${case_id}
    ${case_detail_1}=    Get Case Detail    ${session_id}    ${case_id}
    @{loan_documents}=    Create List
    IF    ${loan_count} > 0
        ${loan_documents}=    Get Loan Account Documents Metadata    ${loans}[0][encodedKey]
    END
    ${snapshot_1}=    Save Loan Documents Snapshot    ${loan_documents}    ${case_id}    1_after_auto_booking
    # ค่าจาก get-case-detail ณ ตอนนี้ (= customer_data ใน DB) — DB เก็บแค่ค่าล่าสุด ค่าก่อนแก้จึงต้องเก็บตอนนี้
    @{evidence_fields}=    Create List    ${POISONED_DOCUMENT_FIELD_NAME}    thinker.loanResult    thinker.loanStatus
    ${evidence_1}=    Capture Booking Evidence    ${case_id}    1_after_auto_booking    ${case_detail_1}    ${booking_detail}    ${loan_documents}    ${evidence_fields}
    Should Contain    ${evidence_1['fields']['${POISONED_DOCUMENT_FIELD_NAME}']['value']}    evil.exe

    Log    Step 15: ยืนยันว่า loan ถูกสร้างใน Mambu ใบเดียว (ไม่ซ้ำจากการ retry)
    # taskpool ยิง POST /results ซ้ำ 5 ครั้ง (Booking.MaxRetries = 5)
    # แต่ onResult มี idempotency guard ที่ยิง loans:search ด้วย _thinker.caseId
    # ก่อนสร้าง loan ถ้าเจอแล้วจะ reuse encodedKey เดิมโดยไม่ขอเลขสัญญาใหม่
    # ดังนั้นถึงจะ retry 5 รอบก็ต้องได้ loan ใบเดียว
    Should Be Equal As Integers    ${loan_count}    1
    ...    Expected exactly 1 loan for case ${case_id} (idempotency guard should make booking retry reuse the existing loan) but found ${loan_count}

    Log    Step 16: ยืนยันว่า booking พังเพราะ evil.exe จริง
    ${expected_error}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO['booking_expected']['expected_error_substring']}
    Run Keyword And Continue On Failure    Should Contain    ${booking_detail['latest_result']}    ${expected_error}
    ...    Expected booking to fail at document upload (${expected_error}) but latest_result was: ${booking_detail['latest_result']}

    Log    Step 17: ยืนยันว่า loan ถูก approve ก่อน upload (opf-1566)
    # ลำดับใหม่: create client -> create loan -> approve -> upload
    # upload พังหลัง approve ไปแล้ว -> loan ต้องเป็น APPROVED ไม่ค้าง PENDING_APPROVAL
    ${expected_loan_state}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO['booking_expected']['expected_loan_state']}
    ${loan_state}=    Set Variable    ${loans}[0][accountState]
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${loan_state}    ${expected_loan_state}
    ...    Expected loan to be ${expected_loan_state} even though document upload failed (approve runs before upload) but got '${loan_state}'

    Log    Step 18: ยืนยันว่าเอกสารไม่หาย (ครบทุก slot ยกเว้น slot ที่ poison)
    # นับเฉพาะเอกสารที่ไม่ซ้ำ (notes) จึงใช้ได้ทั้งตอนที่ connector กันไฟล์ซ้ำแล้วและยังไม่กัน
    ${loan_document_count}=    Get Length    ${loan_documents}
    FOR    ${doc}    IN    @{loan_documents}
        Log    doc id=${doc['id']} fileName=${doc['fileName']} notes=${doc['notes']} created=${doc['creationDate']}
    END
    ${unique_document_count}=    Count Unique Document Notes    ${loan_documents}
    ${expected_document_count}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO['booking_expected']['expected_loan_document_count']}
    Log    loan documents: total=${loan_document_count} unique=${unique_document_count} expected=${expected_document_count}
    # Step 16-19 ใช้ Continue On Failure: ถ้าแดง เทสยัง FAIL แต่รันต่อ (หลักฐานรอบแรกเก็บไปแล้วใน Step 14)
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${unique_document_count}    ${expected_document_count}
    ...    Expected ${expected_document_count} distinct loan documents (all slots except the poisoned one) but found ${unique_document_count} — documents were skipped/lost
    ${evil_uploaded}=    Evaluate    any(d.get('fileName') == 'evil.exe' for d in $loan_documents)
    Run Keyword And Continue On Failure    Should Not Be True    ${evil_uploaded}    evil.exe should have been rejected by Mambu, not stored on the loan

    Log    Step 19: ยืนยันว่า retry ไม่ upload เอกสารซ้ำ (opj-1559)
    # taskpool retry ครบ 5 รอบ (retry_count = 5 เช็คไปแล้วใน Step 13)
    # ถ้า connector กันไฟล์ซ้ำ แต่ละ slot ต้องมีแค่ 1 ใบ (total == unique)
    IF    ${CHECK_UPLOAD_DEDUPE}
        Run Keyword And Continue On Failure    Documents Should Not Be Duplicated    ${loan_documents}
    ELSE
        Log    Step 19 skipped (CHECK_UPLOAD_DEDUPE=False): total=${loan_document_count} unique=${unique_document_count}    WARN
    END

    # Step 20-21 ต้องเริ่มจาก booking ที่ FAILED (case book_error ยังแก้คำตอบได้)
    # ถ้ารอบแรก COMPLETED ไปแล้ว case จะเป็น completed ซึ่งแก้คำตอบไม่ได้ -> ไม่มีอะไรให้ rebook
    IF    ${CHECK_MANUAL_RETRY} and '${booking_detail['latest_status']}' != 'FAILED'
        Fail    Skip Step 20-21: first booking is ${booking_detail['latest_status']} (expected FAILED), so there is nothing to fix and rebook — see evidence/${case_id}_1_after_auto_booking.json
    END
    IF    ${CHECK_MANUAL_RETRY}
        Log    Step 20: แก้เอกสาร slot ที่พังให้ถูกต้อง แล้ว manual rebook (case_id เดิม)
        # case ที่เป็น book_error ยังแก้คำตอบได้ (checkEditableCase บล็อกเฉพาะ completed)
        # เปลี่ยนชื่อไฟล์ evil.exe เป็นชื่อที่ Mambu รับ (content เดิมเป็น png ที่ใช้ได้อยู่แล้ว)
        # -> รอบนี้ต้อง upload เพิ่มแค่ slot นี้ 1 ใบ ส่วนเอกสารเดิมต้องถูกข้าม (มี notes อยู่แล้ว)
        ${fixed_slot}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_UPLOAD_FAILURE_SCENARIO['booking_expected']['fixed_document']}
        &{fixed_answer}=    Create Dictionary    field_name=${fixed_slot['field_name']}    field_value=${fixed_slot['field_value']}
        @{fixed_answers}=    Create List    ${fixed_answer}
        Answer Questions    ${session_id}    ${case_id}    ${fixed_answers}
        Sleep    5s
        ${booking_before}=    Get Booking Detail    ${session_id}    ${case_id}
        Send Case To External    ${session_id}    ${case_id}
        ${booking_after}=    Get Booking Detail    ${session_id}    ${case_id}
        Should Be True    ${booking_after['retry_count']} > ${booking_before['retry_count']}
        ...    Expected manual rebook to run (retry_count ${booking_before['retry_count']} -> ${booking_after['retry_count']})
        Should Be Equal As Strings    ${booking_after['latest_status']}    COMPLETED
        ...    Expected booking to complete after fixing ${fixed_slot['field_name']} but got ${booking_after['latest_status']}: ${booking_after['latest_result']}

        Log    Step 21: เก็บ file list #2 แล้วเทียบกับ #1 (ต้องเพิ่มมา 1 ใบ คือ slot ที่แก้)
        ${loans_after}=    Search Loans By Case Id    ${case_id}
        ${loan_count_after}=    Get Length    ${loans_after}
        Should Be Equal As Integers    ${loan_count_after}    1
        ...    Expected manual rebook to reuse the existing loan but found ${loan_count_after} loans
        ${loan_documents_2}=    Get Loan Account Documents Metadata    ${loans}[0][encodedKey]
        ${snapshot_2}=    Save Loan Documents Snapshot    ${loan_documents_2}    ${case_id}    2_after_manual_rebook
        ${new_documents}=    Evaluate    [d for d in $loan_documents_2 if d['id'] not in {x['id'] for x in $loan_documents}]
        ${new_summary}=    Evaluate    [f"id={d['id']} {d.get('fileName')} | {d.get('notes')}" for d in $new_documents]
        # เก็บหลักฐานก่อน assert เพื่อให้มีไฟล์แม้เทสแดง
        ${case_detail_2}=    Get Case Detail    ${session_id}    ${case_id}
        ${evidence_2}=    Capture Booking Evidence    ${case_id}    2_after_manual_rebook    ${case_detail_2}    ${booking_after}    ${loan_documents_2}    ${evidence_fields}
        Write Booking Evidence Summary    ${case_id}    ${evidence_1}    ${evidence_2}    ${new_documents}
        Should Be Equal As Strings    ${evidence_2['fields']['${POISONED_DOCUMENT_FIELD_NAME}']['value']}    ${fixed_slot['field_value']}
        ...    Expected the system to store the fixed document name but customer_data has ${evidence_2['fields']['${POISONED_DOCUMENT_FIELD_NAME}']}
        Log    file list #1=${loan_document_count} documents, #2=${{len($loan_documents_2)}} documents, new=${new_summary}
        # เพิ่มมา 1 ใบพอดี = upload เกิดขึ้นจริงในรอบนี้ และเอกสารเดิมไม่ถูก upload ซ้ำ
        ${new_count}=    Get Length    ${new_documents}
        Should Be Equal As Integers    ${new_count}    1
        ...    Expected exactly 1 new document (the fixed slot) after manual rebook but got ${new_count}: ${new_summary}
        Should Be Equal As Strings    ${new_documents}[0][fileName]    ${fixed_slot['expected_file_name']}
        ...    Expected the new document to be ${fixed_slot['expected_file_name']} but got ${new_documents}[0][fileName]
        ${notes_1}=    Evaluate    {d.get('notes') for d in $loan_documents}
        Should Not Contain    ${notes_1}    ${new_documents}[0][notes]
        ...    New document reuses notes of an existing document (= duplicate of an existing slot): ${new_documents}[0][notes]
        # ไม่เช็คซ้ำทั้ง list #2 เพราะซ้ำที่เกิดจาก auto retry (Step 19) จะติดมาด้วย
        # สิ่งที่ manual rebook ต้องพิสูจน์คือ "ไม่มีใบเดิมถูก upload เพิ่ม" = เช็คด้วยใบใหม่ด้านบนแล้ว
    END

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
