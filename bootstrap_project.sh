#!/bin/bash

# Project Scaffolding Script v1.0
# มาตรฐาน SDLC v1.0

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo "กรุณาระบุชื่อโปรเจกต์: ./bootstrap_project.sh [ProjectName]"
    exit 1
fi

echo "🚀 กำลังสร้างโครงสร้างโปรเจกต์: $PROJECT_NAME ตามมาตรฐาน SDLC v1.0..."

# 1. สร้างโฟลเดอร์
mkdir -p "$PROJECT_NAME/docs/00_OWNER_INTENT"
mkdir -p "$PROJECT_NAME/apps/_shared"
mkdir -p "$PROJECT_NAME/test-results"
mkdir -p "$PROJECT_NAME/shared/database/migrations"

# 2. คัดลอกเทมเพลตมาตรฐาน
STANDARDS_PATH="/workspace/Team-Workreport/PROJECT_STANDARDS_SDLC/templates"

cp "$STANDARDS_PATH/00_0_START_HERE.md" "$PROJECT_NAME/00_0_START_HERE.md"
cp "$STANDARDS_PATH/01_PLAYBOOK_RULES_V2.md" "$PROJECT_NAME/01_PLAYBOOK_RULES_V2.md"
cp "$STANDARDS_PATH/02_OWNER_GUIDE_V2.md" "$PROJECT_NAME/02_OWNER_GUIDE_V2.md"
cp "$STANDARDS_PATH/09_TEAM_GUIDE_V1.md" "$PROJECT_NAME/09_TEAM_GUIDE_V1.md"
cp "$STANDARDS_PATH/AGENTS.md" "$PROJECT_NAME/AGENTS.md"
cp "$STANDARDS_PATH/PERMISSION_POLICY.md" "$PROJECT_NAME/PERMISSION_POLICY.md"
cp "/workspace/Team-Workreport/PROJECT_STANDARDS_SDLC/07_QUALITY_GATES_DOD.md" "$PROJECT_NAME/07_QUALITY_GATES_DOD.md"
cp "/workspace/Team-Workreport/PROJECT_STANDARDS_SDLC/09_AI_TROUBLESHOOTING_GUIDE.md" "$PROJECT_NAME/09_AI_TROUBLESHOOTING_GUIDE.md"

# 3. สร้างสมุดบันทึกเบื้องต้น
echo "# Roadmap: $PROJECT_NAME" > "$PROJECT_NAME/03_PROJECT_ROADMAP_V2.md"
echo "# Work Log: $PROJECT_NAME" > "$PROJECT_NAME/04_WORK_LOG_V2.md"
echo "# Action Log: $PROJECT_NAME" > "$PROJECT_NAME/05_ACTION_LOG_V2.md"
echo "# Knowledge Hub: $PROJECT_NAME" > "$PROJECT_NAME/08_KNOWLEDGE_HUB_V2.md"

# 4. สร้างไฟล์ความปลอดภัยเบื้องต้น
echo '{ "roles": ["admin", "employee"], "permissions": {} }' > "$PROJECT_NAME/apps/_shared/rbac-policy.json"

echo "✅ สร้างโปรเจกต์ $PROJECT_NAME เรียบร้อยแล้ว!"
echo "👉 ขั้นตอนต่อไป: บอก AI ให้ไปอ่าน 00_0_START_HERE.md ในโฟลเดอร์ใหม่เพื่อเริ่มงานครับ"
