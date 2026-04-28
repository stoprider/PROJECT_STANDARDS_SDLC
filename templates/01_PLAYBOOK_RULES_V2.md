# **Playbook**

> **เอกสารนี้คือ "แหล่งข้อมูลความจริง (Source of Truth)" ที่กำหนดกรอบการทำงาน, บทบาท, กฎ, และระเบียบปฏิบัติในการพัฒนาซอฟต์แวร์ร่วมกับ AI**

## **เป้าหมายโครงการ (Project Goals)**
- **การนำไปใช้งานได้จริง (Viable Implementation):** พัฒนาระบบ WorkReport ให้สามารถทำงานได้จริงตามความต้องการทางธุรกิจที่กำหนดไว้
- **ความพร้อมสำหรับอนาคตที่ขับเคลื่อนด้วย AI (AI-Ready Foundation):** สร้างและจัดระเบียบโค้ด, เอกสาร, และข้อมูลทั้งหมดของโครงการ ให้มีโครงสร้างและคุณภาพสูงพอที่ AI จะสามารถเข้ามาเรียนรู้, บำรุงรักษา, และต่อยอดพัฒนาในอนาคตได้อย่างยั่งยืน

## **ปรัชญาหลัก (Core Philosophy)**

> **AI ไม่ใช่โปรแกรมเมอร์ แต่ AI คือส่วนประกอบหนึ่งในระบบที่ถูกควบคุม**

กรอบการทำงานนี้ตั้งอยู่บนสมมติฐานที่ว่า:
- AI มีความสามารถสูง แต่ก็ผิดพลาดได้
- ระบบซอฟต์แวร์จะมีอายุยืนยาวกว่าเครื่องมือหรือโมเดล AI ที่ใช้สร้างมันขึ้นมา
- ทุกการตัดสินใจที่สำคัญต้องสามารถตรวจสอบย้อนกลับได้

ดังนั้น ปรัชญาในระยะยาวของเราคือ:
> **การควบคุม (Control) > ความเร็ว (Speed)**

---

## **1. การแบ่งบทบาท (Role Separation Model)**

### **1.1 บทบาทของมนุษย์ (Human Roles)**

| บทบาท | หน้าที่ความรับผิดชอบ |
| :--- | :--- |
| **Owner / ผู้ตัดสินใจสูงสุด** | เป็นผู้ทำการตัดสินใจสุดท้ายในประเด็นที่มีความเสี่ยง, ขอบเขตงาน, หรือข้อมูลที่ละเอียดอ่อน |
| **Reviewer (ผู้ตรวจสอบ - ถ้ามี)** | ทำหน้าที่ตรวจสอบความถูกต้องของงานที่เป็นอิสระ |

### **1.2 บทบาทของ AI (AI Assistant Role)**

### **1.2.1 กรณีใช้ AI ระบบเดียว (Single-AI Mode)**

โดยมีหน้าที่คลอบคลุม 3 มิติดังนี้:

1.  **ผู้วางแผนและที่ปรึกษา (Planner & Consultant):**
    *   วิเคราะห์โจทย์และแบ่งงานเป็นขั้นตอนย่อย
    *   **ให้คำปรึกษาเชิงเทคนิค** เพื่อให้งานสอดคล้องกับ Requirement และมีประสิทธิภาพสูงสุด (Performance/Efficiency)
    *   ชี้ประเด็นความเสี่ยงหรือแนวทางที่ดีกว่า (Best Practice)
    *   ตรวจสอบความถูกต้องของแผนก่อนลงมือทำ (Pre-check)

2.  **ผู้ปฏิบัติการ (Executor):**
    *   สร้างไฟล์ แก้ไขโค้ด และรันคำสั่งตามแผนที่ได้รับอนุมัติ
    *   รายงานผลการทำงานและข้อผิดพลาดอย่างตรงไปตรงมา

3.  **ผู้ตรวจสอบ (Verifier):**
    *   ตรวจสอบผลลัพธ์เทียบกับสิ่งที่ตกลงไว้ (Verification)
    *   บันทึก Log และอัปเดตสถานะงานให้เป็นปัจจุบัน

**ข้อห้ามเด็ดขาดของ AI:**
*   ห้ามตัดสินใจเชิงนโยบายหรือ Business Logic แทน Owner
*   ห้าม "สรุปว่างานเสร็จ" โดยไม่มีหลักฐานยืนยัน
*   ห้ามแก้ไขสเปกโดยพลการโดยไม่ผ่าน Decision Gate
*   **ห้ามคิดแทน (No Overthinking/Assumption):** ห้ามตัดสินใจเลือกทางเลือกที่ "ปลอดภัยกว่า" หรือ "เปลี่ยนค่า" เอง หากคำสั่งของผู้ใช้มีความกำกวมหรือดูเหมือนจะเป็นไปไม่ได้ทางเทคนิค ต้องแจ้งข้อกังวลและสอบถามเพื่อยืนยันก่อนเสมอ

### **1.2.2 กรณีใช้ AI 2 ระบบ (Dual-AI Mode)**
#### **1) AI-Advisor (ที่ปรึกษา)**
หน้าที่:
- วิเคราะห์เป้าหมาย/ข้อจำกัด
- แตกงานเป็นขั้นตอน
- ตรวจความสอดคล้องของ BRIEF/SPEC/Decision ก่อนเริ่มทำ
- ระบุจุดตัดสินใจ (Decision Gate) ให้ Owner ยืนยัน
- จัดทำ “ชุดคำสั่งปฏิบัติ” หลังได้รับอนุมัติแล้วเท่านั้น
- ตรวจสอบรายงานจาก AI-Executor และตรวจสอบ บันทึก  `05_ACTION_LOG_V2.md`  `03_PROJECT_ROADMAP_V2.md`, `04_WORK_LOG_V2.md`**และ  `06_DECISION_LOG_V2.md`, `08_KNOWLEDGE_HUB_V2.md` (หากมีการสร้างคู่มือหรือสเปคใหม่)**  

ข้อห้าม:
- ห้ามลงมือแก้โค้ดหรือแก้ไฟล์ production โดยตรง (ยกเว้น Owner สั่งชัดเจนให้ทำบทบาท Executor)
- ห้ามสรุปว่า “ตัดสินใจแล้ว” หากยังไม่ผ่าน Decision Gate
- ห้ามข้ามการตรวจ Spec Conflict / Tech Drift

#### **2) AI-Executor (ผู้ปฏิบัติ)**
หน้าที่:
- ทำงานตามชุดคำสั่งที่อนุมัติแล้วเท่านั้น
- แสดงหลักฐานการทำงานทุกครั้ง (ไฟล์ที่แก้, diff, log, test)
- หยุดทันทีเมื่อพบความเสี่ยงหรือความขัดแย้งสเปก และส่งกลับให้ Advisor/Owner ตัดสินใจ
- ต้องรับคำสั่งที่มีเวลาอ้างอิงชัดเจนทุกครั้ง: `Request Timestamp (ISO8601 + Timezone)` อยู่ในหัว Prompt
- ต้องรายงานข้อมูลรอบรันทุกครั้ง: `Executor Model`, `Execution Runtime`, `Report Timestamp (ISO8601 + Timezone)`
- บันทึกและอัปเดตสถานะ (Final Record & Status Update): `AI` ต้องบันทึกการทำงานที่เสร็จสิ้นลงใน `05_ACTION_LOG_V2.md` และอัปเดตสถานะใน `03_PROJECT_ROADMAP_V2.md`, `04_WORK_LOG_V2.md`, `06_DECISION_LOG_V2.md`, `08_KNOWLEDGE_HUB_V2.md` (หากมีการสร้างคู่มือหรือสเปคใหม่)

**รูปแบบรายงานผล (Report Format — บังคับ):**
- รายงานต้องอยู่ใน **code block เดียว** เพื่อให้คัดลอกส่งต่อได้ง่าย ประกอบด้วย:
  0. Metadata: `PATCH ID`, `Request Timestamp`, `Executor Model`, `Execution Runtime`, `Report Timestamp`
  1. ตาราง Step | Action | Result ครบทุก step ที่ระบุใน Prompt
  2. ไฟล์ที่แก้ไข (path ครบ)
  3. ผลการ Verify ท้ายสุด (syntax check / curl test / DB query ตามที่ Prompt กำหนด)
  4. Documentation Sync (Required): ระบุผลอัปเดต `03/04/05/06/08` ชัดเจน
- **ห้ามรายงานสำเร็จโดยไม่มี Verify evidence** แม้ขั้นตอนอื่นจะผ่านแล้ว

Template (ใช้เป็นแบบ):
```text
✅ <TASK-ID> Complete
PATCH ID: <PATCH-ID>
Request Timestamp: <ISO8601+TZ>
Executor Model: <provider/model/version>
Execution Runtime: <local/cloud + toolchain>
Report Timestamp: <ISO8601+TZ>

| Step | Action | Result |
|------|--------|--------|
| 0A   | ...    | ✅ ... |
| 1    | ...    | ✅ ... |

ไฟล์ที่แก้ไข:
1. path/to/file.js — สรุปการเปลี่ยนแปลง

Verify:
- syntax check: PASS
- <curl/DB test>: <ผลลัพธ์จริง>

Documentation Sync (Required):
- 03_PROJECT_ROADMAP_V2.md: <updated/not-updated + reason>
- 04_WORK_LOG_V2.md: <updated/not-updated + reason>
- 05_ACTION_LOG_V2.md: <updated/not-updated + reason>
- 06_DECISION_LOG_V2.md: <updated/not-updated + reason>
- 08_KNOWLEDGE_HUB_V2.md: <updated/not-updated + reason>
```

ข้อห้าม:
- ห้ามขยาย scope เอง
- ห้ามแก้สเปก/นโยบายเอง
- ห้ามประกาศงานเสร็จโดยไม่มีหลักฐาน

#### **1.2.4 Design/Plan Challenge Rule (สิทธิ์โต้แย้งเชิงเทคนิค)**
- หากคำสั่งขัดกับแผนที่อนุมัติ, หลักวิศวกรรมซอฟต์แวร์ที่ดี, หรือมีความเสี่ยง regression/data safety ให้ AI-Executor **หยุดก่อนลงมือ**
- ต้องส่งรายงานโต้แย้งกลับในรูปแบบขั้นต่ำ:
  1. `Conflict Point`
  2. `Why It's Risky`
  3. `Evidence` (ไฟล์/โค้ด/ข้อมูลที่อ้างอิง)
  4. `Proposed Alternatives` (อย่างน้อย A/B พร้อม trade-off)
  5. `Recommendation`
  6. `Decision Needed`
- ห้ามเดินหน้าต่อเองเมื่อ conflict ระดับ High จนกว่า Owner จะตัดสินใจ

### **1.2.3 กติกางานเอกสาร vs โค้ด**
- **งานเอกสาร (Documentation):** AI สามารถเพิ่ม/แก้ไขเอกสารได้โดยตรงเมื่อได้รับคำสั่งจาก Owner
- **งานโค้ด (Code Changes):** AI สามารถลงมือแก้ไขโค้ดได้โดยตรงเมื่อได้รับคำสั่งจาก Owner โดยไม่ต้องใช้ Prompt-First; ยังคงต้องผ่าน Verification Gate

## กติกาเปลี่ยนบทบาท
- ค่าเริ่มต้น: ใช้บทบาท `AI-Advisor`
- จะเปลี่ยนเป็น `AI-Executor` ได้เมื่อ Owner สั่งชัดว่า “ให้ลงมือทำ”
- เมื่อจบรอบปฏิบัติ ให้กลับสู่ `AI-Advisor` เพื่อสรุปผลและเปิด Decision Gate ถัดไป
- ทุกครั้งที่เริ่มรอบงาน AI ต้องประกาศโหมดที่ใช้งาน (`Mode: Advisor` หรือ `Mode: Executor`) ให้ชัดเจน
- ต้องบันทึกโหมดที่ใช้งานลง `05_ACTION_LOG_V2.md` ทุกครั้งที่มีการเริ่มรอบปฏิบัติหรือเปลี่ยนโหมด
#### **3) นโยบายการลงมือทำงานโดยตรง (Direct Execution Policy)**
- มีผลตั้งแต่ `2026-03-02` เป็นต้นไป: **ยกเลิกกติกา Prompt-First**
- เมื่อ Owner สั่งงานชัดเจน ให้ AI ลงมือแก้ไข/รันงานได้ทันที
- ยังต้องคงหลักควบคุมเดิม:
  1. ไม่ขยาย scope เอง
  2. หาก requirement กำกวมและเสี่ยงผลกระทบ ให้ถามยืนยันก่อน
  3. ต้องส่งหลักฐานการตรวจสอบผล (Verification Evidence) ทุกครั้ง

#### **4) การจัดการเมื่อฝ่าฝืน (Violation Handling)**
- เมื่อ AI เผลอแก้ไฟล์/รันคำสั่ง State-change โดยไม่มีคำสั่ง Owner ที่ชัดเจน หรือทำงานเกิน scope ที่ได้รับ:
  1. **หยุดงานทันที** (Stop Work)
  2. รายงานเหตุการณ์:
     - Root Cause (ทำไมถึงทำ?)
     - รายการไฟล์ที่ถูกแก้ไข (List of Modified Files)
     - ผลกระทบที่อาจเกิดขึ้น (Impact Analysis)
  3. เสนอแผนแก้ไข (Remediation Plan):
     - Rollback กลับไปจุดก่อนแก้
     - หรือ Reconcile ถ้าแก้ไขไปแล้วใช้งานได้ดี (ต้องให้ Owner เลือก)

### **1.3 ปรัชญาการสื่อสาร (Communication Philosophy)**
- **เน้นเจตจำนง (Intent-First):** เพื่อลดแรงเสียดทานในการทำงาน โครงการนี้เน้นการเข้าใจ "เจตจำนง" ของผู้ใช้เป็นอันดับแรก โดย AI สามารถตีความบริบทภาษา/คำสะกด (เช่น Voice-to-Text) เพื่อเข้าใจความหมายเบื้องต้นได้
- **ขอบเขตของการตีความ (No Requirement Assumption):** AI ห้ามตีความจนเปลี่ยน Requirement, นโยบาย, หรือผลลัพธ์ทางธุรกิจเอง หากมีความกำกวมหรือเสี่ยงกระทบสาระสำคัญ ต้องถามยืนยันกับ Owner ก่อนเสมอ
- **กติกาการส่ง Prompt (Prompt Protocol):**
  - Prompt เป็นเพียงตัวเลือกเมื่อ Owner ร้องขอให้ส่ง prompt เท่านั้น
  - ค่าเริ่มต้นคือ AI ลงมือทำงานจริงและรายงานผลพร้อมหลักฐาน
  - **Executor Prompt ต้องอยู่ใน code block เดียวทั้งหมด** — ห้ามแยกเป็นหลาย block เพื่อให้ก๊อปปี้ส่ง Executor ได้ทีเดียว
- **กติกาการทำงานร่วมกับ antigravity (Antigravity Workflow):**
  - ใช้เฉพาะเมื่อ Owner ระบุให้ใช้ antigravity ในงานนั้น
  - หากไม่ระบุ ให้ทำงานแบบ direct execution ตามนโยบายหลัก
- **กติกาการแก้ไขเอกสาร (Documentation Editing):**
  - Owner อนุมัติให้ AI แก้ไขเอกสารได้โดยตรงเมื่อมีคำสั่งชัดเจน
  - งานเอกสารยังต้องบันทึกหลักฐานการแก้ไขตาม Evidence Rule

---

## **2. การตั้งค่าและกระบวนการทำงาน (Setup & Control Loop)**

### **2.1 โครงสร้างเอกสาร (Document Structure)**
โปรเจกต์นี้มีโครงสร้างเอกสารที่ชัดเจนเพื่อใช้ติดตามงานและบริบท
- **ดูรายชื่อและหน้าที่ของไฟล์ทั้งหมดได้ที่:** `00_CONTEXT_POINTER_V2.md`
- **Data Migration (ระบบเก่า → ระบบใหม่):**
  - Entry point: `docs/00_OWNER_INTENT/DATA_MIGRATION/PLAYBOOK.md`
  - Field mapping: `docs/00_OWNER_INTENT/DATA_MAPPING/`
  - Export how-to: `Test_Data/IMPORT_INSTRUCTIONS.md`


### **2.2 กระบวนการทำงาน (Control Loop)**

ลำดับการทำงานจะต้องเป็นไปตามนี้เสมอ:
1. **เริ่มต้น (Initiation):** Owner มอบหมายเป้าหมาย และ `AI` บันทึกเป้าหมายลงใน `05_ACTION_LOG_V2.md`
2. **วิเคราะห์และวางแผน (Analysis & Planning):** `AI` วิเคราะห์ปัญหา, เสนอทางเลือก, และสร้าง "ชุดคำสั่ง" (Command Set)
3. **นำเสนอและบันทึกแผน (Proposal & Recording):** `AI` ต้องบันทึกแผนที่เสนอ (Proposed Plan) และชุดคำสั่งลงในไฟล์ที่เกี่ยวข้อง (เช่น `04_WORK_LOG_V2.md`) เพื่อให้ `Owner` มีข้อมูลสำหรับใช้ตัดสินใจ
4. **รอการตัดสินใจ (Decision Gate):** `Owner` ตรวจสอบแผนที่ถูกบันทึกไว้และตัดสินใจเลือกแนวทาง
5. **ปฏิบัติการ (Execution):** `AI` ทำตาม "ชุดคำสั่ง" ที่ได้รับอนุมัติไปปฏิบัติ
   - หากพบ "Spec Conflict / Tech Drift" ระหว่างปฏิบัติ: ต้องหยุดและรายงานหลักฐานทันที เพื่อให้ `Owner` เปิด Decision Gate ใหม่
6. **ตรวจสอบ (Verification):** **(Mandatory Output Verification Policy)**
   - เมื่อได้รับรายงานจาก AI-Executor, Advisor ต้องตรวจผลจริงก่อนสรุป
   - **การตรวจขั้นต่ำต้องมี:**
     1. ตรวจไฟล์จริงว่ามีการเปลี่ยนตามรายงาน (File Content Check)
     2. ตรวจจุดเสี่ยง regression ในโค้ดที่เกี่ยวข้อง (Regression Check)
     3. ตรวจคำสั่งยืนยันที่จำเป็น เช่น syntax check หรือ test run (Validation)
   - **ห้ามประกาศ PASS หากยังไม่ผ่านการตรวจจริง**
   - หากรายงานไม่ตรงไฟล์จริง ต้องระบุสถานะเป็น “ผ่านบางส่วน/ไม่ผ่าน” พร้อมหลักฐาน
7. **บันทึกและอัปเดตสถานะ (Final Record & Status Update):** `AI` ต้องบันทึกการทำงานที่เสร็จสิ้นลงใน `05_ACTION_LOG_V2.md` และอัปเดตสถานะใน `03_PROJECT_ROADMAP_V2.md`, `04_WORK_LOG_V2.md`**และ  `06_DECISION_LOG_V2.md`, `08_KNOWLEDGE_HUB_V2.md` (หากมีการสร้างคู่มือหรือสเปคใหม่)** พร้อมแนบหลักฐาน จากนั้นจึงรายงานให้ `Owner` ทราบ พร้อมอ้างอิงว่าไฟล์ดังกล่าวได้รับการอัปเดตแล้ว

### **2.3 การจัดการข้อยกเว้น (Exception Handling)**
- กรณีเร่งด่วนที่ Owner สั่งข้ามกติกา ต้องมีข้อความอนุมัติชัดเจนในแชท
- ต้องบันทึกเหตุผลการข้ามกติกาไว้ใน Action Log อย่างชัดเจน

### **2.4 Checklist สำหรับควบคุมคุณภาพ (Quality Governance)**
- [ ] Scope and requirement confirmed? (ยืนยันขอบเขตและ requirement ก่อนลงมือหรือไม่)
- [ ] Executor output verified against real files? (ตรวจไฟล์จริงเทียบกับรายงานหรือไม่)
- [ ] Verification commands reviewed? (รันคำสั่งตรวจสอบ Syntax/Test หรือไม่)
- [ ] PASS/FAIL decision evidence attached? (มีหลักฐานประกอบการตัดสินใจหรือไม่)

### **2.5 Port Policy (Hard Rule)**
- โครงการนี้กำหนดให้พอร์ตของโมดูลงานพัฒนาอยู่ในช่วง `>= 9000` เท่านั้น

#### Canonical Entry Path
- **nginx (80/443) → Smart Proxy 9080** คือเส้นทางเข้าระบบมาตรฐานเดียว (canonical entry path)
- ทุก public traffic ต้องผ่าน nginx → 9080 → backend service เท่านั้น
- **พอร์ต 9082 = non-canonical / temporary** — ห้ามใช้เป็นมาตรฐาน ห้ามอ้างอิงใน contract/routing ใหม่ หากพบการใช้งานให้ถือเป็น tech debt ที่ต้อง migrate กลับไปผ่าน 9080

#### Service Port Registry (Canonical)
| Module | Port | Type |
|--------|------|------|
| Auth Service | 9000 | Authentication API |
| Quotations API | 9016 | API |
| Quotations UI | 9017 | UI |
| Revenue-Expense | 9018 | API + UI |
| Static File Server | 9031 | Static |
| Directory Listing | 9032 | Static |
| Performance Eval | 9033 | API + UI |
| Master Data API | 9040 | API (read-only) |
| MyTask Service | 9041 | API + UI |
| Approvals Service | 9042 | API + UI |
| Dashboard Service | 9043 | UI |
| Time Clock Service | 9044 | API + UI |
| My Clients Service | 9045 | UI |
| Reports Service | 9046 | API + UI |
| Settings Service | 9047 | API + UI |
| Smart Proxy | 9080 | Reverse Proxy (canonical entry) |

- สำหรับโมดูล `S-3.6.7-01 Revenue/Expense` ให้ยึดค่ามาตรฐาน:
  - `UI = 9031`
  - `API = 9018`
- สำหรับโมดูล `MASTER-DATA-01 Master Data API`:
  - `API = 9040` (read-only, no auth)
- สำหรับโมดูล `MASTER-DATA-03 Observable Fallback`:
  - Finance UI badge `#masterStatusBadge`: MASTER OK (green) / MASTER FALLBACK (amber)
  - `masterDataMetrics` in-memory metrics; `classifyMasterError()` for reason classification
- ห้าม AI เปิดพอร์ตใหม่เองโดยไม่ผ่าน Decision Gate
- หากพบพอร์ตต่ำกว่า 9000 ที่ไม่ใช่ process ของโมดูล ให้บันทึกเป็นข้อมูลแวดล้อมและห้ามนำมาอ้างเป็นพอร์ตใช้งานโมดูล
- รายละเอียด port/route ทั้งหมดอ้างอิงจาก `docs/09_API_PORT_REGISTRY_V1.md` (Source of Truth)
- มาตรฐานตรวจ runtime/availability อ้างอิงจาก `docs/27_RUNTIME_PORT_AVAILABILITY_STANDARD_V1.md`

### **2.6 Verification Gate (Advisor Mandatory)**
- ทุกครั้งที่ AI-Executor ส่งรายงานว่า "เสร็จแล้ว" AI-Advisor ต้องตรวจจริงก่อนสรุปผล
- เกณฑ์ตรวจขั้นต่ำแบบบังคับ:
  1. ตรวจไฟล์จริงตรงกับที่รายงาน (line-level evidence)
  2. รันคำสั่งยืนยันผลจริง (เช่น `ss`, `curl`, `node --check`, หรือ test ที่เกี่ยวข้อง)
  3. สรุปผลแบบ `PASS/FAIL` พร้อมเหตุผลสั้นและหลักฐาน
  4. ตรวจหัวรายงานว่าระบุ `Executor Model`, `Execution Runtime`, `Report Timestamp (ISO8601)` ครบ
- ห้ามข้าม Gate นี้แม้งานจะเป็นงานเล็ก
- หากพบรายงานคลาดเคลื่อน ให้สถานะเป็น `FAIL` หรือ `Partial PASS` และสั่งแก้รอบเดียวแบบเจาะจุด

### **2.6.1 Asset Source Consistency Gate (Hard Rule)**
- ใช้กับทุกงานที่แตะ UI, shared components, proxy/static routing
- เกณฑ์ผ่านขั้นต่ำ:
  1. ระบุ `Canonical Asset Paths` ของโมดูลที่แก้ (HTML/CSS/JS runtime)
  2. แนบ `Asset Source Matrix` ยืนยันว่าไฟล์ runtime มาจาก source เดียวตามที่ประกาศ
  3. แนบหลักฐาน `curl` (status/header/content marker) ว่า route เสิร์ฟไฟล์ถูกตัว
  4. แนบ grep proof ว่าไม่มี legacy/non-canonical path ในไฟล์ runtime
- หากพบ asset source ผสม (เช่น app + prototype conflict) ให้ตัดสินเป็น `FAIL` ทันที จนกว่าจะแก้ครบ

### **2.6.2 Font Source Consistency Gate (Hard Rule)**
- ใช้กับทุกงานที่แตะ typography/shared UI
- นโยบายกลาง:
  1. ใช้ฟอนต์แบบ **self-host** จาก shared source เท่านั้น
  2. ห้ามพึ่ง Google Fonts CDN ในหน้าโมดูล production
  3. ให้โหลดผ่าน `theme.css` + token กลาง (`--wr-font-family`, `--wr-font-family-base`)
- เกณฑ์ผ่านขั้นต่ำ:
  1. มีหลักฐานว่าแต่ละโมดูลโหลด `theme.css` จริง
  2. มีหลักฐานว่าไม่มี `<link fonts.googleapis.com>` ค้างในหน้าหลักของโมดูล
  3. มี computed-font proof (อย่างน้อย B1 selectors หลัก) ว่าตรง SoT
  4. มี grep proof ว่า B1 ไม่ใช้ `--wr-font-family-mono`

### **2.6.3 C1 Filter Row Migration Gate (Hard Rule)**
- ใช้กับทุกงานที่แตะ C1 (แถวค้นหา/ตัวกรอง/column toggle) ในโมดูลใดก็ตาม
- มาตรฐานอ้างอิง: `docs/20_UI_SHARED_BUSINESS_MAPPING_V1.md` §7 (C1 Shared Contract)
- เกณฑ์ผ่านขั้นต่ำ:
  1. มี `[data-c1]` marker บน container กลาง
  2. มี `[data-c1-search]`, `[data-c1-filters]`, `[data-c1-date]`, `[data-c1-columns]`, `[data-c1-reset]` ตามที่เมนูมีจริง
  3. มี event dispatch: `c1:change`, `c1:reset`, `c1:columns-change` พร้อม payload ตาม schema
  4. Grep proof: ไม่มี C1 structure ใหม่ที่ไม่มี `[data-c1]` marker
  5. ไม่มี custom event ที่ชื่อขัดกับ frozen contract (`c1:change`, `c1:reset`, `c1:columns-change`)
- หากพบ C1 element ที่ไม่มี marker กลาง ให้ตัดสินเป็น `FAIL` จนกว่าจะแก้ครบ

### **2.6.4 Desktop-Only UI Rule (Hard Rule)**
- ค่าเริ่มต้นของงาน UI ในโปรเจกต์นี้คือ **Desktop Only**
- หาก Owner ไม่ได้สั่งชัดเจนว่าให้รองรับ mobile/tablet:
  1. ไม่ต้องออกแบบ/ปรับ responsive behavior เพิ่ม
  2. ไม่ต้องเพิ่ม media query ใหม่เพื่อรองรับจอเล็ก
  3. ให้โฟกัสความถูกต้องของ layout บน desktop เป็นหลัก
- หากมีคำสั่งใหม่ให้รองรับ responsive ในบางงาน ให้ถือว่าเป็นข้อยกเว้นเฉพาะงานนั้น และต้องระบุใน Decision Gate

### **2.7 Evidence Number Integrity (Hard Rule)**
- **Raw evidence immutable:** ห้ามแก้/ลบ/ทับไฟล์ดิบใน `test-results/` เพื่อให้ตัวเลขสวยขึ้น
- ตัวเลขสรุปใน `03/04/06/08` ต้องอ้างอิงจากไฟล์ดิบเท่านั้น (เช่น smoke CSV/report ที่สร้างในรอบนั้น)
- หากพบตัวเลขไม่ตรงกันระหว่าง report กับ CSV:
  1. ห้ามแก้ไฟล์ดิบเดิม
  2. แก้เฉพาะชั้นเอกสารสรุปให้ตรงไฟล์ดิบ **หรือ** rerun แล้วสร้างไฟล์หลักฐานใหม่คนละ timestamp
  3. ระบุในเอกสารว่าใช้ไฟล์ใดเป็น source of truth
- Advisor ต้องทำ number reconciliation ขั้นต่ำก่อนประกาศ PASS:
  - ตรวจจำนวน PASS/FAIL จากไฟล์ดิบ
  - ตรวจความสอดคล้องของตัวเลขใน Roadmap/Work Log/Decision/Knowledge Hub

### **2.8 Performance Guardrails (Hard Rule)**
- เป้าหมายเชิงนโยบาย: **ความเร็ววันแรกต้องไม่ถดถอยเมื่อใช้งานระยะยาว 3-5 ปี**
- กฎบังคับสำหรับทุกโมดูลที่มีหน้า List/ตาราง:
  1. **ห้ามโหลดข้อมูลทั้งหมดใน Initial Load** (ห้ามใช้ `page_size` เกิน 200 ในเส้นทางหน้าแรก)
  2. **ต้องใช้ Server-side Pagination** (ห้ามโหลดทั้งก้อนแล้วแบ่งหน้าในฝั่ง UI)
  3. **ข้อมูลสัมพันธ์ขนาดใหญ่** (เช่น activities/history/files) ต้องโหลดแบบ Lazy เมื่อเปิด Detail เท่านั้น
  4. **ทุก endpoint ต้องมีขีดจำกัดทรัพยากร**: pagination cap, timeout, และ response-size budget
  5. **ห้ามใช้ fallback ที่ดึงทั้ง dataset** ใน production path
  6. **ต้องมีดัชนี (Index) ตามคอลัมน์กรอง/เรียงที่ใช้งานจริง**
- Definition of Done ด้านประสิทธิภาพ (ขั้นต่ำ):
  - หน้าแรกไม่เรียก endpoint ที่ส่งข้อมูลระดับหลาย MB โดยไม่จำเป็น
  - API list ทุกตัวรองรับ `page`, `page_size`, และค่า default ไม่เกิน 100
  - มีหลักฐาน smoke/perf check แนบใน `test-results/` ก่อนสรุป PASS

### **2.8.1 Performance Decision Gate (5-Question Rule)**
- ใช้กับทุกงานที่แตะ list loading / pagination / search / filters
- AI-Executor ต้องตอบ 5 คำถามนี้ให้ชัดก่อนสรุป PASS:
  1. **Scalability:** ถ้าข้อมูลสะสมระดับ 500k แถว ยังเร็วตาม SLA หรือมีแผนย้ายจาก OFFSET ไป keyset/cursor เมื่อถึง trigger?
  2. **Single Action = Single Request:** การเปลี่ยน page/filter/search ยิง request เดียวจริง และไม่มี double-fetch จากหลายจุด UI?
  3. **Count Strategy:** ถ้า `COUNT(*)` ช้า มี fallback อะไร (has_next / cached count / separate count endpoint)?
  4. **N+1 Safety:** list table ไม่มี per-row API call และ detail โหลดแบบ lazy-load เท่านั้น?
  5. **Before/After Evidence:** มี metric ก่อน-หลังอย่างน้อย render/search/page-switch หรือไม่?
- หากตอบข้อใดไม่ได้พร้อมหลักฐาน ให้ตัดสินเป็น `Partial PASS` หรือ `FAIL`

### **2.8.2 State Contract for Server-Driven List (Hard Rule)**
- ทุกโมดูลที่เป็น server-driven ต้องมี state กลางเดียว:
  - `{ page, page_size, sort_by, sort_dir, query, filters }`
- ทุก action UI ต้องแก้ state กลางก่อน และ trigger fetch ผ่านจุดเดียว
- ห้ามหลาย handler ยิง fetch ซ้ำจาก event เดียว (เช่น top pagination + footer)
- ฝั่ง server ต้องใช้ **stable ordering** เสมอ:
  - `ORDER BY <business_sort>, <stable_tie_breaker>` (เช่น `id`)

### **2.8.3 Trigger-Based Roadmap (1Y/3Y/5Y)**
- เอกสารนี้ถือเป็น policy กลาง และต้องถูกใช้ร่วมกับ metric runtime จริง
- Trigger ขั้นต่ำที่ต้องติดตาม:
  1. ปริมาณข้อมูลรวม/โมดูล
  2. p95 list latency
  3. p95 search/filter latency
  4. concurrent users ช่วงพีค
- เมื่อเกิน threshold ที่กำหนดในรอบนั้น ต้องเปิด Decision Gate เพื่อยกระดับสถาปัตย์ทันที
  - ตัวอย่าง: OFFSET -> keyset/cursor, count strategy fallback, query/index tuning

### **2.8.4 Evidence Format (Mandatory)**
- รายงาน performance ทุกครั้งต้องมี:
  1. `Scope` (โมดูล/endpoint/หน้าที่วัด)
  2. `Dataset Context` (จำนวนแถวโดยประมาณ)
  3. `Before/After` metric table
  4. `Risk & Fallback Plan` (offset/count/N+1)
  5. `PASS/FAIL` พร้อมเหตุผล
- ห้ามสรุปว่าเร็วขึ้นจากความรู้สึกโดยไม่มีตัวเลขขั้นต่ำตามข้อ 2.8.1(5)

---
