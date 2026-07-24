***Settings***
Resource    ../resources/normal_keywords.robot
Resource    ../resources/global_setup.robot
Suite Setup    Global Suite Setup

***Test Cases***
Run Normal A02 P-Loan Base Scenario
    ${customer_info_national_id_answer}=    Normal Workflow    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_SCENARIO}
    Mambu Workflow    ${customer_info_national_id_answer}    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_SCENARIO['repayment_amount']}    10
    Normal Workflow    ${NORMAL_P_LOAN_OLD_CUSTOMER_TERM_SCENARIO}    ${customer_info_national_id_answer}

Run Normal A02 Nano-Loan Base Scenario
    ${customer_info_national_id_answer}=    Normal Workflow    ${NORMAL_NANO_LOAN_NEW_CUSTOMER_TERM_SCENARIO}
    Mambu Workflow    ${customer_info_national_id_answer}    ${NORMAL_NANO_LOAN_NEW_CUSTOMER_TERM_SCENARIO['repayment_amount']}
    Normal Workflow    ${NORMAL_NANO_LOAN_OLD_CUSTOMER_TERM_SCENARIO}    ${customer_info_national_id_answer}

Run Normal A02 P-Loan Did Not Satisfy Tcg Criteria Negative Scenario
    ${scenario}=    Set Variable    ${NORMAL_P_LOAN_NEW_CUSTOMER_REVOLVING_SCENARIO}
    ${customer_info_national_id_answer}=    Normal Workflow    ${scenario}
    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=    Initial Normal Workflow    ${NORMAL_NANO_LOAN_OLD_CUSTOMER_TERM_WITH_EXISTING_REVOLVING_SCENARIO}    ${customer_info_national_id_answer}
    Log    Step A: Answer Did Not Satisfy Tcg Criteria
    # ไว้กันปัญหาการตอบใน Initial Normal Workflow ยัง update ข้อมูลไม่เสร็จ ทำให้ข้อมูลใน traversal path ไม่อัพเดตตามที่ควรจะเป็น
    # Sleep    10s
    ${tcg_action}=    Build Tcg Action Answer    DID_NOT_SATISFY_TCG_CRITERIA
    Answer Questions    ${session_id}    ${case_id}    ${tcg_action}
   # ไว้แก้ปัญหาข้อมูลใน traversal path ไม่ยอม update
#    &{any_inputs}=    Create Dictionary    
#     ...    _credit.submitCaseRemark=[\"success\"]    
#     ...    _credit.isSubmitCaseSuccess=true    
#     ${any_answers}=    Build Answer        ${any_inputs}
#     Answer Questions    ${session_id}    ${case_id}    ${any_answers}
    Log    Step A: Did Not Satisfy Tcg Criteria answered.

    Log    Step B: Verify Loan Result & Status are reject
    Sleep    6s
    ${timeout}=    Set Variable    15s
    ${retry_interval}=    Set Variable    4s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Rejected Status    ${session_id}    ${case_id}

    Verify Customer Data Field    ${case_detail}    thinker.loanResult    R07   
    Log    Step B: Loan Result & Status verified.

Run P-Loan R05 NCB Source NOT_TRUST and Invalid NCB Grade
    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=    Initial Normal Workflow    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_SCENARIO}
    Log    Step A: Answer NCB Source NOT_TRUST and Invalid NCB Grade
    ${answers}=    Build Ncb Not Trust And Invalid Grade Answer
    Answer Questions    ${session_id}    ${case_id}    ${answers}
    Log    Step A: NCB Source NOT_TRUST and Invalid NCB Grade answered.

    Log    Step B: Verify Loan Result & Status are reject
    Sleep    6s
    ${timeout}=    Set Variable    15s
    ${retry_interval}=    Set Variable    4s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Rejected Status    ${session_id}    ${case_id}

    Verify Customer Data Field    ${case_detail}    thinker.loanResult    R05
    Log    Step B: Loan Result & Status verified.

Run Nano-Loan R05 NCB Source NOT_TRUST and Invalid NCB Grade
    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=    Initial Normal Workflow    ${NORMAL_NANO_LOAN_NEW_CUSTOMER_TERM_SCENARIO}
    Log    Step A: Answer NCB Source NOT_TRUST and Invalid NCB Grade
    # ไว้กันปัญหาการตอบใน Initial Normal Workflow ยัง update ข้อมูลไม่เสร็จ ทำให้ข้อมูลใน traversal path ไม่อัพเดตตามที่ควรจะเป็น
    # Sleep    10s
    ${answers}=    Build Ncb Not Trust And Invalid Grade Answer
    Answer Questions    ${session_id}    ${case_id}    ${answers}
    # ไว้แก้ปัญหาข้อมูลใน traversal path ไม่ยอม update
    # &{any_inputs}=    Create Dictionary    
    # ...    _credit.submitCaseRemark=[\"success\"]    
    # ...    _credit.isSubmitCaseSuccess=true    
    # ${any_answers}=    Build Answer        ${any_inputs}
    # Answer Questions    ${session_id}    ${case_id}    ${any_answers}
    Log    Step A: NCB Source NOT_TRUST and Invalid NCB Grade answered.

    Log    Step B: Verify Loan Result & Status are reject
    Sleep    6s
    ${timeout}=    Set Variable    15s
    ${retry_interval}=    Set Variable    4s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Rejected Status    ${session_id}    ${case_id}

    Verify Customer Data Field    ${case_detail}    thinker.loanResult    R05
    Log    Step B: Loan Result & Status verified.