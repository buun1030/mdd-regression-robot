"""
เก็บหลักฐานผลเทส booking เป็นไฟล์ใน ${OUTPUT DIR}/evidence/

ค่าทุกตัวดึงจากระบบจริงในจังหวะนั้น (get-case-detail / get-booking-report-detail /
Mambu documentsMetadata) ไม่ใช่ค่าที่เทสตั้งใจจะส่ง จึงใช้แทนการ cap จอ DB ได้
customer_data ใน DB เก็บแค่ค่าล่าสุด ค่าก่อนแก้จึงต้องเก็บไว้ก่อนแก้เท่านั้น
"""
import json
import os

from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn


def _output_dir():
    path = os.path.join(BuiltIn().get_variable_value("${OUTPUT DIR}"), "evidence")
    os.makedirs(path, exist_ok=True)
    return path


def capture_booking_evidence(case_id, label, case_detail, booking_detail, documents, field_names):
    """เก็บ field ที่สนใจ + booking report + สรุปเอกสาร loan ณ จังหวะนี้ แล้วเขียนเป็น JSON"""
    by_name = {d.get("field_name"): d for d in case_detail.get("customer_data") or []}
    fields = {}
    for name in field_names:
        d = by_name.get(name)
        fields[name] = None if d is None else {
            "value": d.get("value"),
            "input_source": d.get("input_source"),
            "updated_at": d.get("updated_at"),
        }
    evidence = {
        "case_id": case_id,
        "label": label,
        "case_status": case_detail.get("status"),
        "fields": fields,
        "booking": {
            "latest_status": booking_detail.get("latest_status"),
            "retry_count": booking_detail.get("retry_count"),
            "latest_trigger_by": booking_detail.get("latest_trigger_by"),
            "latest_result": booking_detail.get("latest_result"),
        },
        "loan_documents": {
            "count": len(documents),
            "unique_notes": len({d.get("notes") for d in documents}),
            "ids": sorted(str(d.get("id")) for d in documents),
        },
    }
    path = os.path.join(_output_dir(), f"{case_id}_{label}.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(evidence, f, ensure_ascii=False, indent=2)
    logger.info(f'<a href="evidence/{case_id}_{label}.json">evidence/{case_id}_{label}.json</a>', html=True)
    return evidence


def write_booking_evidence_summary(case_id, before, after, new_documents):
    """ตารางเทียบก่อน/หลังเป็น markdown + แสดงเป็นตารางใน log.html (ใช้ cap จอเป็นผลเทส)"""
    rows = [("case status", before["case_status"], after["case_status"])]
    for name in before["fields"]:
        b, a = before["fields"][name], after["fields"].get(name)
        rows.append((name, b and b["value"], a and a["value"]))
    rows += [
        ("booking latest_status", before["booking"]["latest_status"], after["booking"]["latest_status"]),
        ("booking retry_count", before["booking"]["retry_count"], after["booking"]["retry_count"]),
        ("loan documents (count)", before["loan_documents"]["count"], after["loan_documents"]["count"]),
        ("loan documents (unique notes)", before["loan_documents"]["unique_notes"], after["loan_documents"]["unique_notes"]),
    ]
    new_lines = [f"- id={d.get('id')} `{d.get('fileName')}` — {d.get('notes')} ({d.get('creationDate')})" for d in new_documents]

    md = [f"# Booking evidence — {case_id}", "",
          f"before = `{before['label']}` · after = `{after['label']}`", "",
          "| item | before | after |", "|---|---|---|"]
    md += [f"| {k} | {b} | {a} |" for k, b, a in rows]
    md += ["", f"## New loan documents after `{after['label']}` ({len(new_documents)})", ""] + (new_lines or ["- (none)"])
    md += ["", "## latest_result (after)", "", "```", str(after["booking"]["latest_result"]), "```", ""]
    path = os.path.join(_output_dir(), f"{case_id}_summary.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(md))

    esc = lambda v: str(v).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    html = ['<table border="1" cellpadding="4" style="border-collapse:collapse">',
            "<tr><th>item</th><th>before</th><th>after</th></tr>"]
    html += [f"<tr><td>{esc(k)}</td><td>{esc(b)}</td><td><b>{esc(a)}</b></td></tr>" for k, b, a in rows]
    html.append("</table>")
    html.append("<p>new documents:<br>" + "<br>".join(esc(x) for x in new_lines or ["(none)"]) + "</p>")
    html.append(f'<p><a href="evidence/{case_id}_summary.md">evidence/{case_id}_summary.md</a></p>')
    logger.info("".join(html), html=True)
    return path
