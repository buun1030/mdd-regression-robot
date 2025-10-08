***Settings***
Resource    ../resources/thinker_keywords.robot
Resource    ../resources/retry_keywords.robot
Variables    ../scenarios.py
Variables    ../vars.yaml
Suite Setup    Create Thinker Session

***Test Cases***
Run GSB Lead P-Loan Base Scenario
    GSB Lead Workflow    ${GSB_LEAD_P_LOAN_BASE_SCENARIO}

Run GSB Lead Nano-Loan Base Scenario
    GSB Lead Workflow    ${GSB_LEAD_NANO_LOAN_BASE_SCENARIO}

***Keywords***
GSB Lead Workflow
    [Arguments]    ${scenario}
    Log    --- Starting Test: ${scenario['test_id']} ---

    Log    Step 1: Logging in...
    ${session_id}=    Login    email=${email}    password=${password}
    Should Not Be Empty    ${session_id}
    Log    Step 1: Login successful.

    Log    Step 2: Applying for Product...
    ${case_id}=    Apply For Product    ${session_id}    ${scenario['product_name']}
    Should Not Be Empty    ${case_id}
    Log    Step 2: Product applied. Case ID: ${case_id}

    Log    Step 3: Answering Initial Questions...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['initial_questions']}
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['campaign_select_questions']}
    Log    Step 3: Initial Questions answered.

    Log    Step 4: Submitting Case...
    Submit Case    ${session_id}    ${case_id}
    Log    Step 4: Case submitted.

    Log    Step 5: Verifying Case Details (Customer Decision Unknown, Loan Status PRE-APPROVED, etc.)...
    Sleep    5s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Customer Decision Unknown    ${session_id}    ${case_id}
    ${loan_status_pre_approved_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == 'PRE-APPROVED'
            ${loan_status_pre_approved_found}=    Set Variable    ${True}
            BREAK
        END
    END
    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    Should Be True     ${loan_status_pre_approved_found}    Expected 'thinker.loanStatus' with 'PRE-APPROVED' value not found
    Should Be True     ${verifying_field_list_length} > 0    verifying_field_list should not be empty
    Log    Step 5: Case Details verified ((Customer Decision Unknown, Loan Status PRE-APPROVED, etc.)...)

    Log    Step 6: Answering Secondary Questions...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['secondary_questions']}
    Log    Step 6: Secondary Questions answered.

    Log    Step 7: Verifying Case Details (Loan Status APPROVED, etc.)...
    Sleep    10s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Approved Status for GSB Lead    ${session_id}    ${case_id}
    Log    Step 7: Loan Status is APPROVED verified.

    Log    Step 8: Customer Decision...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['customer_decision']}
    Log    Step 8: Customer Decision answered.

    Log    Step 9: Completed Status...
    Sleep    10s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Completed Status for GSB Lead    ${session_id}    ${case_id}    ${scenario}
    Log    Step 9: Completed Status verified.

    Log    Step 10: Booking Detail...
    Sleep    5s
    ${booking_detail}=    Get Booking Detail    ${session_id}    ${case_id}
    Should Not Be Empty    ${booking_detail}
    Should Be Equal As Strings    ${booking_detail['latest_status']}    COMPLETED
    Log    Step 10: Booking Detail retrieved.
