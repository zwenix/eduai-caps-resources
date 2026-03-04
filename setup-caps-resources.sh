#!/bin/bash

# =============================================================================
# EduBridge SA — CAPS Resources Repository Setup Script
# =============================================================================
# This script creates the full folder structure for the caps-resources repo.
# Usage:
#   1. Create a new GitHub repo called "caps-resources"
#   2. Clone it locally: git clone https://github.com/YOUR-ORG/caps-resources.git
#   3. cd caps-resources
#   4. Copy this script into the root of the repo
#   5. Run: bash setup-caps-resources.sh
# =============================================================================

set -e

echo ""
echo "=============================================="
echo "  EduBridge SA — CAPS Resource Repo Setup"
echo "=============================================="
echo ""

# ------------------------------------------------------------------------------
# HELPER FUNCTION
# Creates a directory and adds a .gitkeep so Git tracks empty folders
# ------------------------------------------------------------------------------
make_dir() {
  mkdir -p "$1"
  touch "$1/.gitkeep"
}

# ------------------------------------------------------------------------------
# FOUNDATION PHASE — Grade R, 1, 2, 3
# Subjects: Home Language, First Additional Language, Mathematics, Life Skills
# ------------------------------------------------------------------------------
echo "📘 Creating Foundation Phase folders (Grade R–3)..."

FOUNDATION_SUBJECTS=(
  "home-language"
  "first-additional-language"
  "mathematics"
  "life-skills"
)

for grade in "grade-r" "grade-1" "grade-2" "grade-3"; do
  for subject in "${FOUNDATION_SUBJECTS[@]}"; do
    make_dir "grades/foundation-phase/$grade/$subject"
  done
done

# ------------------------------------------------------------------------------
# INTERMEDIATE PHASE — Grade 4, 5, 6
# ------------------------------------------------------------------------------
echo "📗 Creating Intermediate Phase folders (Grade 4–6)..."

INTERMEDIATE_SUBJECTS=(
  "english-fal"
  "home-language"
  "mathematics"
  "natural-sciences-and-technology"
  "social-sciences"
  "economic-management-sciences"
  "life-skills"
  "creative-arts"
)

for grade in "grade-4" "grade-5" "grade-6"; do
  for subject in "${INTERMEDIATE_SUBJECTS[@]}"; do
    make_dir "grades/intermediate-phase/$grade/$subject"
  done
done

# ------------------------------------------------------------------------------
# SENIOR PHASE — Grade 7, 8, 9
# ------------------------------------------------------------------------------
echo "📙 Creating Senior Phase folders (Grade 7–9)..."

SENIOR_SUBJECTS=(
  "english-fal"
  "home-language"
  "mathematics"
  "natural-sciences"
  "social-sciences"
  "technology"
  "economic-management-sciences"
  "life-orientation"
  "creative-arts"
)

for grade in "grade-7" "grade-8" "grade-9"; do
  for subject in "${SENIOR_SUBJECTS[@]}"; do
    make_dir "grades/senior-phase/$grade/$subject"
  done
done

# ------------------------------------------------------------------------------
# FET PHASE — Grade 10, 11, 12
# ------------------------------------------------------------------------------
echo "📕 Creating FET Phase folders (Grade 10–12)..."

FET_SUBJECTS=(
  "english-fal"
  "home-language"
  "mathematics"
  "mathematical-literacy"
  "physical-sciences"
  "life-sciences"
  "geography"
  "history"
  "accounting"
  "business-studies"
  "economics"
  "life-orientation"
  "information-technology"
  "computer-applications-technology"
  "engineering-graphics-and-design"
  "agricultural-sciences"
  "dramatic-arts"
  "music"
  "visual-arts"
  "consumer-studies"
  "hospitality-studies"
  "tourism"
)

for grade in "grade-10" "grade-11" "grade-12"; do
  for subject in "${FET_SUBJECTS[@]}"; do
    make_dir "grades/fet-phase/$grade/$subject"
  done
done

# ------------------------------------------------------------------------------
# RESOURCES BY TYPE
# ------------------------------------------------------------------------------
echo "🗂️  Creating resource-type folders..."

RESOURCE_TYPES=(
  "lesson-plans"
  "assessments/tests"
  "assessments/assignments"
  "assessments/exam-papers"
  "assessments/rubrics"
  "assessments/memoranda"
  "worksheets"
  "homework"
  "report-templates"
  "learning-plans"
)

for type in "${RESOURCE_TYPES[@]}"; do
  make_dir "resources-by-type/$type"
done

# ------------------------------------------------------------------------------
# TEACHER RESOURCES
# ------------------------------------------------------------------------------
echo "👩‍🏫 Creating teacher resource folders..."

make_dir "teacher-resources/lesson-plan-templates"
make_dir "teacher-resources/assessment-rubrics"
make_dir "teacher-resources/classroom-management"
make_dir "teacher-resources/parent-communication-templates"
make_dir "teacher-resources/report-comment-banks"
make_dir "teacher-resources/caps-documents"

# ------------------------------------------------------------------------------
# LANGUAGES
# South Africa's 11 official languages
# ------------------------------------------------------------------------------
echo "🌍 Creating language folders..."

LANGUAGES=(
  "english"
  "afrikaans"
  "isizulu"
  "isixhosa"
  "sesotho"
  "setswana"
  "sepedi"
  "xitsonga"
  "siswati"
  "tshivenda"
  "isindebele"
)

for lang in "${LANGUAGES[@]}"; do
  make_dir "languages/$lang"
done

# ------------------------------------------------------------------------------
# GITHUB ACTIONS & CONFIG
# ------------------------------------------------------------------------------
echo "⚙️  Creating GitHub config folders..."

make_dir ".github/workflows"
make_dir ".github/ISSUE_TEMPLATE"
make_dir "scripts"

# ------------------------------------------------------------------------------
# CREATE GITHUB ACTIONS WORKFLOW
# Auto-deploys to GitHub Pages on every push to main
# ------------------------------------------------------------------------------
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

# ------------------------------------------------------------------------------
# CREATE ISSUE TEMPLATES
# ------------------------------------------------------------------------------
cat > .github/ISSUE_TEMPLATE/add-resource.md << 'EOF'
---
name: Add a Resource
about: Submit a new CAPS-aligned resource for review
title: "[RESOURCE] Grade X - Subject - Resource Type - Term X"
labels: new-resource
---

## Resource Details

- **Grade:** 
- **Subject:** 
- **Term:** 
- **Topic (as per CAPS):** 
- **Resource Type:** (Lesson Plan / Worksheet / Assessment / Homework / Other)
- **Language:** 

## CAPS Compliance Checklist

- [ ] Aligned to the correct CAPS subject and grade
- [ ] References the correct term and topic
- [ ] Uses the correct cognitive levels
- [ ] Includes mark allocation and memorandum (if assessment)
- [ ] Language is appropriate for target grade
- [ ] Follows the file naming convention
- [ ] Metadata block included on first page

## Description

Brief description of the resource and how it should be used.
EOF

cat > .github/ISSUE_TEMPLATE/report-issue.md << 'EOF'
---
name: Report an Issue
about: Report an error or CAPS misalignment in an existing resource
title: "[ISSUE] Grade X - Subject - Filename"
labels: bug
---

## Resource
File path or URL to the resource with the issue.

## Issue Description
Describe the problem clearly.

## Suggested Fix
How should it be corrected?
EOF

# ------------------------------------------------------------------------------
# CREATE CONTRIBUTING GUIDE
# ------------------------------------------------------------------------------
cat > .github/CONTRIBUTING.md << 'EOF'
# Contributing to EduBridge SA CAPS Resources

Thank you for helping improve education for South African learners! 🎉

## Who Can Contribute?
- Teachers
- Schools and education NGOs
- Developers
- Parents and community members
- DBE partners

## How to Contribute

### For Teachers (No coding needed)
1. Go to the correct folder on GitHub
2. Click **Add file** → **Upload files**
3. Upload your PDF
4. Name your file using the convention below
5. Click **Propose changes** to open a Pull Request

### For Developers
1. Fork this repo
2. Create a branch: `git checkout -b add/grX-subject-term-topic`
3. Add your file to the correct folder
4. Commit: `git commit -m "Add Grade X Subject Term X resource"`
5. Push and open a Pull Request

## File Naming Convention
```
[grade]-[subject]-[resource-type]-[term]-[description].pdf

Examples:
  gr4-mathematics-lesson-plan-term1-whole-numbers.pdf
  gr10-physical-sciences-assessment-term2-waves.pdf
  grR-life-skills-worksheet-term1-colours.pdf
```

## CAPS Compliance
All resources MUST:
- Be aligned to the correct CAPS subject, grade, term, and topic
- Include the required metadata block on page 1
- Use appropriate cognitive levels
- Include memoranda for all assessments

## Questions?
Open an issue or contact us at hello@edubridge.co.za
EOF

# ------------------------------------------------------------------------------
# CREATE VALIDATION SCRIPT
# Checks that files follow the naming convention
# ------------------------------------------------------------------------------
cat > scripts/validate-naming.sh << 'EOF'
#!/bin/bash
# Validates that all PDFs in the repo follow the naming convention
# Usage: bash scripts/validate-naming.sh

PATTERN="^(gr[R0-9]{1,2})-([\w-]+)-(lesson-plan|worksheet|homework|assessment|rubric|report|learning-plan)-term[1-4]-([\w-]+)\.(pdf|docx)$"

echo "Checking file naming convention..."
ERRORS=0

while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  if [[ ! "$filename" =~ $PATTERN && "$filename" != ".gitkeep" ]]; then
    echo "❌ Invalid filename: $file"
    ERRORS=$((ERRORS + 1))
  fi
done < <(find grades resources-by-type -type f -print0)

if [ "$ERRORS" -eq 0 ]; then
  echo "✅ All filenames are valid!"
else
  echo ""
  echo "$ERRORS file(s) have invalid names. Please rename them."
  echo "See CONTRIBUTING.md for the naming convention."
fi
EOF

chmod +x scripts/validate-naming.sh

# ------------------------------------------------------------------------------
# DONE
# ------------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "  ✅ Setup Complete!"
echo "=============================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Review the folder structure:"
echo "     ls grades/"
echo ""
echo "  2. Stage and commit everything:"
echo "     git add ."
echo "     git commit -m 'Initial repo structure for CAPS resources'"
echo "     git push origin main"
echo ""
echo "  3. Enable GitHub Pages:"
echo "     GitHub → Settings → Pages → Deploy from main branch"
echo ""
echo "  4. Your resources will be live at:"
echo "     https://YOUR-ORG.github.io/caps-resources/"
echo ""
echo "  Happy building! 🌍📚"
echo ""
