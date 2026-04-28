# Owner Intent (Owner-guided)

> ไฟล์นี้คือ **Source of Truth** สำหรับวิธีทำงานแบบ Owner-guided ของโปรเจกต์นี้ (Layer 0, ขั้นตอน High level/Guards/Data Dictionary/Coverage และข้อห้าม)  
> กฎการปฏิบัติการ/รูปแบบการสั่งงาน/Permission ให้ยึด `Team-Workreport/01_PLAYBOOK_RULES.md` เป็นหลัก


> เอกสารฉบับนี้สรุปขั้นตอนการพัฒนาระบบตามที่ทีม Owner × AI ทำงานร่วมกันจริง
> ใช้เป็น playbook กลางสำหรับการพัฒนา การสื่อสาร และการต่อยอดในระยะยาว

---

## ภาพรวม (Executive Summary)

**หลักคิดเดียว:**

> เริ่มจากความคิดของผู้ใช้ → ทำให้เห็น → ทำให้ใช้ได้ → จัดข้อมูล → ใช้ข้อมูล → บันทึกการตัดสินใจระหว่างทาง

เอกสารนี้ไม่ได้เป็นทฤษฎีลอย ๆ แต่เป็นลำดับการทำงานที่ออกแบบมาเพื่อ:

- ลดการแก้ย้อน
- กันการหลุดบริบท (โดยเฉพาะเมื่อใช้ AI หลายตัว)
- ให้คนที่เข้ามาทีหลังเข้าใจระบบได้

---

## Interim Module Governance (Local-first)

สำหรับโมดูลที่แยกพัฒนาชั่วคราวเพื่อใช้งานก่อนระบบหลักเสร็จ (เช่น `S-3.6.7-01`) ให้ใช้แนวทางนี้:

- แยกสถานะเป็น `Interim` ชัดเจนในเอกสารทุกฉบับที่เกี่ยวข้อง
- ห้ามแก้ Requirement หลักของระบบรวม ให้บันทึกเป็น "Interim Override" พร้อมเหตุผลแทน
- บังคับมี Integration Note ทุกครั้งที่เปลี่ยน field mapping, role policy, หรือ port
- ปิดรอบงานแต่ละรอบด้วย Gate `PASS/FAIL + Evidence` ก่อนอนุมัติใช้งานจริง

กติกานี้ช่วยให้ใช้งานได้เร็วในระยะสั้น โดยไม่ทำให้เอกสารระบบหลักสับสนเมื่อถึงรอบรวมระบบ

---

## Prompt Governance (Dual-AI Quick Rule)

เมื่อต้องส่งงานให้ AI-Executor ให้เพิ่ม 2 กติกานี้ใน prompt เสมอ:

- **Execution Metadata (บังคับรายงาน):**
  - `Executor Model`
  - `Execution Runtime`
  - `Report Timestamp (ISO8601)`
- **Design/Plan Challenge Rule:**
  - ถ้าพบ conflict กับแผนที่อนุมัติ, best practice, หรือ data safety
  - ให้หยุดก่อนลงมือ และส่งรายงานโต้แย้งเป็นหัวข้อ:
    `Conflict Point / Why It's Risky / Evidence / Alternatives / Recommendation / Decision Needed`

ผลที่ต้องได้:
- ลดงานแก้ย้อนจากการทำผิดแผน
- ทำให้ Owner ตัดสินใจจากข้อมูลเชิงเทคนิคที่ตรวจสอบได้

---

## Menu Development Order (ลำดับพัฒนาเมนู — บังคับ)

> **ปัญหาที่เคยเกิด**: พัฒนา RevExp UI ก่อนโดยไม่มี Login/RBAC → ต้อง hardcode user list → แก้สิทธิ์ซ้ำ 5+ รอบ (storedRole, normalizeRole, USER_ID_ROLE_FALLBACK, canSeeTotals, view-as headers)

### กฎ: Infrastructure ก่อน Feature เสมอ

```
ลำดับที่ถูก:                         ลำดับที่ผิด (ที่เคยทำ):

1. Login + Auth Service              1. RevExp UI (ไม่มี login)
   ↓                                    ↓
2. RBAC Policy + Core                2. HARDCODED_FALLBACK_USERS
   ↓                                    ↓
3. Master Data (users/roles)         3. แก้ซ้ำ 5+ รอบ
   ↓                                    ↓
4. Shared UI Components              4. migrate C1 ทั้ง 4 เมนู
   ↓                                    ↓
5. Feature เมนู (RevExp, MyTask...)  5. ยังแก้อยู่...
```

### ลำดับบังคับ (Mandatory Build Order)

| ลำดับ | สิ่งที่ต้องทำ | ทำไมต้องก่อน |
|-------|-------------|-------------|
| **1** | **Login / Auth Service** | ถ้าไม่รู้ว่า "ใคร" login → ต้อง hardcode user → drift |
| **2** | **RBAC Policy (rbac-policy.json)** | ถ้าไม่มี policy กลาง → แต่ละเมนู hardcode สิทธิ์เอง → ขัดกัน |
| **3** | **RBAC Core (rbac-core.js)** | ถ้าไม่มี library กลาง → แต่ละเมนูเช็คสิทธิ์คนละแบบ |
| **4** | **Master Data Service** | ถ้าไม่มีรายชื่อ user จริง → switcher แสดง ID แทนชื่อ |
| **5** | **Shared UI Components** | ถ้าไม่ lock ก่อน → แต่ละเมนูสร้าง toolbar/pagination คนละ pattern |
| **6** | **Feature เมนู** | ตอนนี้มี infra พร้อม → เขียน feature ครั้งเดียวจบ |

### ห้ามทำเมนู Feature ก่อน Infrastructure

> ถ้ายังไม่มี Login + RBAC + Master Data → **ห้ามเริ่ม Phase 7 ของเมนู Feature**
>
> ทำ prototype (Phase 3) ได้ แต่ต้อง mock auth — และเมื่อถึง Phase 7 ต้องเปลี่ยนเป็น auth จริง ห้าม hardcode

### Lesson Learned จากโปรเจกต์นี้

| เหตุการณ์ | สาเหตุ | เสียเวลา |
|-----------|--------|----------|
| HARDCODED_FALLBACK_USERS ใน RevExp | ทำ UI ก่อน Login | แก้ 3 รอบ |
| storedRole is not defined | ไม่มี RBAC ตอนเขียน | hotfix 1 รอบ |
| normalizeRole("admin") → "accounting" | hardcode role map ขัด policy | แก้ 2 รอบ |
| C1 toolbar ไม่เหมือนกัน 4 เมนู | ไม่ lock shared component ก่อน | migrate ทั้ง 4 เมนู |
| Master Data 404 | ไม่มี Master Service ตอน dev | แก้ API base 2 รอบ |

---

## Phase Gate Rules (บังคับทุก Phase)

> **ปัญหาที่เคยเกิด**: กระโดดจาก wireframe ไป code โดยไม่สร้าง shared component ก่อน ทำให้ต้องย้อนกลับมา migrate ทั้ง 4 เมนู (C1, PageHeader, Shell)

### หลักการ: สร้าง component ที่ reuse ได้ **ก่อน** ขยายไปหลายเมนู

```
Phase 2 (Wireframe)
  └─ ระบุว่า "ส่วนไหนใช้ซ้ำข้ามเมนู" (toolbar, pagination, header, modal)
     ↓
Phase 3 (Prototype)
  └─ สร้าง shared component 1 ตัว → ทดสอบกับ 1 เมนูแรก
     ↓
Phase 3.5 (Component Lock)
  └─ ล็อก contract → ขยายไปเมนูอื่นๆ ที่เหลือ
     ↓
Phase 7 (Code)
  └─ เมนูใหม่ "ดึง" component มาใช้ ไม่สร้างใหม่
```

### Exit Criteria ของแต่ละ Phase

| Phase | จบเมื่อ | ใครอนุมัติ |
|-------|--------|-----------|
| 0 → 1 | Owner ยืนยันว่า requirement ครบ | Owner |
| 1 → 2 | High-level flow ผ่าน review | Owner |
| 2 → 3 | Wireframe ครบทุกเมนูที่จะทำ + **ระบุ reusable parts แล้ว** | Owner |
| 3 → 3.5 | UI prototype ทำงานได้กับ mock data | Owner |
| 3.5 → 4 | Shared components ล็อก contract แล้ว (ใช้ได้ข้ามเมนู) | Owner + Advisor |
| 4 → 5 | Data dictionary ตรวจ field ซ้ำ/ร่วมกันแล้ว | Advisor |
| 5 → 6 | Schema ตัดสินใจแล้ว | Advisor |
| 6 → 7 | **Before-Coding Checklist ผ่านครบ** (ดูด้านล่าง) | Owner + Advisor |

### Before-Coding Checklist (บังคับก่อนเริ่ม Phase 7)

> **ห้ามเริ่มเขียน code จริงถ้าข้อใดข้อหนึ่งยังไม่ผ่าน**

**Infrastructure (ต้องมีก่อนเมนูแรก):**
- [ ] Login / Auth Service ใช้งานได้ (ไม่ hardcode user)
- [ ] RBAC policy (rbac-policy.json) มีเมนู/สิทธิ์ที่ต้องใช้แล้ว
- [ ] RBAC Core library (rbac-core.js) ใช้ได้จาก UI + backend
- [ ] Master Data Service มี user list จริง (ไม่ต้อง hardcode ชื่อ)
- [ ] Shared UI components ล็อกแล้ว (C1, pagination, shell, header)

**Feature-specific (ต่อเมนู):**
- [ ] SPEC.md ผ่าน Owner review
- [ ] DB Schema ตรวจแล้ว (Phase 5-6 เสร็จ)
- [ ] API Contract เขียนแล้ว (endpoint + request/response shape)
- [ ] ไม่มี hardcoded role/permission ใน design → ใช้ WRAuth เป็นหลัก
- [ ] ระบุ canonical asset paths แล้ว (CSS/JS/HTML หลักมาจากที่ใด)

### Change Management Rule

> **ถ้าความต้องการเปลี่ยนหลังเริ่ม Phase 7:**

1. หยุด code
2. อัปเดต SPEC.md + Schema + API Contract ให้ตรงความต้องการใหม่
3. ตรวจว่า RBAC policy ยังถูกไหม
4. บันทึกใน DECISION_LOG ว่าเปลี่ยนอะไร + เหตุผล
5. ค่อยกลับมา code ต่อ

**ห้ามแก้ code แบบ "patch ทีละจุด" โดยไม่อัปเดตเอกสารก่อน** — นี่คือสาเหตุหลักของ drift

---

## Phase 0 — Requirement (เจตนาตั้งต้น)

**วัตถุประสงค์**\
บันทึกว่า *เราคิดอะไร* และ *อยากได้อะไร* ก่อนเริ่มโครงการ

**สิ่งที่ทำ**

- เขียนความต้องการเชิงธุรกิจ
- อธิบาย flow การใช้งานของผู้ใช้
- อธิบาย feeling / เจตนา
- ยังไม่สนข้อจำกัดทางเทคนิค

**สิ่งที่ได้**

- Requirement หมายถึง ไฟล์ WorkReport2025-251124.md

**หมายเหตุสำคัญ**

- Requirement ไม่ควรถูกแก้ทับง่าย ๆ
- ถ้ามีการเปลี่ยนแปลง ให้ใช้ reference ไปยัง Division แทน

---

## Phase 1 — High Level (โครงเมนู / Flow)
 
**วัตถุประสงค์**\
แปลง requirement เป็นโครงสร้างการทำงานของระบบ

**สิ่งที่ทำ (ต่อเมนู)**

- เมนูนี้คืออะไร
- ผู้ใช้ทำอะไรได้บ้าง (flow หลัก)
- ไม่ลง UI
- ไม่ลงรายละเอียดข้อมูลเชิงลึก

**สิ่งที่ได้**

- High-level ต่อเมนู (1–2 หน้า)

---

## Phase 2 — Wireframe (เห็นภาพ)

**วัตถุประสงค์**\
ทำให้คนทุกฝ่ายเห็นภาพตรงกัน

**สิ่งที่ทำ**

- วาดโครงหน้าจอ
- ระบุองค์ประกอบหลักเมนู ข้อความที่แสดงในเมนูนั้นทั้งหมด (ตาราง / ปุ่ม / ช่องกรอก)
- ยังไม่ต้องสวย
- ยังไม่ต้องมี logic
- **ทำ Reuse Map** — ระบุส่วนที่ซ้ำกันข้ามเมนู เช่น "toolbar ของเมนู A กับ B เหมือนกัน"

**สิ่งที่ได้**

- Wireframe ครบทุกเมนู
- **Reuse Map** — รายการส่วนที่ใช้ซ้ำ (เช่น: toolbar, filter row, pagination, page header, sidebar)

---

## Phase 3 — UI Mockup + Guards

**วัตถุประสงค์**\
เห็นฟิลลิ่ง + action โดยไม่ผูก backend

**สิ่งที่ทำ**

- ทำ UI ที่กดแล้วเหมือนใช้งานได้
- ใช้ mock data / ข้อมูลแทน
- เขียน Guards ระบุขอบเขตการทำงานของ AI / ทีม
- **ระบุ "ส่วนที่ใช้ซ้ำ" (Reusable Parts)** — toolbar, filter, pagination, modal, header ที่จะใช้ข้ามเมนู

**Guards ตัวอย่าง**

- ยังไม่สร้าง logic ซับซ้อน
- ยังไม่ผูก database จริง
- โฟกัสที่พฤติกรรมผู้ใช้

**Reuse Identification Rule (บังคับ)**

> ก่อนจบ Phase 3 ต้องตอบคำถามนี้:
> 1. ส่วนไหนของหน้านี้ใช้ซ้ำในเมนูอื่นด้วย?
> 2. ส่วนนั้นควรเป็น shared component หรือ copy-paste?
> 3. ถ้าเป็น shared → ย้ายไปทำใน Phase 3.5 ก่อนขยาย
>
> **ถ้าข้ามขั้นตอนนี้** = ต้องกลับมา migrate ทีหลัง (เสียเวลา 2-3 เท่า)

---

## Phase 3.5 — UI Component Baseline (ก่อนลงลึก Data/Schema)

**วัตถุประสงค์**\
ล็อกมาตรฐาน UI กลางให้ทุกเมนูใช้แนวเดียวกัน ลดงานซ้ำ และลดการแก้ย้อนเมื่อขยายระบบ

**สิ่งที่ทำ**

- ล็อก `Core Components = 9 ตัว` (ชิ้น UI ที่ reuse โดยตรง)
- ล็อก `Standards = 13 จุด` โดยคิดจาก `9 Core Components + 4 Contracts`
- อ้างอิงเอกสารกลาง: `docs/10_WORKFLOW_STANDARDS/UI_COMPONENT_STANDARD_V1.md`
- ล็อกที่เก็บคอมโพเนนท์กลาง (production-ready source): `apps/_shared/ui-components/v1/`
- ให้ prototype ใช้ mirror ที่ `docs/05_PROTOTYPE_LAYOUTS/components/` ผ่านสคริปต์ `scripts/sync_ui_components.sh`
- ผูก pointer เข้า Knowledge/Standards Index เพื่อให้ทีมและ AI หาเจอจากทางเข้าเดียว

**นิยามให้ชัด (กันสับสน)**

- `9 จุด` = คอมโพแนนท์กลาง (เช่น Button, FormField, ModalShell, DataTableShell)
- `13 จุด` = มาตรฐานทั้งหมดที่ต้องกำหนดในรอบนี้ (`9 Components + 4 Contracts`)

**Contracts 4 หมวด (ขั้นต่ำ)**

- Modal Behavior Contract
- FormField Contract
- Table Interaction Contract
- Evidence+OCR / Permission UI Contract

**Gate ก่อนเข้า Phase 7**

- งาน UI ใหม่ต้องตรวจ `UI_COMPONENT_STANDARD_V1` ก่อนเริ่ม implement
- ถ้าต้องใช้ pattern ใหม่ ให้เพิ่มกลับเข้ามาตรฐานก่อน แล้วจึงนำไปใช้ในเมนู
- ถ้าแก้คอมโพเนนท์กลาง ให้แก้ที่ `apps/_shared/ui-components/v1/` แล้วค่อย sync ไป prototype

### Asset Source of Truth (Hard Rule)

> บังคับใช้กับทุกเมนูที่อยู่ใต้ `/workreport/*`

1. Runtime ต่อ 1 โมดูลต้องมี **asset source เดียว** (ห้ามผสม app/prototype จนเกิด behavior ต่างกัน)
2. ต้องประกาศ **canonical asset paths** ของโมดูลนั้นในเอกสารรอบงานทุกครั้ง (HTML/CSS/JS หลัก)
3. ห้ามใช้ path fallback ที่ไม่ใช่ canonical ใน production route
4. ถ้าต้องใช้ mirror/prototype ให้เป็น read-only reference หรือ sync ทั้งชุดก่อนปล่อย
5. ถ้าตรวจพบ source ผสม ต้องถือเป็น `Spec Conflict` และเปิด Decision Gate ใหม่ทันที

**Verification Gate เพิ่มเติม (บังคับ)**

- ทุก patch ที่แตะ UI shared ต้องแนบ `Asset Source Matrix` (ไฟล์ที่ถูกเสิร์ฟจริงมาจากที่ใด)
- ต้องยืนยัน runtime ด้วย `curl`/headers/content markers ว่าไฟล์ที่เสิร์ฟตรง canonical paths
- ต้องมี grep check ว่าไม่มี legacy path ที่ห้ามใช้ในไฟล์ runtime

### Font Source of Truth (Owner Rule)

เพื่อกันปัญหาฟอนต์ไม่ตรงกันข้ามเมนู ให้ยึดกติกานี้:

1. ฟอนต์ระบบให้ใช้ `Noto Sans Thai Looped` (fallback: `Noto Sans Thai`) เป็นมาตรฐานกลาง
2. ใช้ฟอนต์แบบ self-host เท่านั้น (ไฟล์อยู่ใน shared components)
3. ห้ามพึ่ง Google Fonts CDN ในหน้าโมดูล production
4. หากหน้าใดฟอนต์เพี้ยน ให้ตรวจตามลำดับ:
   - หน้าโหลด `theme.css` หรือไม่
   - path runtime มาจาก canonical source หรือไม่
   - มี local override `font-family` ทับ shared หรือไม่

### ลำดับบังคับ: Login → RBAC Core → Master Data Admin

> เพื่อลดความสับสนเรื่องสิทธิ์และการแสดงผลในช่วงพัฒนา ให้ยึดลำดับนี้ทุกครั้ง

1. **Login Identity ก่อน**
   - ต้องมีตัวตนผู้ใช้จากระบบล็อกอินก่อน (`user_id`, `role`)
   - ห้ามบังคับ RBAC แบบจริงจังถ้ายังไม่รู้ว่าใครล็อกอินอยู่

2. **RBAC Core กลาง**
   - เก็บ policy ที่ `apps/_shared/auth/rbac-policy.json`
   - เก็บ logic กลางที่ `apps/_shared/auth/rbac-core.js`
   - ห้าม hardcode policy ซ้ำในเมนูรายตัว

3. **UI Shared Adoption**
   - ให้เมนู/เฮดเดอร์อ่านสิทธิ์ผ่าน RBAC core เดียว
   - ทำทีละเมนู พร้อม verification gate ทุกครั้ง

4. **Master Data เป็นช่องทางบริหาร**
   - ใช้ Master Data เป็นหน้า admin สำหรับแก้ policy ในอนาคต
   - แต่ source of truth ยังเป็น RBAC policy กลางเสมอ

**ข้อห้าม**
- ห้าม migrate หลายเมนูก่อนที่ shared component และ RBAC core จะนิ่ง
- ห้ามปิดงาน PASS จากโค้ดอย่างเดียว ต้องยืนยันผล runtime จริง

---

## Phase 4 — Data Dictionary

**วัตถุประสงค์**\
เห็นข้อมูลที่ระบบใช้จริงจากหลายเมนู

**สิ่งที่ทำ**

- รวม field จากทุกเมนู
- ตรวจสอบ field ที่ซ้ำ / ใช้ร่วมกัน
- ระบุ field ที่ยังไม่มีข้อมูล

**สิ่งที่ได้**

- Data Dictionary กลาง

**Shared Database Foundation (DB-FOUNDATION-01)**

> สร้างโครงฐานข้อมูลกลางสำหรับรวม legacy + mapping + core แบบขนาน โดยไม่กระทบระบบเดิม

- เอกสารหลัก: `apps/_shared/database/README.md`
- โมเดลข้อมูล 4 โซน: `apps/_shared/database/contracts/DATA_DOMAIN_MODEL_V1.md`
- กฎการตั้งชื่อ: `apps/_shared/database/contracts/NAMING_CONVENTION_V1.md`
- บัญชีข้อมูล legacy: `apps/_shared/database/inventory/LEGACY_SOURCE_INVENTORY_V1.md`
- แผนนำเข้า: `apps/_shared/database/runbooks/IMPORT_PLAYBOOK_V1.md`
- แผน cutover: `apps/_shared/database/runbooks/CUTOVER_STRATEGY_V1.md`

---

## Phase 5 — Schema (หัวตาราง)

**วัตถุประสงค์**\
ตัดสินใจโครงสร้างข้อมูล

**สิ่งที่ทำ**

- จัดกลุ่มข้อมูลจาก Data Dictionary
- ตัดสินใจว่าข้อมูลใดเป็นเรื่องเดียวกัน

**สิ่งที่ได้**

- รายชื่อหัวตาราง (เชิงแนวคิด)

---

## Phase 6 — ERD (ความสัมพันธ์ข้อมูล)

**วัตถุประสงค์**\
เห็นภาพรวมข้อมูลทั้งระบบ

**สิ่งที่ทำ**

- วาดความสัมพันธ์ระหว่างหัวตาราง
- ตรวจสอบการเชื่อมข้ามเมนู

**สิ่งที่ได้**

- พิมพ์เขียวของ database

---

## Phase 7 — Backend / Frontend จริง

**วัตถุประสงค์**\
พัฒนาโดยไม่เดา

**สิ่งที่ทำ**

- สร้าง database จริง
- พัฒนา API
- เชื่อม UI กับข้อมูลจริง
- ใช้คอมโพแนนท์จากมาตรฐานกลางเป็นค่าเริ่มต้น (ห้าม hardcode ซ้ำโดยไม่อ้างอิงมาตรฐาน)

---

## Phase 8 — Dashboard & Report

**วัตถุประสงค์**\
ใช้ข้อมูลเพื่อการตัดสินใจ

**แนวคิดหลัก**

- Dashboard = ภาพรวม + การสะท้อน
- Report = วิเคราะห์เชิงลึก / ย้อนหลัง
- AI ให้คำแนะนำ (ไม่ใช่คำสั่ง)
- กติกาอยู่ใน Master Data / Settings

---

## หลักการสรุป

- เอกสารทุกชิ้นต้องเชื่อมโยงกันด้วย reference
- ใช้ link ให้เป็นประโยชน์ของเอกสารดิจิทัล
- เป้าหมายคือความเข้าใจระยะยาว ไม่ใช่แค่ส่งงาน



---

## Phase 9 — Deploy to Cloud (Provider‑agnostic)

**วัตถุประสงค์**
นำระบบที่ “โค้ดจริงแล้ว” (หลัง Phase 6–8) ขึ้นสภาพแวดล้อม Cloud แบบควบคุมได้ โดยยังคงหลักการ **ไม่ยึดกับผู้ให้บริการรายใดรายหนึ่ง**

### 9.0 นิยามสำคัญ

* **Deploy** = build + release + config + migrate + verify + rollback‑ready
* **Staging** = สภาพแวดล้อมทดสอบที่ใกล้ production (แนะนำให้มี แม้เล็กมาก)
* **Production** = สภาพแวดล้อมใช้งานจริง
* **Runtime** = บริการรัน container แบบ managed (เช่น Cloud Run / ECS Fargate / Azure Container Apps)
* **Managed SQL** = Postgres/MySQL แบบ managed (เช่น Cloud SQL / RDS / Azure Database)

> **Mapping ตัวอย่าง (เพื่อความเข้าใจ):**
> Runtime = Cloud Run, Managed SQL = Cloud SQL (Postgres)

### 9.1 Preconditions (ต้องผ่านก่อนเริ่ม)

ต้องผ่านอย่างน้อย 8 ข้อนี้

1. Local run ผ่าน: UI + API + DB ใช้งานได้จริง
2. มี seed/mock ที่ทำให้ทีม “เห็นหน้าจอเหมือนจริง” ได้
3. Schema/Migration นิ่ง (มาจาก Phase 6 แล้ว)
4. API contract ของเมนูที่จะขึ้น cloud รอบนี้ “ไม่เปลี่ยนรายวัน”
5. แยก config ตาม environment ได้ (local/staging/prod)
6. ไม่มี secrets อยู่ใน repo
7. มี health check endpoint (อย่างน้อย `/health`)
8. มีแผน rollback ที่ “ทำได้จริง”

### 9.2 Target Architecture (ขั้นต่ำ, ย้ายข้าม cloud ได้)

* **Frontend**: Static hosting หรือ served by backend (เลือกแบบที่ง่ายสุดก่อน)
* **Backend API**: Containerized service (Runtime)
* **Database**: Managed SQL (แนะนำ Postgres สำหรับ production)
* **Logs/Monitoring**: Managed logging/metrics ของผู้ให้บริการ
* **Secrets**: Secret store ของผู้ให้บริการ (ห้าม hardcode)
* **Object Storage** (ถ้ามีไฟล์แนบ): S3‑compatible concept

### 9.3 หลักการ “Cloud‑portable” (บังคับใช้)

* ใช้ **Docker** เป็นหน่วย deploy หลัก
* ใช้หลัก **12‑Factor**: config ผ่าน env/secrets เท่านั้น
* หลีกเลี่ยงบริการเฉพาะค่ายใน v0/v1 (เช่น queue/event ที่ผูก vendor) ถ้าไม่จำเป็น
* Infrastructure นิยามแบบ **IaC** (Terraform/OpenTofu) เพื่อย้ายค่ายได้
* การ migrate DB ต้องเป็น **versioned & repeatable**

### 9.4 Release Units (หน่วยที่ถือว่า 1 รอบ deploy)

* **Unit A:** Backend image (มี version/tag)
* **Unit B:** Frontend artifact (มี version/tag)
* **Unit C:** DB migration (มี version)

กติกา: ทุก unit ต้องย้อนกลับได้ หรือมี forward‑only plan ที่ปลอดภัย

### 9.5 Deployment Steps (Vendor‑neutral)

1. เตรียม environment: `staging` และ `prod`
2. Build: สร้าง frontend + backend container image (tag version)
3. Push artifacts: ส่ง image ไป container registry (ของค่ายใดก็ได้)
4. Provision: สร้าง Runtime service + Managed SQL + secrets
5. Migrate DB: รัน migration (ต้อง idempotent หรือควบคุมเวอร์ชันชัด)
6. Smoke test: UI เปิดได้, flow หลักทำได้, pagination/search ไม่ค้าง, log ขึ้นระบบ
7. Sign‑off: บันทึก release note + อัปเดต CHECKLIST/WORK_TRACKER (✅/❌/🔜)

### 9.6 Acceptance Criteria (นิยามผ่านของ Phase 9)

Phase 9 “ผ่าน” เมื่อ

1. มี URL ที่ทีมเปิดใช้งานได้จริง
2. ทำ flow หลักอย่างน้อย 2 เมนูได้ครบ (เช่น 3.6.1 + 3.6.4)
3. seed/mock ทำให้เห็นตาราง+modal/action ได้
4. ใช้งานพร้อมกันระดับเล็กได้ (3–5 คน) โดยไม่ล่ม
5. debug ได้จาก log/metrics

### 9.7 Rollback Plan (ต้องทำได้จริง)

* Backend: rollback ไป image tag ก่อนหน้า
* Frontend: rollback ไป build ก่อนหน้า
* Config: revert env/secrets mapping
* DB: ใช้แนวทางใดแนวทางหนึ่ง

  * มี down migration หรือ
  * forward‑only แต่ปลอดภัย (เพิ่มก่อนลบ, ไม่ทำลายข้อมูลทันที)

### 9.8 Deliverables

* `docs/09_DEPLOY/DEPLOYMENT_GUIDE.md`
* `docs/09_DEPLOY/ENVIRONMENTS.md` (local/staging/prod)
* `docs/09_DEPLOY/RELEASE_NOTES.md` (append‑only)
* URL ของ staging/prod
* screenshot สำคัญ 3–5 ภาพ

### 9.9 AI‑safe Guardrails (กัน AI พา deploy มั่ว)

* AI ห้าม deploy ข้าม Preconditions
* AI ห้ามเสนอ infra เกิน scope (เช่น K8s) ถ้า Owner ไม่สั่ง
* คำสั่งที่กระทบ prod ต้องมี: plan + rollback note + ให้ Owner review ก่อน
