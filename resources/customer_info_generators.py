import random

def generate_national_thai_id():
    # Step 1: Generate the first 12 digits randomly.
    # The first digit cannot be 0 or greater than 8 for most common IDs.
    first_part = str(random.randint(1, 8))
    
    # The remaining 11 digits can be any number from 0-9.
    second_part = ''.join(str(random.randint(0, 9)) for _ in range(11))
    
    first_12_digits = first_part + second_part

    # Step 2: Calculate the sum for the check digit algorithm.
    # Each of the first 12 digits is multiplied by its position weight (13 down to 2).
    total_sum = 0
    for i, digit in enumerate(first_12_digits):
        weight = 13 - i
        total_sum += int(digit) * weight

    # Step 3: Calculate the check digit.
    # The check digit is derived from the remainder of the sum divided by 11.
    remainder = total_sum % 11
    
    if remainder <= 1:
        check_digit = 1 - remainder
    else:
        check_digit = 11 - remainder

    # Step 4: Combine the first 12 digits with the calculated check digit.
    national_id = f"{first_12_digits}{check_digit}"
    
    return national_id

def build_unique_customer_info_answer():
    return [
        {
            "field_name": "_customerInfo.nationalIdNumber",
            "field_value": generate_national_thai_id(),
            "source": "customer"
        },
        {
            "field_name": "_customerInfo.titleName",
            "field_value": "2103",
            "source": "customer"
        },
        {
            "field_name": "firstName",
            "field_value": "ภัทรพร1",
            "source": "customer"
        },
        {
            "field_name": "middleName",
            "field_value": "",
            "source": "customer"
        },
        {
            "field_name": "lastName",
            "field_value": "ธาดาวรวงศ์",
            "source": "customer"
        }
    ]