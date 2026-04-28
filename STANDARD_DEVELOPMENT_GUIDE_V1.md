# **Standard Development Guide v1.0 (SDLC Blueprint)**

> **Objective:** มาตรฐานการพัฒนาซอฟต์แวร์ที่ออกแบบมาเพื่อการทำงานร่วมกับ AI (AI-Integrated SDLC) เน้นความปลอดภัย ความโปร่งใส และการควบคุมคุณภาพในทุกขั้นตอน

---

## **1. ภาพรวมวงจรการพัฒนา (SDLC Overview)**
เราแบ่งการพัฒนาเป็น 6 ระยะ โดยมี **Decision Gates** เป็นตัวควบคุม:
1. **Planning:** กำหนด Slice งานและ Roadmap
2. **Requirements:** จัดทำ Spec และ AI-Analysis
3. **Design & Security:** วางโครงสร้างสิทธิ์ (RBAC) และสถาปัตยกรรม
4. **Development:** การเขียนโค้ดตามมาตรฐาน AI-Executor
5. **Verification:** การตรวจสอบผล (Evidence Gate)
6. **Delivery & Maintenance:** การส่งมอบและบันทึกประวัติ (Action Log)

---

## **2. สถาปัตยกรรมและการควบคุมสิทธิ์ (Security & Architecture)**

### **2.1 หลักการ RBAC-First (Role-Based Access Control)**
*ความปลอดภัยต้องถูกออกแบบก่อนการเขียน Logic*
- **Source of Truth:** สิทธิ์ทั้งหมดต้องถูกนิยามในไฟล์เดียว (เช่น `rbac-policy.json`) ห้าม Hardcode สิทธิ์ในโค้ดของ Module
- **Least Privilege:** ทุก Route และ Action ต้องระบุ Role ที่เข้าถึงได้ชัดเจน
- **UI Safety Fallback:** หากระบบโหลดสิทธิ์ไม่สำเร็จ UI ต้อง Fallback ไปที่สิทธิ์ต่ำสุด (`employee`) เสมอ

### **2.2 นโยบายพอร์ตและบริการ (Port & Service Registry)**
- **Isolation:** แต่ละ Module (Micro-app) ต้องรันแยกพอร์ตกัน เพื่อลดแรงกระทบ (Blast Radius) หากเกิดข้อผิดพลาด
- **Registry:** ต้องบันทึกการใช้พอร์ตในเอกสารกลาง (Port Registry) เพื่อป้องกันการชนกันของ Service
- **Standard Port Range:** เริ่มต้นที่ 9000+ (เช่น `9041` สำหรับ MyTask, `9016` สำหรับ Quotations)

### **2.3 โครงสร้างข้อมูลและการแยกส่วน (Data-Logic Separation)**
- **Canonical Data:** ข้อมูลที่แชร์ข้าม Module ต้องมีโครงสร้างที่เป็นกลาง (Canonical)
- **Shadow Table Strategy:** สำหรับข้อมูลที่ต้องดึงจากระบบอื่น ให้ใช้ Shadow Table เพื่อป้องกันการแก้ข้อมูลต้นทางโดยไม่ตั้งใจ
- **Audit Trail:** ทุกการเปลี่ยนแปลงข้อมูลสำคัญ ต้องมี `updated_at` และ `updated_by` เสมอ

---

## **3. มาตรฐานการพัฒนา (Development Standards)**

### **3.1 AI-Collaborative Roles**
- **Advisor Mode:** ใช้เพื่อการวิเคราะห์, ออกแบบ Spec และตรวจสอบความเสี่ยง
- **Executor Mode:** ใช้เพื่อการลงมือทำตาม Spec ที่ผ่านการเห็นชอบแล้วเท่านั้น

### **3.2 Performance Guardrails**
- **Server-side Pagination:** ห้ามโหลดข้อมูลทั้ง Table มาที่ Client (จำกัด `page_size` เริ่มต้นที่ 100)
- **Lazy Loading:** ข้อมูลหนัก (History, Attachments) ให้โหลดเมื่อต้องการ (On-demand) เท่านั้น

---

## **4. กระบวนการตรวจงานและส่งมอบ (Verification & Delivery)**

### **4.1 Evidence Rule (กฎการบันทึกหลักฐาน)**
- ทุกการแก้ไขโค้ดต้องมีหลักฐานการตรวจสอบ (Evidence) เสมอ
- หลักฐานต้องระบุ: ไฟล์ที่เปลี่ยน, คำสั่งที่ใช้ทดสอบ, และผลลัพธ์ (PASS/FAIL)

### **4.2 Verification Gates**
- **Gate 1 (Syntax):** ตรวจสอบ Syntax เบื้องต้น (เช่น `node --check`)
- **Gate 2 (Logic):** ตรวจสอบ Business Logic ผ่าน Script ทดสอบ
- **Gate 3 (Integration):** ตรวจสอบการทำงานร่วมกับ Module อื่น

---

## **5. การจัดเก็บข้อมูลและประวัติ (Documentation & Audit)**
- **Action Log:** บันทึกทุกลมหายใจของการแก้ไข (Objective, Changes, Verify, Status)
- **Decision Log:** บันทึกเหตุผลเบื้องหลังการตัดสินใจเชิงสถาปัตยกรรม
- **Knowledge Hub:** เก็บเทคนิคที่แก้ปัญหาได้จริงเพื่อไม่ให้ AI ลืมในอนาคต
