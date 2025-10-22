def build_tcg_action_answer(action: str):
    return [
        {
            "field_name": "thinker.tcg.action",
            "field_value": action,
            "source": "customer"
        }
    ]