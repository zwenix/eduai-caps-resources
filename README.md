# <a href="https://ibb.co/Z6tYMbB1"><img src="https://i.ibb.co/6RV1WqHJ/eduaicompanion-logo2-preview-1772467621580-2-preview-1772473153046-x128.jpg" alt="eduaicompanion logo2 preview 1772467621580 2 preview 1772473153046 x128" border="0"></a>  📚 EduAI.Companion SA — CAPS Resources Repository

>  Developed & Owned by: Zwelakhe Msuthu - All rights reserved Solely by Owner & Developer 2026 Registered Trademark ® 

> Open-source educational resource library for South African learners in Grades R–12.  
> All content is aligned to the **Curriculum and Assessment Policy Statement (CAPS)**.

---

## 🗂️ Repository Structure

```
eduai-caps-resources/
│
├── README.md
├── LICENSE
├── .github/
│   └── CONTRIBUTING.md
│
├── grades/
│   ├── foundation-phase/          # Grade R, 1, 2, 3
│   │   ├── grade-r/
│   │   │   ├── home-language/
│   │   │   ├── mathematics/
│   │   │   └── life-skills/
│   │   ├── grade-1/
│   │   ├── grade-2/
│   │   └── grade-3/
│   │
│   ├── intermediate-phase/        # Grade 4, 5, 6
│   │   ├── grade-4/
│   │   │   ├── english-fal/
│   │   │   ├── mathematics/
│   │   │   ├── natural-sciences/
│   │   │   ├── social-sciences/
│   │   │   ├── technology/
│   │   │   ├── economic-management-sciences/
│   │   │   ├── life-skills/
│   │   │   └── creative-arts/
│   │   ├── grade-5/
│   │   └── grade-6/
│   │
│   ├── senior-phase/              # Grade 7, 8, 9
│   │   ├── grade-7/
│   │   │   ├── english-fal/
│   │   │   ├── mathematics/
│   │   │   ├── natural-sciences/
│   │   │   ├── social-sciences/
│   │   │   ├── technology/
│   │   │   ├── economic-management-sciences/
│   │   │   ├── life-orientation/
│   │   │   └── creative-arts/
│   │   ├── grade-8/
│   │   └── grade-9/
│   │
│   └── fet-phase/                 # Grade 10, 11, 12
│       ├── grade-10/
│       │   ├── english-fal/
│       │   ├── mathematics/
│       │   ├── mathematical-literacy/
│       │   ├── physical-sciences/
│       │   ├── life-sciences/
│       │   ├── geography/
│       │   ├── history/
│       │   ├── accounting/
│       │   ├── business-studies/
│       │   ├── economics/
│       │   ├── life-orientation/
│       │   └── [other subjects]/
│       ├── grade-11/
│       └── grade-12/
│
├── resources-by-type/
│   ├── lesson-plans/
│   ├── assessments/
│   │   ├── tests/
│   │   ├── assignments/
│   │   └── exam-papers/
│   ├── worksheets/
│   ├── homework/
│   └── report-templates/
│
├── teacher-resources/
│   ├── lesson-plan-templates/
│   ├── assessment-rubrics/
│   ├── classroom-management/
│   └── parent-communication/
│
├── languages/
│   ├── english/
│   ├── afrikaans/
│   ├── isizulu/
│   ├── isixhosa/
│   ├── sesotho/
│   ├── setswana/
│   └── [other official languages]/
│
└── scripts/
    └── validate-caps-alignment.sh
```

---

## 📄 File Naming Convention

All files must follow this naming convention for consistency and easy lookup:

```
[grade]-[subject]-[resource-type]-[term]-[description].[ext]

Examples:
  gr4-mathematics-lesson-plan-term1-whole-numbers.pdf
  gr10-physical-sciences-assessment-term2-waves.pdf
  gr7-english-fal-worksheet-term3-comprehension.pdf
  grR-life-skills-homework-term1-colours.pdf
```

### Grade Codes
| Code | Grade |
|------|-------|
| `grR` | Grade R |
| `gr1` – `gr9` | Grade 1 to 9 |
| `gr10` – `gr12` | Grade 10 to 12 |

### Resource Type Codes
| Code | Type |
|------|------|
| `lesson-plan` | Lesson Plan |
| `worksheet` | Classroom Worksheet |
| `homework` | Homework Assignment |
| `assessment` | Test or Exam |
| `rubric` | Assessment Rubric |
| `report` | Report Template |

---

## ✅ CAPS Compliance Requirements

Every resource in this repository **must** meet the following criteria before being merged:

- [ ] Aligned to the correct **CAPS subject and grade** requirements
- [ ] References the correct **term and topic** as per the CAPS document
- [ ] Uses the correct **cognitive levels** (Knowledge, Routine Application, Complex Application, Problem Solving)
- [ ] Assessments include **mark allocation** and **memoranda**
- [ ] Language is appropriate for the target grade
- [ ] File follows the **naming convention** above
- [ ] Metadata block is included at the top of every document (see below)

### Required Metadata Block
Every PDF or document must include this on the first page:

```
Subject:        Mathematics
Grade:          Grade 7
Term:           Term 2
Topic:          Geometry of 2D Shapes
CAPS Reference: Page 112, Senior Phase CAPS Document
Resource Type:  Lesson Plan
Language:       English
Author:         [Your name or "EduAI Companion SA Community"]
Version:        1.0
Last Updated:   YYYY-MM-DD
```

---

## 🚀 How to Add a Resource

### Option 1 — Via GitHub (Recommended for developers)
```bash
# 1. Fork this repository
# 2. Clone your fork
git clone https://github.com/zwenix./eduai-caps-resources.git
cd eduai-caps-resources

# 3. Create a branch
git checkout -b add/gr8-mathematics-term1-integers

# 4. Add your file to the correct folder
cp your-file.pdf grades/senior-phase/grade-8/mathematics/

# 5. Commit and push
git add .
git commit -m "Add Grade 8 Mathematics Term 1 Integers lesson plan"
git push origin add/gr8-mathematics-term1-integers

# 6. Open a Pull Request on GitHub
```

### Option 2 — Via GitHub Web UI (for non-developers / teachers)
1. Navigate to the correct folder in this repo
2. Click **Add file** → **Upload files**
3. Drag and drop your PDF
4. Add a commit message describing what you've added
5. Select **Create a new branch** and open a Pull Request

---

## 🔗 Accessing Resources in the App

Once merged, every PDF is automatically available at:

```
https://zwenix.github.io/eduai-caps-resources/grades/[phase]/[grade]/[subject]/[filename].pdf
```

**Example:**
```
https://zwenix.github.io/eduai-caps-resources/grades/senior-phase/grade-8/mathematics/gr8-mathematics-lesson-plan-term1-integers.pdf
```

This URL can be used directly in the EduAI Companion SA app to:
- **Display** the PDF inline using an embedded viewer
- **Download** the file directly
- **Reference** it in AI-generated personalised learning plans

---

## 🤝 Contributing

We welcome contributions from:
- ✏️ Teachers
- 🏫 Schools
- 👩‍💻 Developers
- 📖 Education NGOs
- 🏛️ DBE partners

Please read [CONTRIBUTING.md](.github/CONTRIBUTING.md) before submitting.

---

## 📜 License

All resources in this repository are released under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license, meaning anyone can use, share, and adapt the materials — as long as they give appropriate credit.

---

## 🌍 About EduAI Companion SA

EduAI Companion SA is an open-source educational platform built to give every South African learner — regardless of location or socioeconomic background — access to high-quality, personalised, CAPS-aligned education.

> *"Every child deserves a great education."*
# eduai-eduai-caps-resources
