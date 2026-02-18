def build_tcg_action_answer(action: str):
    return [
        {
            "field_name": "thinker.tcg.action",
            "field_value": action,
            "source": "customer"
        }
    ]
    
def build_ncb_not_trust_and_invalid_grade_answer():
    return [
        {
            "field_name": "_credit.isNcbTrustSourceTads",
            "field_value": "NOT_TRUST",
            "source": "customer"
        },
        {
            "field_name": "_credit.ncbGrade",
            "field_value": "0",
            "source": "customer"
        }
    ]

def build_answer(inputs_dict):
    """
    แปลง Dictionary input เช่น {'_gsb.riskLevel': 10} 
    ให้เป็น List of Answer Format ของ Thinker API
    """
    answers = []
    for key, value in inputs_dict.items():
        answers.append({
            "field_name": key,
            "field_value": str(value),
            "source": "customer"
        })
    return answers