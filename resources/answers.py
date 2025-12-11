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