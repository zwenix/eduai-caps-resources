#!/bin/bash

# =============================================================================
# EduAI Companion — PDF Auto-Sorter
# =============================================================================
# Place this script and ALL your PDFs in the /Templates folder of your repo.
# Run it from inside the Templates folder:
#
#   cd Templates
#   bash sort-pdfs.sh
#
# It will automatically move each PDF into the correct folder in the repo
# based on the filename convention:
#   grX-subject-type-term-topic.pdf
#
# Safe to re-run — it will never overwrite existing files without asking.
# =============================================================================

set -e

# ── COLOURS FOR OUTPUT ────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

# ── LOCATE REPO ROOT (one level up from Templates/) ───────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SCRIPT_DIR"

echo ""
echo -e "${BOLD}${BLUE}============================================================${NC}"
echo -e "${BOLD}${BLUE}   EduAI Companion — PDF Auto-Sorter${NC}"
echo -e "${BOLD}${BLUE}============================================================${NC}"
echo -e "  Repo root  : ${CYAN}$REPO_ROOT${NC}"
echo -e "  Source     : ${CYAN}$TEMPLATES_DIR${NC}"
echo ""

# ── COUNTERS ──────────────────────────────────────────────────────────────────
MOVED=0
SKIPPED=0
UNKNOWN=0
ERRORS=0

# ── GRADE → PHASE MAPPING ─────────────────────────────────────────────────────
get_phase() {
    local grade="$1"
    case "$grade" in
        grr|gr0)           echo "foundation-phase" ;;
        gr1|gr2|gr3)       echo "foundation-phase" ;;
        gr4|gr5|gr6)       echo "intermediate-phase" ;;
        gr7|gr8|gr9)       echo "senior-phase" ;;
        gr10|gr11|gr12)    echo "fet-phase" ;;
        *)                 echo "" ;;
    esac
}

# ── GRADE CODE → FOLDER NAME ──────────────────────────────────────────────────
get_grade_folder() {
    local grade="$1"
    case "$grade" in
        grr)   echo "grade-r" ;;
        gr0)   echo "grade-r" ;;
        gr1)   echo "grade-1" ;;
        gr2)   echo "grade-2" ;;
        gr3)   echo "grade-3" ;;
        gr4)   echo "grade-4" ;;
        gr5)   echo "grade-5" ;;
        gr6)   echo "grade-6" ;;
        gr7)   echo "grade-7" ;;
        gr8)   echo "grade-8" ;;
        gr9)   echo "grade-9" ;;
        gr10)  echo "grade-10" ;;
        gr11)  echo "grade-11" ;;
        gr12)  echo "grade-12" ;;
        *)     echo "" ;;
    esac
}

# ── SUBJECT KEYWORD → FOLDER NAME ─────────────────────────────────────────────
get_subject_folder() {
    local subject="$1"
    case "$subject" in
        mathematics|maths|math)
            echo "mathematics" ;;
        life-skills|life-skill|lifeskills)
            echo "life-skills" ;;
        life-orientation|lo|life-or)
            echo "life-orientation" ;;
        english-fal|english|fal)
            echo "english-fal" ;;
        home-language|home-lang|hl)
            echo "home-language" ;;
        natural-sciences|natural-sciences-and-technology|nst|science)
            echo "natural-sciences" ;;
        social-sciences|social-science|history|geography)
            echo "social-sciences" ;;
        technology|tech)
            echo "technology" ;;
        economic-management-sciences|ems)
            echo "economic-management-sciences" ;;
        creative-arts|arts)
            echo "creative-arts" ;;
        physical-sciences|physics|physical-science)
            echo "physical-sciences" ;;
        life-sciences|biology|life-science)
            echo "life-sciences" ;;
        accounting|acc)
            echo "accounting" ;;
        business-studies|business)
            echo "business-studies" ;;
        economics|econ)
            echo "economics" ;;
        mathematical-literacy|maths-lit|math-literacy)
            echo "mathematical-literacy" ;;
        information-technology|it)
            echo "information-technology" ;;
        computer-applications-technology|cat)
            echo "computer-applications-technology" ;;
        geography|geo)
            echo "geography" ;;
        history|hist)
            echo "history" ;;
        phonics|jolly-phonics)
            echo "home-language" ;;
        *)
            echo "" ;;
    esac
}

# ── RESOURCE TYPE → SUBFOLDER (within resources-by-type) ─────────────────────
get_type_folder() {
    local type="$1"
    case "$type" in
        lesson-plan|lesson-plans)      echo "lesson-plans" ;;
        worksheet|worksheets)          echo "worksheets" ;;
        assessment|assessments)        echo "assessments/tests" ;;
        homework)                      echo "homework" ;;
        report|report-template)        echo "report-templates" ;;
        rubric)                        echo "assessments/rubrics" ;;
        notes|reference)               echo "lesson-plans" ;;
        sound-chart|chart)             echo "worksheets" ;;
        reward-chart)                  echo "worksheets" ;;
        *)                             echo "worksheets" ;;
    esac
}

# ── TEACHER RESOURCE DETECTION ────────────────────────────────────────────────
is_teacher_resource() {
    local filename="$1"
    if [[ "$filename" == teacher-* ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# ── LOG FILE ──────────────────────────────────────────────────────────────────
LOG_FILE="$TEMPLATES_DIR/sort-log-$(date +%Y%m%d-%H%M%S).txt"
echo "EduAI Companion PDF Sort Log — $(date)" > "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

log() {
    echo "$1" >> "$LOG_FILE"
}

# ── PROCESS EACH PDF ──────────────────────────────────────────────────────────
echo -e "${BOLD}Processing PDFs...${NC}"
echo ""

shopt -s nocasematch  # case-insensitive matching

for pdf_path in "$TEMPLATES_DIR"/*.pdf; do

    # Skip if no PDFs found
    [ -f "$pdf_path" ] || continue

    filename="$(basename "$pdf_path")"
    filename_lower="${filename,,}"          # lowercase
    stem="${filename_lower%.pdf}"          # strip .pdf
    name_display="$(basename "$pdf_path")" # original case for display

    echo -e "  ${CYAN}→${NC} $name_display"

    # ── TEACHER RESOURCES ─────────────────────────────────────────────────────
    if [[ "$stem" == teacher-* ]]; then
        dest_dir="$REPO_ROOT/teacher-resources"
        # Detect subcategory
        if [[ "$stem" == *phonics* || "$stem" == *lesson* ]]; then
            dest_dir="$REPO_ROOT/teacher-resources/lesson-plan-templates"
        elif [[ "$stem" == *rubric* || "$stem" == *assessment* ]]; then
            dest_dir="$REPO_ROOT/teacher-resources/assessment-rubrics"
        elif [[ "$stem" == *report* || "$stem" == *comment* ]]; then
            dest_dir="$REPO_ROOT/teacher-resources/report-comment-banks"
        elif [[ "$stem" == *parent* || "$stem" == *communication* ]]; then
            dest_dir="$REPO_ROOT/teacher-resources/parent-communication-templates"
        else
            dest_dir="$REPO_ROOT/teacher-resources/lesson-plan-templates"
        fi

        mkdir -p "$dest_dir"
        if [ -f "$dest_dir/$filename" ]; then
            echo -e "    ${YELLOW}⚠ Already exists — skipped${NC}"
            log "SKIPPED (exists): $filename → $dest_dir"
            ((SKIPPED++))
        else
            cp "$pdf_path" "$dest_dir/$filename"
            echo -e "    ${GREEN}✅ teacher-resources/$(basename "$dest_dir")/${NC}"
            log "MOVED: $filename → $dest_dir"
            ((MOVED++))
        fi
        continue
    fi

    # ── FOUNDATION PHASE REWARD / GENERAL CHARTS ──────────────────────────────
    if [[ "$stem" == foundation-phase-* || "$stem" == *reward-chart* ]]; then
        dest_dir="$REPO_ROOT/resources-by-type/worksheets"
        mkdir -p "$dest_dir"
        if [ -f "$dest_dir/$filename" ]; then
            echo -e "    ${YELLOW}⚠ Already exists — skipped${NC}"
            log "SKIPPED (exists): $filename → $dest_dir"
            ((SKIPPED++))
        else
            cp "$pdf_path" "$dest_dir/$filename"
            echo -e "    ${GREEN}✅ resources-by-type/worksheets/${NC}"
            log "MOVED: $filename → $dest_dir"
            ((MOVED++))
        fi
        continue
    fi

    # ── PARSE FILENAME: grX-subject-type-term-topic.pdf ───────────────────────
    IFS='-' read -ra PARTS <<< "$stem"

    if [ ${#PARTS[@]} -lt 3 ]; then
        echo -e "    ${RED}✗ Cannot parse filename — moved to _unsorted/${NC}"
        mkdir -p "$TEMPLATES_DIR/_unsorted"
        cp "$pdf_path" "$TEMPLATES_DIR/_unsorted/$filename"
        log "UNSORTED: $filename (too few parts)"
        ((UNKNOWN++))
        continue
    fi

    # Grade is always the first part
    GRADE_CODE="${PARTS[0]}"

    # Handle dual-grade files like "grR-gr1" → use first grade
    if [[ "${PARTS[1]}" == gr* ]]; then
        SUBJECT_START=2
    else
        SUBJECT_START=1
    fi

    # Subject is parts[SUBJECT_START]
    RAW_SUBJECT="${PARTS[$SUBJECT_START]}"

    # Resource type is the next part after subject
    TYPE_IDX=$((SUBJECT_START + 1))
    RAW_TYPE="${PARTS[$TYPE_IDX]:-worksheet}"

    # Handle compound types like "lesson-plan" or "sound-chart"
    # Check if next part continues the type name
    NEXT_IDX=$((TYPE_IDX + 1))
    COMBINED_TYPE="${RAW_TYPE}-${PARTS[$NEXT_IDX]:-}"
    case "$COMBINED_TYPE" in
        lesson-plan|sound-chart|reward-chart|report-template)
            RAW_TYPE="$COMBINED_TYPE"
            ;;
    esac

    # ── RESOLVE PATHS ─────────────────────────────────────────────────────────
    PHASE=$(get_phase "$GRADE_CODE")
    GRADE_FOLDER=$(get_grade_folder "$GRADE_CODE")
    SUBJECT_FOLDER=$(get_subject_folder "$RAW_SUBJECT")

    # ── HANDLE UNKNOWN GRADE ──────────────────────────────────────────────────
    if [ -z "$PHASE" ] || [ -z "$GRADE_FOLDER" ]; then
        echo -e "    ${RED}✗ Unknown grade code '$GRADE_CODE' — moved to _unsorted/${NC}"
        mkdir -p "$TEMPLATES_DIR/_unsorted"
        cp "$pdf_path" "$TEMPLATES_DIR/_unsorted/$filename"
        log "UNSORTED: $filename (unknown grade: $GRADE_CODE)"
        ((UNKNOWN++))
        continue
    fi

    # ── HANDLE UNKNOWN SUBJECT ────────────────────────────────────────────────
    if [ -z "$SUBJECT_FOLDER" ]; then
        # Fall back to resources-by-type
        TYPE_FOLDER=$(get_type_folder "$RAW_TYPE")
        dest_dir="$REPO_ROOT/resources-by-type/$TYPE_FOLDER"
        echo -e "    ${YELLOW}⚠ Unknown subject '$RAW_SUBJECT' — placing in resources-by-type/$TYPE_FOLDER/${NC}"
        log "FALLBACK: $filename → resources-by-type/$TYPE_FOLDER (unknown subject: $RAW_SUBJECT)"
    else
        dest_dir="$REPO_ROOT/grades/$PHASE/$GRADE_FOLDER/$SUBJECT_FOLDER"
    fi

    # ── COPY TO DESTINATION ───────────────────────────────────────────────────
    mkdir -p "$dest_dir"

    if [ -f "$dest_dir/$filename" ]; then
        echo -e "    ${YELLOW}⚠ Already exists — skipped${NC}"
        log "SKIPPED (exists): $filename → $dest_dir"
        ((SKIPPED++))
    else
        if cp "$pdf_path" "$dest_dir/$filename"; then
            rel_path="${dest_dir#$REPO_ROOT/}"
            echo -e "    ${GREEN}✅ $rel_path/${NC}"
            log "MOVED: $filename → $dest_dir"
            ((MOVED++))
        else
            echo -e "    ${RED}✗ Error copying file${NC}"
            log "ERROR: $filename → $dest_dir"
            ((ERRORS++))
        fi
    fi

done

shopt -u nocasematch

# ── SUMMARY ───────────────────────────────────────────────────────────────────
TOTAL=$((MOVED + SKIPPED + UNKNOWN + ERRORS))

echo ""
echo -e "${BOLD}${BLUE}============================================================${NC}"
echo -e "${BOLD}  Sort Complete!${NC}"
echo -e "${BLUE}============================================================${NC}"
echo -e "  ${GREEN}✅ Sorted successfully : $MOVED${NC}"
echo -e "  ${YELLOW}⚠  Already existed     : $SKIPPED${NC}"
echo -e "  ${RED}✗  Could not sort      : $UNKNOWN${NC}"
if [ $ERRORS -gt 0 ]; then
echo -e "  ${RED}✗  Copy errors         : $ERRORS${NC}"
fi
echo -e "  ${CYAN}   Total PDFs found    : $TOTAL${NC}"
echo ""

if [ $UNKNOWN -gt 0 ]; then
    echo -e "${YELLOW}  Files that could not be sorted are in:${NC}"
    echo -e "  ${CYAN}  Templates/_unsorted/${NC}"
    echo ""
fi

echo -e "  📄 Full log saved to:"
echo -e "  ${CYAN}  $(basename "$LOG_FILE")${NC}"
echo ""

# ── NEXT STEPS ────────────────────────────────────────────────────────────────
if [ $MOVED -gt 0 ]; then
    echo -e "${BOLD}  Next steps:${NC}"
    echo ""
    echo -e "  1. Review the sorted files:"
    echo -e "     ${CYAN}ls ../grades/${NC}"
    echo ""
    echo -e "  2. Commit and push to GitHub:"
    echo -e "     ${CYAN}cd .."
    echo -e "     git add ."
    echo -e "     git commit -m \"Add $(date +%Y-%m-%d) batch of CAPS resources\""
    echo -e "     git push origin main${NC}"
    echo ""
    echo -e "  3. Your resources will be live at:"
    echo -e "     ${CYAN}https://YOUR-ORG.github.io/caps-resources/${NC}"
    echo ""
fi

echo -e "${BOLD}${BLUE}============================================================${NC}"
echo ""
