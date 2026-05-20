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

GSB Lead Second Loan P-Loan Calculation Scenarios
    [Documentation]    รัน Scenario คำนวณวงเงินสำหรับ P-Loan (2nd Loan Auto Approve CR)
    Log    Starting 2nd Loan P-Loan Calculation Tests...    console=${True}
    
    FOR    ${test_case}    IN    @{GSB_LEAD_SECOND_P_LOAN_CALC_CASES}
        Run Keyword And Continue On Failure    Execute Calculation Test Case    
        ...    ${GSB_LEAD_P_LOAN_BASE_SCENARIO}    ${test_case}    ${NORMAL_P_LOAN_BASE_ANSWERS['initial_questions']}
    END

GSB Lead Second Loan Nano-Loan Calculation Scenarios
    [Documentation]    รัน Scenario คำนวณวงเงินสำหรับ Nano-Loan (2nd Loan Auto Approve CR)
    Log    Starting 2nd Loan Nano-Loan Calculation Tests...    console=${True}

    FOR    ${test_case}    IN    @{GSB_LEAD_SECOND_NANO_LOAN_CALC_CASES}
        Run Keyword And Continue On Failure    Execute Calculation Test Case    
        ...    ${GSB_LEAD_NANO_LOAN_BASE_SCENARIO}    ${test_case}    ${NORMAL_NANO_LOAN_BASE_ANSWERS['initial_questions']}
    END

*** Keywords ***

Execute Calculation Test Case
    [Arguments]    ${base_scenario}    ${test_data}    ${normal_base_answers}=${EMPTY}
    
    Log    =======================================================    console=${True}
    Log    Running Case: ${test_data['case_name']}    console=${True}
    Log    Inputs: ${test_data['inputs']}
    Log    Expected: ${test_data['expected']}
    
    # 1. รัน Flow ตั้งต้นของ GSB Lead
    ${session_id}    ${case_id}=    Initial GSB Lead Workflow    ${base_scenario}

    # 2. เช็คว่าเคสนี้คาดหวังให้ Route ไป Normal หรือไม่
    ${is_normal_route}=    Run Keyword And Return Status    Dictionary Should Contain Item    ${test_data['expected']}    _loan.campaign    normal
    ${has_normal_base}=    Run Keyword And Return Status    Should Not Be Empty    ${normal_base_answers}

    # 3. ยิงข้อมูลเงื่อนไข Risk/Income ก่อน เพื่อให้ระบบรู้ตัวว่าวงเงินเกิน และต้องเด้งไป Normal
    Log    🔄 Injecting Risk/Income Answers first to trigger routing logic...    console=${True}
    ${risk_income_answers}=    Build Answer    ${test_data['inputs']}
    Answer Questions    ${session_id}    ${case_id}    ${risk_income_answers}
    
    # 4. ถ้าระบบรู้ตัวว่าต้องเด้งไป Normal ค่อยเอา Base Normal มาอุด แล้วรัน Batch
    # IF    ${is_normal_route} and ${has_normal_base}
    #     Log    🚀 Scenario triggers Normal routing: Injecting Normal Base Answers...    console=${True}
    #     Answer Questions    ${session_id}    ${case_id}    ${normal_base_answers}
        
    #     Log    ⚙️ Triggering Submit Case and Batch Process for Normal flow...    console=${True}
    #     Submit Case    ${session_id}    ${case_id}
    #     Complete Batch Process    ${session_id}    ${case_id}
        
    #     Log    🔄 Re-injecting GSB Lead Base Answers to prevent overwrite...    console=${True}
    #     Answer Questions    ${session_id}    ${case_id}    ${base_scenario['answers']['initial_questions']}
    #     Answer Questions    ${session_id}    ${case_id}    ${base_scenario['answers']['campaign_select_questions']}

    #     Log    🔄 Injecting Risk/Income Answers again to prevent overwrite...    console=${True}
    #     ${risk_income_answers}=    Build Answer    ${test_data['inputs']}
    #     Answer Questions    ${session_id}    ${case_id}    ${risk_income_answers}
    # END

    Sleep    3s
    ${case_detail}=    Get Case Detail    ${session_id}    ${case_id}
    
    Verify Multiple Customer Data Fields    ${case_detail}    ${test_data['expected']}

    Log    ✅ Case '${test_data['case_name']}' Passed!    console=${True}