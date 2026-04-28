# Permission Policy (Minimal Team-3 Model)

เป้าหมาย: ทุกคนในทีมแก้ไฟล์ร่วมกันได้โดยไม่ต้อง chmod 777 และให้สิทธิ์สืบทอดอย่างถูกต้องด้วย group + setgid + umask

## 1) ทำไมต้องใช้ group + setgid + umask
- **Group เดียวกัน** ทำให้ไฟล์ที่สร้างใหม่เป็นของทีมทันที (ไม่ล็อกให้คนเดียว)
- **setgid (2775) ที่โฟลเดอร์** บังคับให้ไฟล์/โฟลเดอร์ใหม่สืบทอด group อัตโนมัติ
- **umask 0002** ทำให้ไฟล์ใหม่เป็น 664 และโฟลเดอร์ใหม่เป็น 775 ตามมาตรฐานทีม

## 2) กติกาห้ามทำ
- ห้าม `chmod 777` ทั้ง repo หรือโฟลเดอร์ร่วม
- ห้ามแก้ไขโฟลเดอร์ `*_LOCKED_BACKUP` และ `docs/99_ARCHIVE`
- ห้ามใช้ `sudo` แบบไม่รู้ผล (ให้ตรวจ owner/group/perms ก่อนเสมอ)

## 3) ตาราง mapping สิทธิ์มาตรฐาน

| ประเภท | สิทธิ์ที่ต้องได้ | หมายเหตุ |
| --- | --- | --- |
| โฟลเดอร์ร่วมแก้ไข | `2775` | setgid เพื่อสืบทอด group |
| ไฟล์ร่วมแก้ไข | `664` | อ่าน/เขียนได้ทั้ง owner+group |
| `_LOCKED_BACKUP` / `99_ARCHIVE` | `555` (dir) / `444` (file) | read-only |

## 4) แก้ปัญหา Permission denied (ขั้นตอนสั้น)
1) ตรวจ owner/group/perms ก่อน  
2) ถ้า group ไม่ใช่ `workreport` → แก้ group  
3) ถ้าโฟลเดอร์ไม่มี setgid → ตั้ง `2775`  
4) ถ้า umask ไม่ใช่ `0002` → ตั้งใหม่  

คำสั่งตรวจ:
```bash
id
umask
ls -ld .
```

## 5) สิ่งที่ Owner ทำไปแล้ว (ห้ามทำซ้ำ)
1) สร้าง group: `sudo groupadd workreport`  
2) เพิ่ม user poramet: `sudo usermod -aG workreport poramet`  
3) รีเฟรช session: `newgrp workreport`  
4) ตรวจสอบ: `groups` มี workreport และ `getent group workreport` = `workreport:x:1002:poramet`  

## 6) สคริปต์ permission-setup-minimal.sh ทำอะไรบ้าง
- หา REPO_ROOT จากตำแหน่งปัจจุบัน (ต้องพบ `00_CONTEXT_POINTER.md`)  
- ตั้ง group ของ `docs/` และ `tools/` เป็น `workreport`  
- ตั้งโฟลเดอร์ร่วมแก้ไขเป็น `2775` (setgid)  
- ตั้งไฟล์เป็น `664` แต่คง executable ที่จำเป็นไว้ (ไม่ลบ x)  
- ล็อก `*_LOCKED_BACKUP` และ `docs/99_ARCHIVE` เป็น read-only  
- ตั้ง `umask 0002` เฉพาะ session นี้ และแสดงผล verify  

## 7) Command Pack (Copy-Paste)

### B1) Setup group + add users
```bash
# สร้าง group สำหรับทีม
sudo groupadd workreport

# เพิ่มผู้ใช้เข้า group (แทน USER1 USER2 USER3)
sudo usermod -aG workreport USER1
sudo usermod -aG workreport USER2
sudo usermod -aG workreport USER3

# ตรวจสอบสมาชิก group
getent group workreport
```

### B2) Normalize repo permissions (ปลอดภัย: dry-run ก่อน)
```bash
# หา root ของ repo จากโฟลเดอร์ปัจจุบัน
REPO_ROOT="$(pwd)"
while [ "$REPO_ROOT" != "/" ] && [ ! -f "$REPO_ROOT/00_CONTEXT_POINTER.md" ]; do
  REPO_ROOT="$(dirname "$REPO_ROOT")"
done
echo "REPO_ROOT=$REPO_ROOT"

# DRY-RUN: แสดงรายการที่จะเปลี่ยน group/perms (ไม่แก้จริง)
find "$REPO_ROOT/docs" "$REPO_ROOT/tools" -type d -print
find "$REPO_ROOT/docs" "$REPO_ROOT/tools" -type f -print

# ตั้ง group ให้เป็น workreport ในโฟลเดอร์ร่วมแก้ไข
sudo chgrp -R workreport "$REPO_ROOT/docs" "$REPO_ROOT/tools"

# ตั้ง setgid ให้โฟลเดอร์ร่วมแก้ไข
find "$REPO_ROOT/docs" "$REPO_ROOT/tools" -type d -exec chmod 2775 {} +

# ตั้งสิทธิ์ไฟล์ร่วมแก้ไขเป็น 664
find "$REPO_ROOT/docs" "$REPO_ROOT/tools" -type f -exec chmod 664 {} +

# ตั้ง umask ให้ผู้ใช้ทีม (เฉพาะ session นี้)
umask 0002
```

### B3) Lock โฟลเดอร์ที่ไม่ควรถูกแก้
```bash
# ล็อกโฟลเดอร์ backup/archive ให้ read-only
find "$REPO_ROOT/docs" -type d -name "*_LOCKED_BACKUP" -exec chmod 555 {} +
find "$REPO_ROOT/docs" -type f -path "*/_LOCKED_BACKUP/*" -exec chmod 444 {} +

if [ -d "$REPO_ROOT/docs/99_ARCHIVE" ]; then
  find "$REPO_ROOT/docs/99_ARCHIVE" -type d -exec chmod 555 {} +
  find "$REPO_ROOT/docs/99_ARCHIVE" -type f -exec chmod 444 {} +
fi
```

## Verify หลังรันเสร็จ
```bash
# เช็ค group และสิทธิ์ของโฟลเดอร์หลัก
ls -ld "$REPO_ROOT/docs" "$REPO_ROOT/tools"

# เช็ค setgid (ต้องขึ้น s ใน permission)
find "$REPO_ROOT/docs" "$REPO_ROOT/tools" -type d -maxdepth 2 -exec ls -ld {} +

# เช็ค umask
umask

# เช็คตัวอย่างไฟล์ใหม่ว่ากลุ่มสืบทอดถูกต้อง
touch "$REPO_ROOT/docs/_perm_test.txt"
ls -l "$REPO_ROOT/docs/_perm_test.txt"
rm -f "$REPO_ROOT/docs/_perm_test.txt"
```

## Troubleshooting (Permission denied)
1) ดู owner/group/perms ของ path ที่มีปัญหา: `ls -ld <path>`  
2) ถ้า group ไม่ใช่ `workreport` → `sudo chgrp -R workreport <path>`  
3) ถ้าโฟลเดอร์ไม่มี setgid → `chmod 2775 <dir>`  
4) หลีกเลี่ยง 777; แก้ด้วย group + setgid + umask เท่านั้น  

## Preflight Checklist (ก่อนเริ่มงานทุกครั้ง)
1) `id` เห็นว่าอยู่ group `workreport` แล้ว  
2) `umask` ต้องเป็น `0002`  
3) `pwd` อยู่ใน repo ที่มี `00_CONTEXT_POINTER.md`  
4) `ls -ld docs` เห็น group เป็น `workreport`  
5) โฟลเดอร์ร่วมแก้ไขมี `s` (setgid) ใน permission  
6) ไฟล์ใหม่ใน `docs/` ต้องได้ `-rw-rw-r--` (664)  
7) โฟลเดอร์ใหม่ใน `docs/` ต้องได้ `drwxrwsr-x` (2775)  
8) ห้ามแก้ `*_LOCKED_BACKUP` และ `docs/99_ARCHIVE`  
9) ถ้าเจอ Permission denied ให้ตรวจ owner/group/perms ก่อนใช้ sudo  
10) หากต้องสลับเครื่อง/ผู้ใช้ ให้ตรวจ group และ umask ซ้ำ
