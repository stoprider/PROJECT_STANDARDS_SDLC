# **AI Prompts Library (คลังคำสั่งสำหรับสั่งงาน AI)**

คัดลอกชุดคำสั่งเหล่านี้ไปใช้ในแต่ละ Phase เพื่อให้ AI ทำงานได้แม่นยำตามมาตรฐาน SDLC v1.0

---

## **Phase 1: เริ่มต้นโครงการ (Initialization)**
*ใช้เมื่อ: เปิดแชทใหม่ หรือเริ่มโปรเจกต์ใหม่*

> [!TIP]
> **Prompt:** "คุณคือ AI Coding Assistant ของฉัน โปรดอ่านไฟล์ `PROJECT_STANDARDS_SDLC/README.md` และ `STANDARD_DEVELOPMENT_GUIDE_V1.md` เพื่อรับทราบกติกาการทำงานทั้งหมด และยืนยันความเข้าใจเรื่อง Evidence Rule ก่อนที่เราจะเริ่มวางแผน Roadmap ใน `03_PROJECT_ROADMAP_V2.md` ร่วมกัน"

---

## **Phase 2: วางแผนรายชิ้นงาน (Advisor Spec)**
*ใช้เมื่อ: จะเริ่มทำฟีเจอร์ใหม่ (New Slice)*

> [!TIP]
> **Prompt:** "ฉันกำลังจะเริ่มทำ [ระบุชื่อ Slice] ในโหมด Advisor ช่วยวิเคราะห์และร่าง Implementation Spec ลงในไฟล์ `docs/SPEC_[ชื่อ Slice].md` โดยให้ครอบคลุมถึง DB Schema, API Contract และ UI Logic พร้อมระบุความเสี่ยงที่อาจกระทบ Module อื่นด้วย"

---

## **Phase 4: สั่งลุยงาน (Executor Implementation)**
*ใช้เมื่อ: Spec อนุมัติแล้วและพร้อมเขียนโค้ด*

> [!TIP]
> **Prompt:** "เริ่มทำงานตาม Spec ใน `docs/SPEC_[ชื่อ Slice].md` ในโหมด Executor โดยปฏิบัติตามกติกาการบันทึก `05_ACTION_LOG_V2.md` และขอ Evidence ยืนยันผลการทำงานทุกลูป ห้ามข้ามขั้นตอนการตรวจ Syntax และ Logic"

---

## **Phase 5: ขอหลักฐานการตรวจงาน (QA & Evidence)**
*ใช้เมื่อ: AI บอกว่าทำเสร็จแล้ว*

> [!TIP]
> **Prompt:** "สร้างไฟล์ Smoke Test ในรูปแบบ CSV ลงในโฟลเดอร์ `test-results/` เพื่อพิสูจน์ว่า Logic และ UI ใน Slice นี้ทำงานได้ถูกต้อง 100% ตามที่อ้างไว้ใน Action Log และสรุปผล PASS/FAIL มาให้ฉันดูด้วย"

---

## **Phase 6: สรุปความรู้และปิดงาน (Knowledge Sync)**
*ใช้เมื่อ: จบงานในแต่ละวัน หรือจบ Slice*

> [!TIP]
> **Prompt:** "สรุปเทคนิคการแก้ปัญหาหรือจุดที่ควรระวังจากการทำงานในวันนี้ลงใน `08_KNOWLEDGE_HUB_V2.md` และอัปเดตสถานะใน Roadmap ให้เป็น DONE พร้อมสรุป Next Steps สำหรับการทำงานครั้งถัดไป"
