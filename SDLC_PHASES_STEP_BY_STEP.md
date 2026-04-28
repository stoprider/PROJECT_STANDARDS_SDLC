# **SDLC Master Action Plan (คู่มือปฏิบัติการพร้อมชุดคำสั่ง)**

คู่มือนี้บอกสิ่งที่ "Project Director" ต้องทำ และชุดคำสั่งที่ต้องใช้ "สั่ง AI" ในแต่ละก้าว

---

## **Phase 1: Planning (การหั่นชิ้นงานและตั้งกฎ)**
*จุดประสงค์: เพื่อไม่ให้ AI ทำงานสะเปะสะปะและคุมขอบเขตโครงการได้ตั้งแต่ต้น*

1.  **AI Calibration:** เปิดแชทใหม่ คัดลอกข้อความด้านล่างนี้ไปสั่ง AI
    > **Prompt:** "คุณคือ AI Coding Assistant ของฉัน โปรดอ่านไฟล์ `PROJECT_STANDARDS_SDLC/README.md` และ `STANDARD_DEVELOPMENT_GUIDE_V1.md` เพื่อรับทราบกติกาการทำงานทั้งหมด และยืนยันความเข้าใจเรื่อง Evidence Rule ก่อนที่เราจะเริ่มวางแผน Roadmap ใน `03_PROJECT_ROADMAP_V2.md` ร่วมกัน"
2.  **Owner Intent:** สร้างไฟล์ `docs/00_OWNER_INTENT.md` เขียนสิ่งที่คุณอยากเห็นในภาษาคน
3.  **Roadmap Slicing:** สั่ง AI ให้แบ่งงานเป็นชิ้น (Slices)
    > **Prompt:** "ช่วยหั่นงานจาก Owner Intent ใน `docs/00_OWNER_INTENT.md` เป็น 3-5 Slices ที่ส่งมอบได้จริงลงใน `03_PROJECT_ROADMAP_V2.md` โดยระบุ Objective และ Status เป็น TODO"

---

## **Phase 2: Requirements (การทำพิมพ์เขียว)**
*จุดประสงค์: ตกลงเรื่อง Logic และหน้าตาก่อนเขียนโค้ด เพื่อลดการแก้ภายหลัง*

1.  **Advisor Deep Dive:** สั่ง AI ร่าง Spec สำหรับชิ้นงานที่จะทำ
    > **Prompt:** "ฉันกำลังจะเริ่มทำ [ชื่อ Slice] ในโหมด Advisor ช่วยวิเคราะห์และร่าง Implementation Spec ลงในไฟล์ `docs/SPEC_[ชื่อ Slice].md` โดยให้ครอบคลุมถึง DB Schema, API Contract และ UI Logic พร้อมระบุความเสี่ยงที่อาจกระทบ Module อื่นด้วย"
2.  **Director Checkpoint:** เมื่อ AI ร่างเสร็จ ให้คุณตรวจ Spec ตามเกณฑ์ใน **`07_QUALITY_GATES_DOD.md`** แล้วพิมพ์: **"APPROVE SPEC"**

---

## **Phase 4: Development (การลงมือสร้าง)**
*จุดประสงค์: เขียนโค้ดที่มีประวัติการแก้ไขที่ชัดเจนและสืบค้นได้*

1.  **Executor Implementation:** สั่ง AI ให้เริ่มลงมือเขียนโค้ดตาม Spec
    > **Prompt:** "เริ่มทำงานตาม Spec ใน `docs/SPEC_[ชื่อ Slice].md` ในโหมด Executor โดยปฏิบัติตามกติกาการบันทึก `05_ACTION_LOG_V2.md` และขอ Evidence ยืนยันผลการทำงานทุกลูป ห้ามข้ามขั้นตอนการตรวจ Syntax และ Logic"
2.  **Iteration Check:** คอยดูใน Action Log ว่า AI บันทึก PATCH ID หรือยัง

---

## **Phase 5: Verification & QA (การหาหลักฐานยืนยัน)**
*จุดประสงค์: ห้ามเชื่อคำพูด AI ให้เชื่อหลักฐาน (Evidence) เท่านั้น*

1.  **Request Evidence:** สั่ง AI ให้พิสูจน์ว่างานที่ทำเสร็จนั้น "ใช้งานได้จริง"
    > **Prompt:** "สร้างไฟล์ Smoke Test ในรูปแบบ CSV ลงในโฟลเดอร์ `test-results/` เพื่อพิสูจน์ว่า Logic และ UI ใน Slice นี้ทำงานได้ถูกต้อง 100% ตามที่อ้างไว้ใน Action Log และสรุปผล PASS/FAIL มาให้ฉันดูด้วย"
2.  **Visual Evidence:** หากเป็นงาน UI ให้ AI บันทึก Screenshot หรือระบุขั้นตอนการคลิกเพื่อพิสูจน์
3.  **Director Checkpoint:** ตรวจสอบไฟล์ผลทดสอบและหลักฐานจริงตามเกณฑ์ **`07_QUALITY_GATES_DOD.md (Gate 3)`** ก่อนเปลี่ยนสถานะ Roadmap

---

## **Phase 6: Delivery & Maintenance (การปิดงานและเก็บความรู้)**
*จุดประสงค์: เพื่อให้โครงการถัดไปหรืองานถัดไปเริ่มได้ง่ายขึ้น*

1.  **Knowledge Sync:** สั่ง AI ให้บันทึกความรู้ที่ได้จากการทำงานชิ้นนี้
    > **Prompt:** "สรุปเทคนิคการแก้ปัญหาหรือจุดที่ควรระวังจากการทำงานในวันนี้ลงใน `08_KNOWLEDGE_HUB_V2.md` และอัปเดตสถานะใน Roadmap ให้เป็น DONE พร้อมสรุป Next Steps สำหรับการทำงานครั้งถัดไป"
