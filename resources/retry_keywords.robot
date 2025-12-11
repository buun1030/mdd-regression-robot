***Settings***
Resource    thinker_keywords.robot
Library     RequestsLibrary
Library     Collections
Library     OperatingSystem

***Keywords***
Check CA Decision Unknown
    [Arguments]    ${session_id}    ${case_id}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${ca_decision_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['traversal_path']}
        IF    '${item['field_name']}' == 'thinker.caDecision' and '${item['value']}' == '__UNKNOWN__'
            ${ca_decision_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True    ${ca_decision_found}    Expected 'thinker.caDecision' with '__UNKNOWN__' value not found
    RETURN   ${case_detail}

Check Approved Status
    [Arguments]    ${session_id}    ${case_id}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${loan_status_approved_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == 'APPROVED'
            ${loan_status_approved_found}=    Set Variable    ${True}
            BREAK
        END
    END
    ${remaining_verifying_field_list}=    Set Variable    ${case_detail['remaining_verifying_field_list']}
    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    ${all_tasks_length}=    Get Length    ${case_detail['all_tasks']}
    Should Be True     ${loan_status_approved_found}    Expected 'thinker.loanStatus' with 'APPROVED' value not found
    Should Be Empty    ${remaining_verifying_field_list}    Expected 'remaining_verifying_field_list' to be empty
    Should Be True     ${verifying_field_list_length} > 0    verifying_field_list should not be empty
    Should Be True     ${all_tasks_length} > 0    all_tasks should not be empty
    RETURN   ${case_detail}

Check Rejected Status
    [Arguments]    ${session_id}    ${case_id}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${loan_status_rejected_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == 'REJECTED'
            ${loan_status_rejected_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True     ${loan_status_rejected_found}    Expected 'thinker.loanStatus' with 'REJECTED' value not found
    RETURN   ${case_detail}

Check Completed Status
    [Arguments]    ${session_id}    ${case_id}    ${scenario}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${loan_status_completed_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == '${scenario['expected']['final_status']}'
            ${loan_status_completed_found}=    Set Variable    ${True}
            BREAK
        END
    END
    ${loan_result_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanResult' and '${item['value']}' == '${scenario['expected']['loan_result']}'
            ${loan_result_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True     ${loan_status_completed_found}    Expected 'thinker.loanStatus' with 'COMPLETED' value not found
    Should Be True     ${loan_result_found}    Expected 'thinker.loanResult' with 'APPROVED' value not found
    Should Be Equal    ${case_detail['status']}    completed    Expected 'case_status' with 'completed' value not found
    RETURN   ${case_detail}

Check Customer Decision Unknown
    [Arguments]    ${session_id}    ${case_id}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${customer_decision_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['traversal_path']}
        IF    '${item['field_name']}' == '_loan.customerDecision' and '${item['value']}' == '__UNKNOWN__'
            ${customer_decision_found}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True    ${customer_decision_found}    Expected '_loan.customerDecision' with '__UNKNOWN__' value not found
    RETURN   ${case_detail}

Check Approved Status for GSB Lead
    [Arguments]    ${session_id}    ${case_id}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${is_loan_status_approved}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == 'APPROVED'
            ${is_loan_status_approved}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True     ${is_loan_status_approved}    Expected 'thinker.loanStatus' with 'APPROVED' value not found
    RETURN   ${case_detail}

Check Completed Status for GSB Lead
    [Arguments]    ${session_id}    ${case_id}    ${scenario}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${is_loan_status_completed}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanStatus' and '${item['value']}' == '${scenario['expected']['final_status']}'
            ${is_loan_status_completed}=    Set Variable    ${True}
            BREAK
        END
    END
    ${loan_result_found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == 'thinker.loanResult' and '${item['value']}' == '${scenario['expected']['loan_result']}'
            ${loan_result_found}=    Set Variable    ${True}
            BREAK
        END
    END
    ${remaining_verifying_field_list}=    Set Variable    ${case_detail['remaining_verifying_field_list']}
    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    Should Be True     ${is_loan_status_completed}    Expected 'thinker.loanStatus' with 'COMPLETED' value not found
    Should Be True     ${loan_result_found}    Expected 'thinker.loanResult' with 'APPROVED' value not found
    Should Be Empty    ${remaining_verifying_field_list}    Expected 'remaining_verifying_field_list' to be empty
    Should Be True     ${verifying_field_list_length} > 0    verifying_field_list should not be empty
    Should Be Equal    ${case_detail['status']}    completed    Expected 'case_status' with 'completed' value not found
    RETURN   ${case_detail}

Check Revolving Credit Limit Updated
    [Arguments]    ${session_id}    ${case_id}    ${expected_limit}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${is_max_revolving_credit_limit_corrected}=    Set Variable    ${False}
    ${actual_max_value}=    Set Variable    ${None}
    ${actual_min_value}=    Set Variable    ${None}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == '_loan.revolvingMaximumLimit'
            ${actual_max_value}=    Set Variable    ${item['value']}
            IF    '${item['value']}' == '${expected_limit['maximum']}'
                ${is_max_revolving_credit_limit_corrected}=    Set Variable    ${True}
                BREAK
            ELSE
                Log    ERROR: Maximum revolving credit limit value '${item['value']}' does not match expected value '${expected_limit['maximum']}'
            END
        END
    END
    ${is_min_revolving_credit_limit_corrected}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == '_loan.revolvingMinimumLimit'
            ${actual_min_value}=    Set Variable    ${item['value']}
            IF    '${item['value']}' == '${expected_limit['minimum']}'
                ${is_min_revolving_credit_limit_corrected}=    Set Variable    ${True}
                BREAK
            ELSE
                Log    ERROR: Minimum revolving credit limit value '${item['value']}' does not match expected value '${expected_limit['minimum']}'
            END
        END
    END
    RETURN   ${case_detail}    ${actual_max_value}    ${actual_min_value}

Check Term Credit Limit Updated
    [Arguments]    ${session_id}    ${case_id}    ${expected_limit}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${is_max_term_credit_limit_corrected}=    Set Variable    ${False}
    ${actual_max_value}=    Set Variable    ${None}
    ${actual_min_value}=    Set Variable    ${None}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == '_loan.1.rangeMaximumLimit'
            ${actual_max_value}=    Set Variable    ${item['value']}
            IF    '${item['value']}' == '${expected_limit['maximum']}'
                ${is_max_term_credit_limit_corrected}=    Set Variable    ${True}
                BREAK
            ELSE
                Log    ERROR: Maximum term credit limit value '${item['value']}' does not match expected value '${expected_limit['maximum']}'
            END
        END
    END
    ${is_min_term_credit_limit_corrected}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == '_loan.1.rangeMinimumLimit'
            ${actual_min_value}=    Set Variable    ${item['value']}
            IF    '${item['value']}' == '${expected_limit['minimum']}'
                ${is_min_term_credit_limit_corrected}=    Set Variable    ${True}
                BREAK
            ELSE
                Log    ERROR: Minimum term credit limit value '${item['value']}' does not match expected value '${expected_limit['minimum']}'
            END
        END
    END
    RETURN   ${case_detail}    ${actual_max_value}    ${actual_min_value}

Check Available Credit Limit
    [Arguments]    ${session_id}    ${case_id}    ${available_limit_name}    ${available_limit}
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    ${is_available_credit_limit_corrected}=    Set Variable    ${False}
    FOR    ${item}    IN    @{case_detail['customer_data']}
        IF    '${item['field_name']}' == '${available_limit_name}' and '${item['value']}' == '${available_limit}'
            ${is_available_credit_limit_corrected}=    Set Variable    ${True}
            BREAK
        END
    END
    Should Be True     ${is_available_credit_limit_corrected}    Expected '_credit.availableNanoLoanCreditLimit' with '${available_limit}' value not corrected
    RETURN   ${case_detail}