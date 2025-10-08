"""
Defines the scenarios for the end-to-end tests.
"""

valid_base64_content = "[\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEAAQMAAABmvDolAAAABlBMVEX///8AAABVwtN+AAABmklEQVR4nOyYMdKrMAyE10ORkiNwFB8NH81HyREoKTzeN5LsxDC89p+gQVXwfCmQxGplPPHEEz8bMyV2RAaS7/HIFSBn0z6TVR/WsLcjZ0BkVSCU17YI1458AqnixZYHtwBi0q6O/8vD7YHewnViL/dF298dMEGa86pdnaXcVyJ2c6BzebVXXysu4+ZAl2LNg3S1fcIstwKwkMCLGVJNACpB6du0PgAZlXUimYK8uijRtjAdEuUBYLYfWm59kDx8W9cHIK+uA4WD0spYcQaIuBbMTJi4SToo2RiU1gcA/VLF005q3asq1aBRLgAdkgW93NnMXqpHe3B/4B2T2oHEYp62PcAbwJaOoi0OLXfwBoj62oYyqXXnLrM2DG7QBSDlLubyhokDwBlgu4mezcytq4+L2M8Dn6I2vWXYRY9CgSvgc6OV2kCxy4Hxry6AtiJHXSrFGJzz4ATodyBayJE2XQ4S5AiwdXnJqGdv7woQjZJ9c+WFPfAAtOurVTC1BxtOa7UHoN9ooXlaW1rGhdQD8MQTT/x5/AsAAP//oCbiyX1d9MUAAAAASUVORK5CYII=\"]"

NORMAL_P_LOAN_BASE_ANSWERS = {
    "initial_questions": [
        {
            "field_name": "_loan.loanApplicationNumber",
            "field_value": "normal_a02_p_loan_new_customer",
            "source": "customer"
        },
        {
            "field_name": "emailAddress",
            "field_value": "test-email@gmail.com",
            "source": "customer"
        },
        {
            "field_name": "mobilePhone",
            "field_value": "0899999988",
            "source": "customer"
        },
        {
            "field_name": "_loan.requestDate",
            "field_value": "1730104992",
            "source": "customer"
        },
        # {
        #     "field_name": "_credit.loanActiveAccount",
        #     "field_value": "[\"1\"]",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.dayPastDue",
        #     "field_value": "0",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.existingCreditAmount",
        #     "field_value": "10000",
        #     "source": "customer"
        # },
        {
            "field_name": "_occupation.businessAddressPropertyRight",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.mailingAddressIndex",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.businessType",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.enFirstName",
            "field_value": "Testmambu",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.enLastName",
            "field_value": "Demoeditmambu",
            "source": "customer"
        },
        {
            "field_name": "birthDate",
            "field_value": "962557200",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.idExpireDate",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.line1",
            "field_value": "220/30",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.line2",
            "field_value": "หมู่ที่ 9",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.city",
            "field_value": "20",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.district",
            "field_value": "2011",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.subDistrict",
            "field_value": "201101",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.postcode",
            "field_value": "12346",
            "source": "customer"
        },
        {
            "field_name": "_loan.typePreSelect",
            "field_value": "P_LOAN",
            "source": "customer"
        },
        {
            "field_name": "_occupation.employType",
            "field_value": "EMPLOYEE",
            "source": "customer"
        },
        {
            "field_name": "_occupation.type",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousType",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_occupation.subType",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousSubType",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_occupation.typeOther",
            "field_value": "0891548123",
            "source": "customer"
        },
        {
            "field_name": "_loan.repaymentType",
            "field_value": "TERM",
            "source": "customer"
        },
        {
            "field_name": "_loan.loanRequest",
            "field_value": "100000",
            "source": "customer"
        },
        {
            "field_name": "scheduleSettings.repaymentInstallments",
            "field_value": "24",
            "source": "customer"
        },
        {
            "field_name": "scheduleSettings.fixedDaysOfMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.educationLevel",
            "field_value": "6",
            "source": "customer"
        },
        {
            "field_name": "gender",
            "field_value": "F",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.maritalStatus",
            "field_value": "M",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childWorkedAmount",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childNotWorkedAmount",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childAmount",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.incomeAmount",
            "field_value": "700000",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residencePeriodYear",
            "field_value": "5",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residencePeriodMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.companyName",
            "field_value": "บริษัท เงินดีดี จำกัด (มหาชน)",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousCompanyName",
            "field_value": "บริษัท เงินมั่งมี จำกัด (มหาชน)",
            "source": "customer"
        },
        {
            "field_name": "_credit.expenseAmount",
            "field_value": "5000",
            "source": "customer"
        },
        {
            "field_name": "_occupation.periodYear",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_occupation.totalPeriodYear",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.totalPeriodMonth",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousPeriodYear",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.periodMonth",
            "field_value": "5",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousPeriodMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.shareholdingPorpotion",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.line1",
            "field_value": "199 รัชดา 17",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.line2",
            "field_value": "ถนนรัชดา",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.city",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.district",
            "field_value": "1001",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.subDistrict",
            "field_value": "100110",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.postcode",
            "field_value": "10110",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residenceType",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residenceStatus",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.city",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_refPersons.1.relationship",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.line1",
            "field_value": "asasas",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.line2",
            "field_value": "asasas",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.district",
            "field_value": "1001",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.subDistrict",
            "field_value": "100103",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.postcode",
            "field_value": "10110",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.accountNumber",
            "field_value": "1231456454",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.accountName",
            "field_value": "ศศิภัคณ์",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.bankName",
            "field_value": "GSB",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.bankId",
            "field_value": "30",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.isValid",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.isDefault",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.16.password",
            "field_value": "[\"12334\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.1.password",
            "field_value": "[\"-\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.2.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.3.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.name",
            "field_value": "[\"AcctSt_Jul23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.4.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.name",
            "field_value": "[\"AcctSt_Aug23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.5.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        
        {
            "field_name": "_documents.8.name",
            "field_value": "[\"AcctSt_Nov23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.8.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.8.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.8.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.name",
            "field_value": "[\"AcctSt_Dec23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.9.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.10.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.11.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.12.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.13.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.14.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.15.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        
        {
            "field_name": "_documents.17.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.17.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.17.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.17.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.18.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.19.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.20.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.21.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.22.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.23.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.24.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.25.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.26.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.27.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.28.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.29.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.30.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_credit.isNcbTrustSource",
            "field_value": "TRUST",
            "source": "customer"
        },
        {
            "field_name": "_credit.isNcbConsentAccept",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.authenticationType",
            "field_value": "NDID",
            "source": "customer"
        }
    ],
    "customer_decision": [
        {"field_name": "_loan.customerDecision", "field_value": "ACCEPT", "source": "customer"},
        {"field_name": "loanAmount", "field_value": "100000", "source": "customer"},
        {"field_name": "_loan.repaymentType", "field_value": "TERM", "source": "customer"},
        {"field_name": "scheduleSettings.repaymentInstallments", "field_value": "12", "source": "customer"}
    ]
}

NORMAL_NANO_LOAN_BASE_ANSWERS = {
    "initial_questions": [
        {
            "field_name": "_loan.loanApplicationNumber",
            "field_value": "normal_a02_nano_loan_new_customer",
            "source": "customer"
        },
        {
            "field_name": "_credit.foundInAmlo",
            "field_value": "NOT_FOUND",
            "source": "customer"
        },
        {
            "field_name": "forceRejectFromBatch",
            "field_value": "false",
            "source": "customer"
        },
        {
            "field_name": "override_productTypeKey",
            "field_value": "8ac4806b8c163fd8018c1f06315e0000",
            "source": "customer"
        },
        {
            "field_name": "scheduleSettings.repaymentInstallments",
            "field_value": "48",
            "source": "customer"
        },
        # {
        #     "field_name": "_customerInfo.foundSuccessLoan",
        #     "field_value": "FOUND",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.firstBookDate",
        #     "field_value": "1720577167",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalPLoanAmount",
        #     "field_value": "30000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalPLoanRepayment",
        #     "field_value": "20000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalOutstanding",
        #     "field_value": "10000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalNanoLoanAmount",
        #     "field_value": "0",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalNanoLoanRepayment",
        #     "field_value": "0",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.loanActiveAccount",
        #     "field_value": "[\"1\"]",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.dayPastDue",
        #     "field_value": "0",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.existingCreditAmount",
        #     "field_value": "10000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalNanoTermLoanLimit",
        #     "field_value": "85000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalNanoTermLoanRepayment",
        #     "field_value": "30000",
        #     "source": "customer"
        # },
        # {
        #     "field_name": "_credit.totalNanoRevolvingLoanLimit",
        #     "field_value": "20000",
        #     "source": "customer"
        # },
        {
            "field_name": "mobilePhone",
            "field_value": "0899999988",
            "source": "customer"
        },
        {
            "field_name": "_loan.requestDate",
            "field_value": "1730104992",
            "source": "customer"
        },
        {
            "field_name": "_occupation.businessAddressPropertyRight",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.mailingAddressIndex",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.businessType",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.enFirstName",
            "field_value": "Testmambu",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.enLastName",
            "field_value": "Demoeditmambu",
            "source": "customer"
        },
        {
            "field_name": "birthDate",
            "field_value": "1064559236",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.idExpireDate",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.line1",
            "field_value": "220/30",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.line2",
            "field_value": "หมู่ที่ 9",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.city",
            "field_value": "20",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.district",
            "field_value": "2011",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.subDistrict",
            "field_value": "201101",
            "source": "customer"
        },
        {
            "field_name": "_addresses.1.postcode",
            "field_value": "12346",
            "source": "customer"
        },
        {
            "field_name": "_loan.typePreSelect",
            "field_value": "NANO_LOAN",
            "source": "customer"
        },
        {
            "field_name": "_occupation.employType",
            "field_value": "FREELANCE",
            "source": "customer"
        },
        {
            "field_name": "_occupation.type",
            "field_value": "06",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousType",
            "field_value": "06",
            "source": "customer"
        },
        {
            "field_name": "_occupation.subType",
            "field_value": "06",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousSubType",
            "field_value": "06",
            "source": "customer"
        },
        {
            "field_name": "_occupation.typeOther",
            "field_value": "0891548123",
            "source": "customer"
        },
        {
            "field_name": "_loan.repaymentType",
            "field_value": "TERM",
            "source": "customer"
        },
        {
            "field_name": "_loan.loanRequest",
            "field_value": "60000",
            "source": "customer"
        },
        {
            "field_name": "scheduleSettings.fixedDaysOfMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.educationLevel",
            "field_value": "6",
            "source": "customer"
        },
        {
            "field_name": "gender",
            "field_value": "F",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.maritalStatus",
            "field_value": "M",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childWorkedAmount",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childNotWorkedAmount",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.childAmount",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.incomeAmount",
            "field_value": "700000",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residencePeriodYear",
            "field_value": "5",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residencePeriodMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.companyName",
            "field_value": "บริษัท เงินดีดี จำกัด (มหาชน)",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousCompanyName",
            "field_value": "บริษัท เงินมั่งมี จำกัด (มหาชน)",
            "source": "customer"
        },
        {
            "field_name": "_credit.expenseAmount",
            "field_value": "5000",
            "source": "customer"
        },
        {
            "field_name": "_occupation.periodYear",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_occupation.totalPeriodYear",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.totalPeriodMonth",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousPeriodYear",
            "field_value": "1",
            "source": "customer"
        },
        {
            "field_name": "_occupation.periodMonth",
            "field_value": "5",
            "source": "customer"
        },
        {
            "field_name": "_occupation.previousPeriodMonth",
            "field_value": "2",
            "source": "customer"
        },
        {
            "field_name": "_occupation.shareholdingPorpotion",
            "field_value": "0",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.line1",
            "field_value": "199 รัชดา 17",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.line2",
            "field_value": "ถนนรัชดา",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.city",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.district",
            "field_value": "1001",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.subDistrict",
            "field_value": "100110",
            "source": "customer"
        },
        {
            "field_name": "_addresses.3.postcode",
            "field_value": "10110",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residenceType",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.residenceStatus",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.city",
            "field_value": "10",
            "source": "customer"
        },
        {
            "field_name": "_refPersons.1.relationship",
            "field_value": "01",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.line1",
            "field_value": "asasas",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.line2",
            "field_value": "asasas",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.district",
            "field_value": "1001",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.subDistrict",
            "field_value": "100103",
            "source": "customer"
        },
        {
            "field_name": "_addresses.2.postcode",
            "field_value": "10110",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.accountNumber",
            "field_value": "1231456454",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.accountName",
            "field_value": "ศศิภัคณ์",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.bankName",
            "field_value": "GSB",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.bankId",
            "field_value": "30",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.isValid",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_bankAccount.1.isDefault",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_spouse.nationalIdOrPassportNumber",
            "field_value": "3535136077034",
            "source": "customer"
        },
        {
            "field_name": "_spouse.titleName",
            "field_value": "2101",
            "source": "customer"
        },
        {
            "field_name": "_spouse.firstName",
            "field_value": "Peary",
            "source": "customer"
        },
        {
            "field_name": "_spouse.lastName",
            "field_value": "Downy",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.line1",
            "field_value": "220/30",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.line2",
            "field_value": "หมู่ที่ 9",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.line3",
            "field_value": "สี่พระยา",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.city",
            "field_value": "20",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.district",
            "field_value": "2011",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.subDistrict",
            "field_value": "201101",
            "source": "customer"
        },
        {
            "field_name": "_spouse.addresses.postcode",
            "field_value": "12346",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.16.password",
            "field_value": "[\"12334\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.16.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.name",
            "field_value": "[\"national_id_card_03.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.1.password",
            "field_value": "[\"-\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.1.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.name",
            "field_value": "[\"change_name_03.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.2.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.2.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.3.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.3.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.name",
            "field_value": "[\"AcctSt_Jul23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.4.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.4.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.name",
            "field_value": "[\"AcctSt_Aug23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.5.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.5.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.8.name",
            "field_value": "[\"AcctSt_Nov23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.8.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.8.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.8.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.name",
            "field_value": "[\"AcctSt_Dec23.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.9.password",
            "field_value": "[\"14021995\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.9.docType",
            "field_value": "[\"file/pdf\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.10.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.10.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.11.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.11.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.12.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.12.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.13.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.13.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.14.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.14.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.15.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.17.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.17.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.17.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.17.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.18.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.18.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.19.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.19.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.20.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.20.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.21.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.21.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.22.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.22.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.23.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.23.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.24.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.24.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.25.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.25.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.26.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.26.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.27.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.27.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.28.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.28.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.29.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.29.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.30.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.30.docType",
            "field_value": "[\"image/png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.1.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.1.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.1.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.2.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.2.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.2.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.3.name",
            "field_value": "[\"test.png\"]",
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.3.content",
            "field_value": valid_base64_content,
            "source": "customer"
        },
        {
            "field_name": "_documents.spouse.3.password",
            "field_value": "[\"1234\"]",
            "source": "customer"
        },
        {
            "field_name": "_credit.isNcbTrustSource",
            "field_value": "TRUST",
            "source": "customer"
        },
        {
            "field_name": "_credit.isNcbConsentAccept",
            "field_value": "true",
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.authenticationType",
            "field_value": "NDID",
            "source": "customer"
        }
    ],
    "customer_decision": [
        {"field_name": "_loan.customerDecision", "field_value": "ACCEPT", "source": "customer"},
        {"field_name": "loanAmount", "field_value": "50000", "source": "customer"},
        {"field_name": "_loan.repaymentType", "field_value": "TERM", "source": "customer"},
        {"field_name": "scheduleSettings.repaymentInstallments", "field_value": "12", "source": "customer"}
    ]
}

GSB_LEAD_P_LOAN_BASE_ANSWERS = {
    "initial_questions": [
        {
            "source": "customer",
            "field_name": "_loan.loanApplicationNumber",
            "field_value": "gsb_lead_ploan"
        },
        {
            "source": "customer",
            "field_name": "_gsb.foundCustomer",
            "field_value": "FOUND"
        },
        {
            "source": "customer",
            "field_name": "mobilePhone",
            "field_value": "0614519528"
        },
        {
            "source": "customer",
            "field_name": "_loan.requestDate",
            "field_value": "1726630409"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.nationalIdNumber",
            "field_value": "1200100436999"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.titleName",
            "field_value": "2101"
        },
        {
            "source": "customer",
            "field_name": "firstName",
            "field_value": "ทดสอบ"
        },
        {
            "source": "customer",
            "field_name": "middleName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "lastName",
            "field_value": "ทดสอบ"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.enFirstName",
            "field_value": "Test"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.enLastName",
            "field_value": "Test"
        },
        {
            "source": "customer",
            "field_name": "birthDate",
            "field_value": "975110400"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.line1",
            "field_value": "66/30"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.line2",
            "field_value": " "
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.city",
            "field_value": "12"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.district",
            "field_value": "1203"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.subDistrict",
            "field_value": "120305"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.postcode",
            "field_value": "11140"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.line1",
            "field_value": "21/26 หมู่ที่ 2"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.line2",
            "field_value": " "
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.city",
            "field_value": "12"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.district",
            "field_value": "1203"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.subDistrict",
            "field_value": "120305"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.postcode",
            "field_value": "11140"
        },
        {
            "source": "customer",
            "field_name": "_occupation.employType",
            "field_value": "EMPLOYEE"
        },
        {
            "source": "customer",
            "field_name": "_occupation.type",
            "field_value": "01"
        },
        {
            "source": "customer",
            "field_name": "_occupation.subType",
            "field_value": "01"
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbRegSalaryAmount",
            "field_value": "32000.00"
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbRegIncomeTotalAmount",
            "field_value": "32000.00"
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbIncomeTotalAmount",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.authenticationType",
            "field_value": "EKYC"
        },
        {
            "source": "customer",
            "field_name": "_gsb.rejectReason",
            "field_value": "CC2"
        },
        {
            "source": "customer",
            "field_name": "_gsb.debtServiceRatio",
            "field_value": "0.79"
        },
        {
            "source": "customer",
            "field_name": "_gsb.aScoreGrade",
            "field_value": "C"
        },
        {
            "source": "customer",
            "field_name": "_gsb.riskLevel",
            "field_value": "12"
        }
    ],
    "campaign_select_questions": [
        {
            "source": "customer",
            "field_name": "_loan.campaignSelect",
            "field_value": "agsb0724"
        }
    ],
    "secondary_questions": [
        {
            "source": "customer",
            "field_name": "_customerInfo.mailingAddressIndex",
            "field_value": "2"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.line1",
            "field_value": "204"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.line2",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.city",
            "field_value": "10"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.district",
            "field_value": "1030"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.subDistrict",
            "field_value": "103004"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.postcode",
            "field_value": "10900"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.accountNumber",
            "field_value": "020000362093"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.accountName",
            "field_value": "นาย สุภคี จงวิเศษกุล"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.bankName",
            "field_value": "ธนาคารออมสิน"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.bankId",
            "field_value": "030"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.isValid",
            "field_value": "true"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.isDefault",
            "field_value": "true"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.firstName",
            "field_value": "สมัคร"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.lastName",
            "field_value": "ศรสุพรรณ"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.mobilePhone",
            "field_value": "0614519532"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.relationship",
            "field_value": "05"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.firstName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.lastName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.mobilePhone",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.relationship",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "scheduleSettings.repaymentInstallments",
            "field_value": "24"
        },
        {
            "source": "customer",
            "field_name": "loanAmount",
            "field_value": "30000"
        },
        {
            "source": "customer",
            "field_name": "_loan.repaymentType",
            "field_value": "TERM"
        }
    ],
    "customer_decision": [
        {"field_name": "_loan.customerDecision", "field_value": "ACCEPT", "source": "customer"},
        {"field_name": "loanAmount", "field_value": "30000", "source": "customer"},
        {"field_name": "_loan.repaymentType", "field_value": "TERM", "source": "customer"},
        {"field_name": "scheduleSettings.repaymentInstallments", "field_value": "24", "source": "customer"},
        {"field_name": "scheduleSettings.fixedDaysOfMonth", "field_value": "2", "source": "customer"}
    ]
}

GSB_LEAD_NANO_LOAN_BASE_ANSWERS = {
    "initial_questions": [
        {
            "source": "customer",
            "field_name": "_loan.loanApplicationNumber",
            "field_value": "gsb_lead_nanoloan"
        },
        {
            "source": "customer",
            "field_name": "_gsb.foundCustomer",
            "field_value": "FOUND"
        },
        {
            "source": "customer",
            "field_name": "mobilePhone",
            "field_value": "0614519528"
        },
        {
            "source": "customer",
            "field_name": "_loan.requestDate",
            "field_value": "1726630409"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.nationalIdNumber",
            "field_value": "1200100436999"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.titleName",
            "field_value": "2101"
        },
        {
            "source": "customer",
            "field_name": "firstName",
            "field_value": "ทดสอบ"
        },
        {
            "source": "customer",
            "field_name": "middleName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "lastName",
            "field_value": "ทดสอบ"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.enFirstName",
            "field_value": "Test"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.enLastName",
            "field_value": "Test"
        },
        {
            "source": "customer",
            "field_name": "birthDate",
            "field_value": "975110400"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.line1",
            "field_value": "66/30"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.line2",
            "field_value": " "
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.city",
            "field_value": "12"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.district",
            "field_value": "1203"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.subDistrict",
            "field_value": "120305"
        },
        {
            "source": "customer",
            "field_name": "_addresses.1.postcode",
            "field_value": "11140"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.line1",
            "field_value": "21/26 หมู่ที่ 2"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.line2",
            "field_value": " "
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.city",
            "field_value": "12"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.district",
            "field_value": "1203"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.subDistrict",
            "field_value": "120305"
        },
        {
            "source": "customer",
            "field_name": "_addresses.2.postcode",
            "field_value": "11140"
        },
        {
            "source": "customer",
            "field_name": "_occupation.employType",
            "field_value": "FREELANCE"
        },
        {
            "source": "customer",
            "field_name": "_occupation.type",
            "field_value": "06"
        },
        {
            "source": "customer",
            "field_name": "_occupation.subType",
            "field_value": "15"
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbRegSalaryAmount",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbRegIncomeTotalAmount",
            "field_value": "32000.00"
        },
        {
            "source": "customer",
            "field_name": "_occupation.gsbIncomeTotalAmount",
            "field_value": "32000.00"
        },
        {
            "source": "customer",
            "field_name": "_customerInfo.authenticationType",
            "field_value": "EKYC"
        },
        {
            "source": "customer",
            "field_name": "_gsb.rejectReason",
            "field_value": "CC2"
        },
        {
            "source": "customer",
            "field_name": "_gsb.debtServiceRatio",
            "field_value": "0.80"
        },
        {
            "source": "customer",
            "field_name": "_gsb.aScoreGrade",
            "field_value": "C"
        },
        {
            "source": "customer",
            "field_name": "_gsb.riskLevel",
            "field_value": "12"
        }
    ],
    "campaign_select_questions": [
        {
            "source": "customer",
            "field_name": "_loan.campaignSelect",
            "field_value": "agsb0724"
        }
    ],
    "secondary_questions": [
        {
            "source": "customer",
            "field_name": "_customerInfo.mailingAddressIndex",
            "field_value": "2"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.line1",
            "field_value": "204"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.line2",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.city",
            "field_value": "10"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.district",
            "field_value": "1030"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.subDistrict",
            "field_value": "103004"
        },
        {
            "source": "customer",
            "field_name": "_addresses.3.postcode",
            "field_value": "10900"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.accountNumber",
            "field_value": "020000362093"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.accountName",
            "field_value": "นาย สุภคี จงวิเศษกุล"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.bankName",
            "field_value": "ธนาคารออมสิน"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.bankId",
            "field_value": "030"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.isValid",
            "field_value": "true"
        },
        {
            "source": "customer",
            "field_name": "_bankAccount.1.isDefault",
            "field_value": "true"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.firstName",
            "field_value": "สมัคร"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.lastName",
            "field_value": "ศรสุพรรณ"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.mobilePhone",
            "field_value": "0614519532"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.1.relationship",
            "field_value": "05"
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.firstName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.lastName",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.mobilePhone",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "_refPersons.2.relationship",
            "field_value": ""
        },
        {
            "source": "customer",
            "field_name": "scheduleSettings.repaymentInstallments",
            "field_value": "24"
        },
        {
            "source": "customer",
            "field_name": "loanAmount",
            "field_value": "20000"
        },
        {
            "source": "customer",
            "field_name": "_loan.repaymentType",
            "field_value": "TERM"
        }
    ],
    "customer_decision": [
        {"field_name": "_loan.customerDecision", "field_value": "ACCEPT", "source": "customer"},
        {"field_name": "loanAmount", "field_value": "20000", "source": "customer"},
        {"field_name": "_loan.repaymentType", "field_value": "TERM", "source": "customer"},
        {"field_name": "scheduleSettings.repaymentInstallments", "field_value": "24", "source": "customer"},
        {"field_name": "scheduleSettings.fixedDaysOfMonth", "field_value": "2", "source": "customer"}
    ]
}

# Each dictionary represents one full, independent end-to-end test run.
# You can add as many scenarios as you need.

NORMAL_P_LOAN_NEW_CUSTOMER_BASE_SCENARIO = {
    "test_id": "normal_a02_p_loan_new_customer_base",
    "product_name": "moneydd.pLoan",
    "answers": NORMAL_P_LOAN_BASE_ANSWERS,
    "escalations": {
        "ca_to_sca": "SCA",
        "sca_to_md": "MD"
    },
    "md_decision": "A02",
    "available_credit_limit_name": "_credit.availablePLoanCreditLimit",
    "expected": {
        "found_success_loan": "NOT_FOUND",
        "task_name_substrings": {
            "ca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationNewCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.ca"
            ],
            "sca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationNewCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.sca"
            ],
            "md": [
                "summary.md"
            ]
        },
        "available_escalation_roles": {
            "ca": ["CA", "SCA"],
            "sca": ["CA", "SCA", "CM", "MD", "CC", "EC"],
            "md": ["CA", "SCA", "CM", "MD", "CC", "EC"]
        },
        "unavailable_escalation_roles": {
            "ca": ["CM", "MD", "CC", "EC"],
            "sca": [],
            "md": []
        },
        "final_status": "COMPLETED",
        "loan_result": "A02"
    },
    "repayment_amount": "33000"
}

NORMAL_P_LOAN_OLD_CUSTOMER_BASE_SCENARIO = {
    "test_id": "normal_a02_p_loan_new_customer_base",
    "product_name": "moneydd.pLoan",
    "answers": NORMAL_P_LOAN_BASE_ANSWERS,
    "escalations": {
        "ca_to_sca": "SCA",
        "sca_to_md": "MD"
    },
    "md_decision": "A02",
    "available_credit_limit_name": "_credit.availablePLoanCreditLimit",
    "expected": {
        "found_success_loan": "FOUND",
        "available_credit_limit": "933000", # 1,000,000 (upper limit) - 67,000 (existing limit)
        "task_name_substrings": {
            "ca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationOldCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.ca"
            ],
            "sca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationOldCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.sca"
            ],
            "md": [
                "summary.md"
            ]
        },
        "available_escalation_roles": {
            "ca": ["CA", "SCA"],
            "sca": ["CA", "SCA", "CM", "MD", "CC", "EC"],
            "md": ["CA", "SCA", "CM", "MD", "CC", "EC"]
        },
        "unavailable_escalation_roles": {
            "ca": ["CM", "MD", "CC", "EC"],
            "sca": [],
            "md": []
        },
        "final_status": "COMPLETED",
        "loan_result": "A02"
    },
    "repayment_amount": "0"
}

NORMAL_NANO_LOAN_NEW_CUSTOMER_BASE_SCENARIO = {
    "test_id": "normal_a02_nano_loan_new_customer_base",
    "product_name": "moneydd.nanoLoan",
    "answers": NORMAL_NANO_LOAN_BASE_ANSWERS,
    "escalations": {
        "ca_to_sca": "SCA",
        "sca_to_md": "MD"
    },
    "md_decision": "A02",
    "available_credit_limit_name": "_credit.availableNanoLoanCreditLimit",
    "expected": {
        "found_success_loan": "NOT_FOUND",
        "task_name_substrings": {
            "ca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationNewCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.ca"
            ],
            "sca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationNewCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.sca"
            ],
            "md": [
                "summary.md"
            ]
        },
        "available_escalation_roles": {
            "ca": ["CA", "SCA"],
            "sca": ["CA", "SCA", "CM", "MD", "CC", "EC"],
            "md": ["CA", "SCA", "CM", "MD", "CC", "EC"]
        },
        "unavailable_escalation_roles": {
            "ca": ["CM", "MD", "CC", "EC"],
            "sca": [],
            "md": []
        },
        "final_status": "COMPLETED",
        "loan_result": "A02"
    },
    "repayment_amount": "18000"
}

NORMAL_NANO_LOAN_OLD_CUSTOMER_BASE_SCENARIO = {
    "test_id": "normal_a02_nano_loan_old_customer_base",
    "product_name": "moneydd.nanoLoan",
    "answers": NORMAL_NANO_LOAN_BASE_ANSWERS,
    "escalations": {
        "ca_to_sca": "SCA",
        "sca_to_md": "MD"
    },
    "md_decision": "A02",
    "available_credit_limit_name": "_credit.availableNanoLoanCreditLimit",
    "expected": {
        "found_success_loan": "FOUND",
        "available_credit_limit": "68000", # 100,000 (upper limit) - 32,000 (existing limit)
        "task_name_substrings": {
            "ca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationOldCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.ca"
            ],
            "sca": [
                "customer.information",
                "occupation.informationPresent",
                "bank.1.information",
                "occupation.informationPrevious",
                "informationOldCustomer",
                "document.other",
                "ncb.direct",
                "document.main",
                "informationInterest",
                "informationRevolving",
                "informationTerm",
                "summary.sca"
            ],
            "md": [
                "summary.md"
            ]
        },
        "available_escalation_roles": {
            "ca": ["CA", "SCA"],
            "sca": ["CA", "SCA", "CM", "MD", "CC", "EC"],
            "md": ["CA", "SCA", "CM", "MD", "CC", "EC"]
        },
        "unavailable_escalation_roles": {
            "ca": ["CM", "MD", "CC", "EC"],
            "sca": [],
            "md": []
        },
        "final_status": "COMPLETED",
        "loan_result": "A02"
    },
    "repayment_amount": "0"
}

NORMAL_P_LOAN_CREDIT_LIMIT_TEST_CASES = {
    "test_id": "normal_p_loan_credit_limit",
    "product_name": "moneydd.pLoan",
    "answers": NORMAL_P_LOAN_BASE_ANSWERS,
    "cases": [
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "30000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "8300", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "5000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "310000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "180000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"664900\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "-1", "minimum": "-1"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "FOUND", "source": "customer"},
                {"field_name": "_credit.totalPLoanTermLoanLimit", "field_value": "985000", "source": "customer"},
                {"field_name": "_credit.totalPLoanTermLoanRepayment", "field_value": "30000", "source": "customer"},
                {"field_name": "_credit.totalPLoanRevolvingLoanLimit", "field_value": "20000", "source": "customer"},
                {"field_name": "_credit.totalPLoanAmount", "field_value": "985000", "source": "customer"},
                {"field_name": "_credit.totalPLoanRepayment", "field_value": "30000", "source": "customer"},
                {"field_name": "_credit.totalNanoLoanAmount", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.totalNanoLoanRepayment", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.firstBookDate", "field_value": "1720577167", "source": "customer"},
                {"field_name": "_credit.dayPastDue", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.existingCreditAmount", "field_value": "10000", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "25000", "minimum": "5000"}
            }
        }
    ]
}

NORMAL_NANO_LOAN_CREDIT_LIMIT_TEST_CASES = {
    "test_id": "normal_nano_loan_credit_limit",
    "product_name": "moneydd.nanoLoan",
    "answers": NORMAL_NANO_LOAN_BASE_ANSWERS,
    "cases": [
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "30000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "8300", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "5000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "110000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "60000", "minimum": "5000"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"664900\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "NOT_FOUND", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "-1", "minimum": "-1"}
            }
        },
        {
            "answers": [
                {"field_name": "_loan.loanRequest", "field_value": "50000", "source": "customer"},
                {"field_name": "_credit.tadsResult.ncbDebtInstallment", "field_value": "[\"0\",\"0\",\"30000\"]", "source": "customer"},
                {"field_name": "_customerInfo.foundSuccessLoan", "field_value": "FOUND", "source": "customer"},
                {"field_name": "_credit.totalNanoTermLoanLimit", "field_value": "85000", "source": "customer"},
                {"field_name": "_credit.totalNanoTermLoanRepayment", "field_value": "30000", "source": "customer"},
                {"field_name": "_credit.totalNanoRevolvingLoanLimit", "field_value": "20000", "source": "customer"},
                {"field_name": "_credit.totalNanoLoanAmount", "field_value": "85000", "source": "customer"},
                {"field_name": "_credit.totalNanoLoanRepayment", "field_value": "30000", "source": "customer"},
                {"field_name": "_credit.totalPLoanAmount", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.totalPLoanRepayment", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.firstBookDate", "field_value": "1720577167", "source": "customer"},
                {"field_name": "_credit.dayPastDue", "field_value": "0", "source": "customer"},
                {"field_name": "_credit.existingCreditAmount", "field_value": "10000", "source": "customer"}
            ],
            "expected": {
                "revolving_credit_limit": {"maximum": "25000", "minimum": "5000"}
            }
        }
    ]
}

GSB_LEAD_P_LOAN_BASE_SCENARIO = {
    "test_id": "gsb_lead_p_loan_base",
    "product_name": "moneydd.pLoan",
    "answers": GSB_LEAD_P_LOAN_BASE_ANSWERS,
    "expected": {
        "final_status": "COMPLETED",
        "loan_result": "A01"
    }
}

GSB_LEAD_NANO_LOAN_BASE_SCENARIO = {
    "test_id": "gsb_lead_nano_loan_base",
    "product_name": "moneydd.nanoLoan",
    "answers": GSB_LEAD_NANO_LOAN_BASE_ANSWERS,
    "expected": {
        "final_status": "COMPLETED",
        "loan_result": "A01"
    }
}