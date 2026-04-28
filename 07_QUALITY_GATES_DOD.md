# **Definition of Done (DoD) & Quality Gates**

เอกสารนี้ใช้เป็น Checklist สำหรับ **Project Director** ในการตรวจสอบและอนุมัติงาน (GATE) ในแต่ละขั้นตอน

---

## **Phase 2: Requirements (Gate 1)**
*ต้องผ่านเกณฑ์เหล่านี้ก่อนเริ่มเขียนโค้ด:*
- [ ] มีไฟล์ `docs/SPEC_SLICE_X.md` ครบถ้วน
- [ ] มี DB Schema ที่ระบุ Data Type และ Constraints ชัดเจน
- [ ] มี API Contract (Input/Output) ครบทุก Endpoint
- [ ] AI ยืนยันว่า "ไม่มีส่วนใดกระทบ Module เดิม" (หรือระบุจุดที่กระทบและวิธีแก้ไว้แล้ว)
- [ ] **Director Action:** พิมพ์ "APPROVE SPEC"

## **Phase 4: Development (Gate 2)**
*ต้องผ่านเกณฑ์เหล่านี้ก่อนส่งงานเข้าสู่การทดสอบ:*
- [ ] โค้ดทุกบรรทัดต้องไม่มี Syntax Error (`node --check` ผ่าน)
- [ ] มีการบันทึก `05_ACTION_LOG_V2.md` พร้อม PATCH ID ทุกครั้งที่มีการแก้ไข
- [ ] ไม่มีการ Hardcode ข้อมูลสำคัญ (เช่น Password, API Key)
- [ ] มี Comment อธิบาย Logic ที่ซับซ้อนในโค้ด
- [ ] **AI Action:** บันทึกหลักฐาน Syntax Check ลงใน Action Log

## **Phase 5: Verification & QA (Gate 3 - Final Gate)**
*ต้องผ่านเกณฑ์เหล่านี้ก่อนเปลี่ยนสถานะ Slice เป็น DONE:*
- [ ] ผลการทดสอบใน `test-results/` ต้องเป็น `PASS` 100%
- [ ] มี Evidence ที่มองเห็นได้ (เช่น Screenshot หรือ Logs การทำงานจริง)
- [ ] ทดสอบ Edge Cases แล้ว (เช่น การส่งค่าว่าง, ค่าผิดประเภท)
- [ ] **Director Action:** ตรวจสอบไฟล์ผลทดสอบและหลักฐานจริงก่อนเปลี่ยนสถานะ Roadmap

---
> [!IMPORTANT]
> **กฎเหล็ก:** หากไม่ครบ Checklist แม้แต่ข้อเดียว ให้ "สั่งกลับไปทำใหม่" (Reject) ทันที ห้ามปล่อยผ่าน
