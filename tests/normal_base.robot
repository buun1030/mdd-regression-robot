***Settings***
Resource    ../resources/thinker_keywords.robot
Resource    ../resources/retry_keywords.robot
Resource    ../resources/global_setup.robot
Library     ../resources/customer_info_generators.py
Library     ../resources/tcg.py
Variables    ../scenarios.py
Variables    ../vars.yaml
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
    ${tcg_action}=    Build Tcg Action Answer    DID_NOT_SATISFY_TCG_CRITERIA
    Answer Questions    ${session_id}    ${case_id}    ${tcg_action}
    Log    Step A: Did Not Satisfy Tcg Criteria answered.

    Log    Step B: Verify Loan Result & Status are reject
    Sleep    6s
    ${timeout}=    Set Variable    15s
    ${retry_interval}=    Set Variable    4s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Rejected Status    ${session_id}    ${case_id}

    ${loan_result_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanResult' and '${item['value']}' == 'R07'
            ${loan_result_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True    ${loan_result_found}    Expected 'thinker.loanResult' with 'R07' value not found
    Log    Step B: Loan Result & Status verified.

***Keywords***
Normal Workflow
    [Arguments]    ${scenario}    ${customer_info_national_id_answer}=${None}
    ${session_id}    ${case_id}    ${customer_info_national_id_answer}=    Initial Normal Workflow    ${scenario}    ${customer_info_national_id_answer}

    Log    Step 7: CA Role...
    Log    7.1: Claiming CA case...
    ${claimed_tasks_data}=    Claim Case    ${session_id}    ${case_id}
    ${claimed_tasks_data_length}=    Get Length    ${claimed_tasks_data}
    Should Be True    ${claimed_tasks_data_length} > 0    claimed_tasks_data should not be empty
    Log    7.1: CA case claimed.

    ${expected_task_substrings}=    Set Variable    ${scenario['expected']['task_name_substrings']['ca']}
    FOR    ${expected_substring}    IN    @{expected_task_substrings}
        ${found_task}=    Set Variable    ${False}
        FOR    ${task}    IN    @{claimed_tasks_data}
            IF    '${expected_substring}' in '${task['task_method_name']}'
                ${found_task}=    Set Variable    ${True}
                BREAK
            END
        END
        Should Be True    ${found_task}    Expected task substring '${expected_substring}' not found
    END
    Log    7.1: CA tasks verified.

    Log    7.2: Verifying available escalation roles for CA...
    ${task_details}=    Get Task Details    ${session_id}    ${case_id}
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verifying_fields' in $detail_data and 'summary' in $detail_data['verification_method_name']
            FOR    ${field_i}    IN    @{detail_data['verifying_fields']}
                ${field}=    Set Variable    ${field_i['field']}
                IF    '${field['field_name']}' == 'thinker.roleAssignment'
                    ${choices}=    Set Variable    ${field['choices']}
                    ${expected_must_have_roles}=    Set Variable    ${scenario['expected']['available_escalation_roles']['ca']}
                    FOR    ${role}    IN    @{expected_must_have_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Be True    ${role_found}    Expected role '${role}' not found
                    END
                    ${expected_must_not_have_roles}=    Set Variable    ${scenario['expected']['unavailable_escalation_roles']['ca']}
                    FOR    ${role}    IN    @{expected_must_not_have_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Not Be True    ${role_found}    Unexpected role '${role}' found
                    END
                END
            END
        END
    END
    Log    7.2: Escalation roles for CA verified.

    Log    7.3: Escalating CA Role to SCA...
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verification_method_name' in $detail_data and 'summary' in $detail_data['verification_method_name']
            @{required_fields}=    Create List
            IF    'required_fields' in $detail_data
                FOR    ${field_i}    IN    @{detail_data['required_fields']}
                    ${field}=    Set Variable    ${field_i['field']}
                    &{field_data}=    Create Dictionary    field_name=${field['field_name']}    field_value=${field['current_value']}
                    Append To List    ${required_fields}    ${field_data}
                END
            END
            &{editing_field_dict}=    Create Dictionary    field_name=thinker.roleAssignment    field_value=${scenario['escalations']['ca_to_sca']}
            @{editing_fields_list}=    Create List    ${editing_field_dict}
            &{payload}=    Create Dictionary    task_id=${task_id}    required_fields=${required_fields}    editing_fields=${editing_fields_list}
            Edit Task Data    ${session_id}    ${payload}
        END
    END
    Log    7.3: CA Role escalated to SCA.
    Log    Step 7: CA Role completed.

    Log    Step 8: SCA Role...
    Log    8.1: Claiming SCA case...
    ${claimed_tasks_data}=    Claim Case    ${session_id}    ${case_id}
    ${claimed_tasks_data_length}=    Get Length    ${claimed_tasks_data}
    Should Be True    ${claimed_tasks_data_length} > 0    claimed_tasks_data should not be empty
    Log    8.1: SCA case claimed.

    ${expected_task_substrings}=    Set Variable    ${scenario['expected']['task_name_substrings']['sca']}
    FOR    ${expected_substring}    IN    @{expected_task_substrings}
        ${found_task}=    Set Variable    ${False}
        FOR    ${task}    IN    @{claimed_tasks_data}
            IF    '${expected_substring}' in '${task['task_method_name']}'
                ${found_task}=    Set Variable    ${True}
                BREAK
            END
        END
        Should Be True    ${found_task}    Expected task substring '${expected_substring}' not found
    END
    Log    8.1: SCA tasks verified.

    Log    8.2: Verifying available escalation roles for SCA...
    ${task_details}=    Get Task Details    ${session_id}    ${case_id}
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verifying_fields' in $detail_data and 'summary' in $detail_data['verification_method_name']
            FOR    ${field_i}    IN    @{detail_data['verifying_fields']}
                ${field}=    Set Variable    ${field_i['field']}
                IF    '${field['field_name']}' == 'thinker.roleAssignment'
                    ${choices}=    Set Variable    ${field['choices']}
                    ${expected_roles}=    Set Variable    ${scenario['expected']['available_escalation_roles']['sca']}
                    FOR    ${role}    IN    @{expected_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Be True    ${role_found}    Expected role '${role}' not found
                    END
                    ${expected_must_not_have_roles}=    Set Variable    ${scenario['expected']['unavailable_escalation_roles']['sca']}
                    FOR    ${role}    IN    @{expected_must_not_have_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Not Be True    ${role_found}    Unexpected role '${role}' found
                    END
                END
            END
        END
    END
    Log    8.2: Available escalation roles verified.

    Log    8.3: Verifying SCA tasks...
    Verify Tasks    ${session_id}    ${case_id}
    Sleep    10s
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${remaining_verifying_field_list}=    Set Variable    ${case_detail['remaining_verifying_field_list']}
    Should Be Empty    ${remaining_verifying_field_list}    remaining_verifying_field_list should be empty
    Log    8.3: SCA tasks verified.

    Log    8.4: Escalating SCA Role to MD...
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verification_method_name' in $detail_data and 'summary' in $detail_data['verification_method_name']
            @{required_fields}=    Create List
            IF    'required_fields' in $detail_data
                FOR    ${field_i}    IN    @{detail_data['required_fields']}
                    ${field}=    Set Variable    ${field_i['field']}
                    &{field_data}=    Create Dictionary    field_name=${field['field_name']}    field_value=${field['current_value']}
                    Append To List    ${required_fields}    ${field_data}
                END
            END
            &{editing_field_dict}=    Create Dictionary    field_name=thinker.roleAssignment    field_value=${scenario['escalations']['sca_to_md']}
            @{editing_fields_list}=    Create List    ${editing_field_dict}
            &{payload}=    Create Dictionary    task_id=${task_id}    required_fields=${required_fields}    editing_fields=${editing_fields_list}
            Edit Task Data    ${session_id}    ${payload}
        END
    END
    Log    8.4: SCA Role escalated to MD.
    Log    Step 8: SCA Role completed.

    Log    Step 9: MD Role...
    ${claimed_tasks_data}=    Claim Case    ${session_id}    ${case_id}
    ${claimed_tasks_data_length}=    Get Length    ${claimed_tasks_data}
    Should Be True    ${claimed_tasks_data_length} > 0    claimed_tasks_data should not be empty

    ${expected_task_substrings}=    Set Variable    ${scenario['expected']['task_name_substrings']['md']}
    FOR    ${expected_substring}    IN    @{expected_task_substrings}
        ${found_task}=    Set Variable    ${False}
        FOR    ${task}    IN    @{claimed_tasks_data}
            IF    '${expected_substring}' in '${task['task_method_name']}'
                ${found_task}=    Set Variable    ${True}
                BREAK
            END
        END
        Should Be True    ${found_task}    Expected task substring '${expected_substring}' not found
    END

    ${task_details}=    Get Task Details    ${session_id}    ${case_id}
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verifying_fields' in $detail_data and 'summary' in $detail_data['verification_method_name']
            FOR    ${field_i}    IN    @{detail_data['verifying_fields']}
                ${field}=    Set Variable    ${field_i['field']}
                IF    '${field['field_name']}' == 'thinker.roleAssignment'
                    ${choices}=    Set Variable    ${field['choices']}
                    ${expected_roles}=    Set Variable    ${scenario['expected']['available_escalation_roles']['md']}
                    FOR    ${role}    IN    @{expected_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Be True    ${role_found}    Expected role '${role}' not found
                    END
                    ${expected_must_not_have_roles}=    Set Variable    ${scenario['expected']['unavailable_escalation_roles']['md']}
                    FOR    ${role}    IN    @{expected_must_not_have_roles}
                        ${role_found}=    Set Variable    ${False}
                        FOR    ${choice}    IN    @{choices}
                            IF    '${choice['value']}' == '${role}'
                                ${role_found}=    Set Variable    ${True}
                                BREAK
                            END
                        END
                        Should Not Be True    ${role_found}    Unexpected role '${role}' found
                    END
                END
            END
        END
    END

    Release Case    ${session_id}    ${case_id}
    Claim Case    ${session_id}    ${case_id}
    ${task_details}=    Get Task Details    ${session_id}    ${case_id}
    FOR    ${task_id}    ${detail_data}    IN    &{task_details}
        IF    'verification_method_name' in $detail_data and 'summary' in $detail_data['verification_method_name']
            @{required_fields}=    Create List
            IF    'required_fields' in $detail_data
                FOR    ${field_i}    IN    @{detail_data['required_fields']}
                    ${field}=    Set Variable    ${field_i['field']}
                    &{field_data}=    Create Dictionary    field_name=${field['field_name']}    field_value=${field['current_value']}
                    Append To List    ${required_fields}    ${field_data}
                END
            END
            &{editing_field_dict}=    Create Dictionary    field_name=thinker.caDecision    field_value=${scenario['md_decision']}
            @{editing_fields_list}=    Create List    ${editing_field_dict}
            &{payload}=    Create Dictionary    task_id=${task_id}    required_fields=${required_fields}    editing_fields=${editing_fields_list}
            Edit Task Data    ${session_id}    ${payload}
        END
    END
    Log    Step 9: MD Role completed.

    Log    Step 10: Approved Status...
    Sleep    10s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Approved Status    ${session_id}    ${case_id}
    Log    Step 10: Approved Status verified.

    Log    Step 11: Customer Decision...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['customer_decision']}
    Log    Step 11: Customer Decision answered.

    Log    Step 12: Completed Status...
    Sleep    10s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Completed Status    ${session_id}    ${case_id}    ${scenario}
    Log    Step 12: Completed Status verified.

    Log    Step 13: Booking Detail...
    ${booking_detail}=    Get Booking Detail    ${session_id}    ${case_id}
    Should Not Be Empty    ${booking_detail}
    Should Be Equal As Strings    ${booking_detail['latest_status']}    COMPLETED
    Log    Step 13: Booking Detail retrieved.

    RETURN    ${customer_info_national_id_answer}

Initial Normal Workflow
    [Arguments]    ${scenario}    ${customer_info_national_id_answer}=${None}
    Log    --- Starting Normal Workflow Test: ${scenario['test_id']} ---

    ${is_new_customer}=    Set Variable    ${False}
    IF    ${customer_info_national_id_answer} == ${None}
        ${is_new_customer}=    Set Variable    ${True}
        ${customer_info_national_id_answer}=    Build Unique Customer Info Answer
    END

    ${session_id}=    Login    email=${email}    password=${password}
    Should Not Be Empty    ${session_id}

    ${case_id}=    Apply For Product    ${session_id}    ${scenario['product_name']}
    Should Not Be Empty    ${case_id}

    Answer Questions    ${session_id}    ${case_id}    ${customer_info_national_id_answer}
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['initial_questions']}

    Submit Case    ${session_id}    ${case_id}
    Complete Batch Process    ${session_id}    ${case_id}

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

    ${is_found_success_loan_corrected}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    $item['field_name'] == '_customerInfo.foundSuccessLoan' and $item['value'] == $scenario['expected']['found_success_loan']
            ${is_found_success_loan_corrected}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True    ${is_found_success_loan_corrected}    Expected '_customerInfo.foundSuccessLoan' with '${scenario['expected']['found_success_loan']}' value not found or not matched

    Run Keyword If    ${is_new_customer} == ${False}    Check Available Credit Limit    ${session_id}    ${case_id}    ${scenario['available_credit_limit_name']}    ${scenario['expected']['available_credit_limit']}

    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    Should Be True    ${verifying_field_list_length} > 0    verifying_field_list should not be empty

    ${all_tasks_length}=    Get Length    ${case_detail['all_tasks']}
    Should Be True    ${all_tasks_length} > 0    all_tasks should not be empty
    Log    Step 6: Case Details verified.

    RETURN    ${session_id}    ${case_id}    ${customer_info_national_id_answer}

Mambu Workflow
    [Arguments]    ${customer_info_national_id_answer}    ${repayment_amount}    ${fee_amount}=${None}
    Log    --- Starting Mambu Workflow Test ---

    Log    Step 1: Get Client By Id Number...
    ${id_number}=    Get National ID From Answers    ${customer_info_national_id_answer}
    ${client_response}=    Get Client By Id Number    ${id_number}
    ${account_holder_id}=    Set Variable    ${client_response[0]['id']}
    Should Not Be Empty    ${account_holder_id}
    Log    Step 1: Client retrieved by ID number.

    Log    Step 2: Search Loans By Account Holder Id...
    ${loans_response}=    Search Loans By Account Holder Id    ${account_holder_id}
    ${loan_id}=    Set Variable    ${loans_response[0]['id']}
    Should Not Be Empty    ${loan_id}
    Log    Step 2: Loans retrieved by Account Holder Id.

    Log    Step 3: Disburse Loan...
    ${disburse_response}=    Disburse Loan    ${loan_id}    Disbursed via API    ${fee_amount}
    Log    Step 3: Loan disbursed.

    Log    Step 4: Make Loan Repayment...
    ${repayment_response}=    Make Loan Repayment    ${loan_id}    ${repayment_amount}    Repayment via API
    Log    Step 4: Loan repayment made.