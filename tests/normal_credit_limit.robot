***Settings***
Resource    ../resources/thinker_keywords.robot
Resource    ../resources/retry_keywords.robot
Library     ../resources/customer_info_generators.py
Variables    ../scenarios.py
Variables    ../vars.yaml
Suite Setup    Create Thinker Session

***Test Cases***
Run Normal P-Loan Credit Limit Test Cases
    Normal Credit Limit Sensitivity    ${NORMAL_P_LOAN_CREDIT_LIMIT_TEST_CASES}

Run Normal Nano-Loan Credit Limit Test Cases
    Normal Credit Limit Sensitivity    ${NORMAL_NANO_LOAN_CREDIT_LIMIT_TEST_CASES}

***Keywords***
Normal Credit Limit Sensitivity
    [Arguments]    ${scenario}
    Log    --- Starting Test: ${scenario['test_id']} ---

    ${customer_info_national_id_answer}=    Build Unique Customer Info Answer

    Log    Step 1: Logging in...
    ${session_id}=    Login    email=${email}    password=${password}
    Should Not Be Empty    ${session_id}
    Log    Step 1: Login successful.

    Log    Step 2: Applying for Product...
    ${case_id}=    Apply For Product    ${session_id}    ${scenario['product_name']}
    Should Not Be Empty    ${case_id}
    Log    Step 2: Product applied. Case ID: ${case_id}

    Log    Step 3.1: Answering _customerInfo.nationalIdNumber...
    Answer Questions    ${session_id}    ${case_id}    ${customer_info_national_id_answer}

    Log    Step 3.2: Answering Initial Questions...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['initial_questions']}
    Log    Step 3.2: Initial Questions answered.

    Log    Step 4: Submitting Case...
    Submit Case    ${session_id}    ${case_id}
    Log    Step 4: Case submitted.

    Log    Step 5: Completing Batch Process...
    Complete Batch Process    ${session_id}    ${case_id}
    Log    Step 5: Batch Process completed.

    Log    Step 6: Verifying Case Details (CA Decision Unknown, Loan Status VERIFYING, etc.)...
    Sleep    12s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check CA Decision Unknown    ${session_id}    ${case_id}

    ${loan_status_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == 'VERIFYING'
            ${loan_status_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True    ${loan_status_found}    Expected 'thinker.loanStatus' with 'VERIFYING' value not found

    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    Should Be True    ${verifying_field_list_length} > 0    verifying_field_list should not be empty

    ${all_tasks_length}=    Get Length    ${case_detail['all_tasks']}
    Should Be True    ${all_tasks_length} > 0    all_tasks should not be empty
    Log    Step 6: Case Details verified.

    Log    Step 7: Revolving Credit Limit Test Cases...
    FOR    ${case}    IN    @{scenario['cases']}
        Answer Questions    ${session_id}    ${case_id}    ${case['answers']}
        Sleep    5s
        ${timeout}=    Set Variable    10s
        ${retry_interval}=    Set Variable    3s
        ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Revolving Credit Limit Updated    ${session_id}    ${case_id}    ${case['expected']['revolving_credit_limit']}
        Log    Verified for case with answers: ${case['answers']} and expected limit: ${case['expected']['revolving_credit_limit']}
    END
    Log    Step 7: Revolving Credit Limit Test Cases completed.