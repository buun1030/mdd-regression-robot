*** Settings ***
Resource    ../resources/normal_keywords.robot
Resource    ../resources/global_setup.robot
Library     ../resources/answers.py
Library     ../resources/verification_library.py
Variables   ../scenarios.py

Suite Setup    Global Suite Setup

*** Test Cases ***
Normal P-Loan Credit Limit Calculation Scenarios
    [Documentation]    Data-Driven Test for Normal P-Loan Credit Limit
    Log    Starting P-Loan Credit Limit Tests...    console=${True}
    
    FOR    ${test_case}    IN    @{NORMAL_P_LOAN_CREDIT_LIMIT_CASES}
        Run Keyword And Continue On Failure    Execute Credit Limit Test Case    
        ...    ${NORMAL_P_LOAN_NEW_CUSTOMER_TERM_SCENARIO}    ${test_case}
    END

Normal Nano-Loan Credit Limit Calculation Scenarios
    [Documentation]    Data-Driven Test for Normal Nano-Loan Credit Limit
    Log    Starting Nano-Loan Credit Limit Tests...    console=${True}
    
    FOR    ${test_case}    IN    @{NORMAL_NANO_LOAN_CREDIT_LIMIT_CASES}
        Run Keyword And Continue On Failure    Execute Credit Limit Test Case    
        ...    ${NORMAL_NANO_LOAN_NEW_CUSTOMER_TERM_SCENARIO}    ${test_case}
    END

*** Keywords ***
Execute Credit Limit Test Case
    [Arguments]    ${base_scenario}    ${test_data}
    
    Log    Running Case: ${test_data['case_name']}    console=${True}
    
    ${session_id}    ${case_id}    ${customer_info}=    Initial Normal Workflow    ${base_scenario}
    
    ${answers}=    Build Answer    ${test_data['inputs']}
    
    Log    Sending inputs: ${test_data['inputs']}
    Answer Questions    ${session_id}    ${case_id}    ${answers}
    
    Sleep    3s
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    
    Log    Verifying expected results: ${test_data['expected']}
    Verify Multiple Customer Data Fields    ${case_detail}    ${test_data['expected']}
    
    Log    ✅ Case '${test_data['case_name']}' Passed!    console=${True}