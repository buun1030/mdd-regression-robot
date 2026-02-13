def verify_task_name_substrings(claimed_tasks, expected_substrings):
    """
    ตรวจสอบว่า Task ที่ Claim มา มี method name ตรงกับที่คาดหวังหรือไม่
    """
    for substring in expected_substrings:
        found = False
        for task in claimed_tasks:
            task_method_name = str(task.get('task_method_name', ''))
            if substring in task_method_name:
                found = True
                break
        
        if not found:
            raise AssertionError(f"Expected task substring '{substring}' not found in claimed tasks.")
    
    print(f"Successfully verified {len(expected_substrings)} task substrings.")

def verify_escalation_roles(task_details, expected_roles, unexpected_roles):
    """
    ตรวจสอบ Role Assignment ใน Task Details
    """
    verified_count = 0
    
    for task_id, detail_data in task_details.items():
        verification_method = detail_data.get('verification_method_name', '')
        
        if 'verifying_fields' in detail_data and 'summary' in verification_method:
            for field_item in detail_data['verifying_fields']:
                field = field_item.get('field', {})
                
                if field.get('field_name') == 'thinker.roleAssignment':
                    choices = field.get('choices', [])
                    choice_values = [c.get('value') for c in choices]
                    
                    for role in expected_roles:
                        if role not in choice_values:
                            raise AssertionError(f"Task {task_id}: Expected role '{role}' NOT found in choices. Available: {choice_values}")
                    
                    for role in unexpected_roles:
                        if role in choice_values:
                            raise AssertionError(f"Task {task_id}: Unexpected role '{role}' FOUND in choices. Available: {choice_values}")
                    
                    verified_count += 1

    if verified_count == 0:
        print("Warning: No 'thinker.roleAssignment' field found to verify in any summary task.")
    else:
        print(f"Successfully verified escalation roles in {verified_count} fields.")

def verify_customer_data_field(case_detail, field_name, expected_value):
    """
    ตรวจสอบค่าใน customer_data
    """
    customer_data = case_detail.get('customer_data', [])
    found = False
    actual_value = None
    
    for item in customer_data:
        if item.get('field_name') == field_name:
            actual_value = item.get('value')
            if str(actual_value) == str(expected_value):
                found = True
            break
    
    if not found:
        error_msg = f"Expected field '{field_name}' with value '{expected_value}' not found."
        if actual_value is not None:
            error_msg += f" (Found value: '{actual_value}')"
        raise AssertionError(error_msg)
        
    print(f"Successfully verified field '{field_name}' is '{expected_value}'.")

def verify_multiple_customer_data_fields(case_detail, expected_dict):
    """
    ตรวจสอบ customer_data หลาย field พร้อมกัน
    ถ้า field ไหนใน expected_dict เป็นว่าง/None จะข้ามการตรวจสอบ field นั้น
    """
    customer_data = case_detail.get('customer_data', [])
    
    # แปลงข้อมูล Actual เป็น Dict เพื่อให้ค้นหาเร็ว
    actual_data_map = {item.get('field_name'): item.get('value') for item in customer_data}
    
    errors = []
    
    for field_name, expected_val in expected_dict.items():
        # ข้ามถ้า expected เป็นค่าว่าง (สำหรับกรณี CANCELED ที่ไม่มี limit)
        if not expected_val:
            continue
            
        actual_val = actual_data_map.get(field_name)
        
        # เปรียบเทียบ (แปลงเป็น string เพื่อความชัวร์)
        if str(actual_val) != str(expected_val):
            errors.append(f"Field '{field_name}' - Expected: '{expected_val}', Got: '{actual_val}'")
            
    if errors:
        error_msg = "\n".join(errors)
        raise AssertionError(f"Verification Failed with {len(errors)} errors:\n{error_msg}")
        
    print(f"Successfully verified {len(expected_dict)} fields.")