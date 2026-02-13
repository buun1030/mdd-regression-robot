*** Settings ***
Resource    ../resources/thinker_keywords.robot
Resource    ../resources/retry_keywords.robot
Resource    ../resources/global_setup.robot
Resource    ../resources/gsb_keywords.robot

Library     ../resources/answers.py
Library     ../resources/verification_library.py
Variables   ../scenarios.py

Suite Setup    Create Thinker Session

*** Test Cases ***

GSB Lead P-Loan Calculation Scenarios
    [Documentation]    รัน Scenario คำนวณวงเงินสำหรับ P-Loan ตามระดับความเสี่ยงและรายได้
    Log    Starting P-Loan Calculation Tests...    console=${True}
    
    FOR    ${test_case}    IN    @{GSB_LEAD_P_LOAN_CALC_CASES}
        Run Keyword And Continue On Failure    Execute Calculation Test Case    
        ...    ${GSB_LEAD_P_LOAN_BASE_SCENARIO}    ${test_case}
    END

GSB Lead Nano-Loan Calculation Scenarios
    [Documentation]    รัน Scenario คำนวณวงเงินสำหรับ Nano-Loan ตามระดับความเสี่ยงและรายได้
    Log    Starting Nano-Loan Calculation Tests...    console=${True}

    FOR    ${test_case}    IN    @{GSB_LEAD_NANO_LOAN_CALC_CASES}
        Run Keyword And Continue On Failure    Execute Calculation Test Case    
        ...    ${GSB_LEAD_NANO_LOAN_BASE_SCENARIO}    ${test_case}
    END

*** Keywords ***

Execute Calculation Test Case
    [Arguments]    ${base_scenario}    ${test_data}
    
    Log    =======================================================    console=${True}
    Log    Running Case: ${test_data['case_name']}    console=${True}
    Log    Inputs: ${test_data['inputs']}
    Log    Expected: ${test_data['expected']}
    
    ${session_id}    ${case_id}=    Initial GSB Lead Workflow    ${base_scenario}

    ${risk_income_answers}=    Build Gsb Risk And Income Answer    ${test_data['inputs']}
    Answer Questions    ${session_id}    ${case_id}    ${risk_income_answers}

    Sleep    3s

    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    Verify Multiple Customer Data Fields    ${case_detail}    ${test_data['expected']}

    Log    ✅ Case '${test_data['case_name']}' Passed!    console=${True}