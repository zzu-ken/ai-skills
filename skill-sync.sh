#!/usr/bin/env bash

set -eo pipefail

# Check if output is a terminal
if [ -t 1 ]; then
  # Terminal - enable colors
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  # Non-terminal (piped/redirected) - disable colors
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

# Default config
SOURCE_DIR="$HOME/.agents/skills"
DRY_RUN=false
VERBOSE=false
AUTO_DISCOVER=true
TARGET_DIR=""

# Statistics
CREATE_COUNT=0
SKIP_COUNT=0
DELETE_COUNT=0
ERROR_COUNT=0

usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Sync skills from source directory to multiple AI tools via symlinks.

OPTIONS:
  -s, --source DIR     Source skills directory (default: ~/.agents/skills)
  -t, --target DIR     Single target tool skills directory (optional)
  -d, --dry-run        Preview mode, don't actually execute
  -v, --verbose        Show detailed logs
  -h, --help           Show this help message

EXAMPLES:
  $(basename "$0")                           # Auto-sync all known tools
  $(basename "$0") -d                        # Preview all sync actions
  $(basename "$0") -s ~/my-skills             # Custom source directory
  $(basename "$0") -t ~/.claude/skills        # Sync to specific tool only

EOF
  exit 0
}

log() {
  printf '%b\n' "$1"
}

log_verbose() {
  if [ "$VERBOSE" = true ]; then
    printf '  📝 %b\n' "$1"
  fi
}

log_error() {
  printf '  %b❌ %b%b\n' "$RED" "$1" "$NC" >&2
  ((ERROR_COUNT++))
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -s|--source)
        SOURCE_DIR="$2"
        AUTO_DISCOVER=false
        shift 2
        ;;
      -t|--target)
        TARGET_DIR="$2"
        shift 2
        ;;
      -d|--dry-run)
        DRY_RUN=true
        shift
        ;;
      -v|--verbose)
        VERBOSE=true
        shift
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  # Ensure TARGET_DIR is empty string if not set
  TARGET_DIR="${TARGET_DIR:-}"
}

validate_source() {
  if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source directory does not exist: $SOURCE_DIR"
    exit 1
  fi
  log "🔍 源目录: $SOURCE_DIR"
}

discover_target_tools() {
  local targets=()

  if [ -n "$TARGET_DIR" ]; then
    if [ ! -d "$TARGET_DIR" ]; then
      log_error "Target directory does not exist: $TARGET_DIR"
      exit 1
    fi
    targets+=("$TARGET_DIR")
    echo "📦 目标: $TARGET_DIR" >&2
  else
    local tool_paths=(
      "$HOME/.claude/skills"
      "$HOME/.config/opencode/skills"
      "$HOME/.cursor/skills"
      "$HOME/.openclaw/skills"
      "$HOME/.codex/skills"
    )

    for skills_path in "${tool_paths[@]}"; do
      local base_dir
      base_dir=$(dirname "$skills_path")
      local tool_name
      tool_name=$(basename "$base_dir")

      if [ -d "$base_dir" ]; then
        if [ -d "$skills_path" ]; then
          targets+=("$skills_path")
          echo "📦 发现目标: $tool_name → $skills_path" >&2
        else
          echo "📦 自动创建: $tool_name → $skills_path" >&2
          if [ "$DRY_RUN" = false ]; then
            mkdir -p "$skills_path"
          else
            echo "  (dry-run: would create directory)" >&2
          fi
          targets+=("$skills_path")
        fi
      fi
    done
  fi

  if [ ${#targets[@]} -eq 0 ]; then
    log_error "No valid target directories found"
    exit 1
  fi

  printf '%s\n' "${targets[@]}"
}

get_skills_from_source() {
  local skills=()
  while IFS= read -r -d '' skill; do
    local name=$(basename "$skill")
    # Skip .DS_Store and hidden files
    [[ "$name" == .* ]] && continue
    skills+=("$skill")
  done < <(find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -print0 | sort -z)

  printf '%s\n' "${skills[@]}"
}

calculate_relative_path() {
  local from="$1"
  local to="$2"

  # Get absolute paths
  local from_abs=$(realpath "$from" 2>/dev/null || echo "$from")
  local to_abs=$(realpath "$to" 2>/dev/null || echo "$to")

  local skill_name=$(basename "$to_abs")

  # Count depth of 'from' relative to home
  local rel_from_home=$(echo "$from_abs" | sed "s|$HOME||" | sed 's|^/||')
  local depth=$(echo "$rel_from_home" | tr '/' '\n' | grep -c '..*' || echo 0)

  # For most tools (2-3 levels deep), use absolute paths to avoid ambiguity
  # with similarly-named directories like .config/agents vs .agents
  echo "abs:$to_abs"
}

check_and_cleanup_broken_symlinks() {
  local target_dir="$1"
  local broken_count=0

  while IFS= read -r -d '' link; do
    local link_name=$(basename "$link")
    local target=$(readlink "$link" 2>/dev/null || true)

    if [ -z "$target" ]; then
      log "  ${YELLOW}🗑️  删除无效软链: $link_name → (目标不存在)${NC}"
      if [ "$DRY_RUN" = false ]; then
        rm -f "$link"
      fi
      ((DELETE_COUNT++))
      ((broken_count++))
    elif [ "${target:0:4}" = "abs:" ]; then
      # Absolute path symlink, check if target exists
      local real_target="${target:4}"
      if [ ! -e "$real_target" ]; then
        log "  ${YELLOW}🗑️  删除无效软链: $link_name → $real_target${NC}"
        if [ "$DRY_RUN" = false ]; then
          rm -f "$link"
        fi
        ((DELETE_COUNT++))
        ((broken_count++))
      fi
    elif [ ! -e "$link" ]; then
      # Symlink exists but target is relative and broken
      log "  ${YELLOW}🗑️  删除无效软链: $link_name → $target${NC}"
      if [ "$DRY_RUN" = false ]; then
        rm -f "$link"
      fi
      ((DELETE_COUNT++))
      ((broken_count++))
    fi
  done < <(find "$target_dir" -maxdepth 1 -mindepth 1 -type l -print0 2>/dev/null | sort -z)

  echo $broken_count
}

sync_skills_to_target() {
  local target_dir="$1"
  shift
  local skills=("$@")
  local target_name=$(basename "$target_dir")
  local target_parent=$(basename "$(dirname "$target_dir")")

  # Show full context for identification
  if [ "$target_name" = "skills" ]; then
    target_name="$target_parent/$target_name"
  fi

  log ""
  log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "📂 目标: $target_name"
  log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # First, clean up broken symlinks
  local broken_count
  broken_count=$(check_and_cleanup_broken_symlinks "$target_dir")

  if [ -n "$broken_count" ] && [ "$broken_count" -gt 0 ] 2>/dev/null; then
    log "  已清理 $broken_count 个无效软链"
  fi

  # Sync each skill
  for skill_path in "${skills[@]}"; do
    local skill_name=$(basename "$skill_path")
    local target_link="$target_dir/$skill_name"

    if [ -e "$target_link" ] || [ -L "$target_link" ]; then
      # Something exists at target
      if [ -L "$target_link" ]; then
        # It's a symlink, check if it's valid
        local link_target=$(readlink "$target_link" 2>/dev/null || true)
        if [ -z "$link_target" ]; then
          # Broken symlink, would have been cleaned above
          continue
        fi

        # Check if it points to our source skill
        local skill_real_path=$(realpath "$skill_path" 2>/dev/null || echo "$skill_path")
        local link_real_path=""

        if [[ "$link_target" == abs:* ]]; then
          # Absolute path marker
          link_real_path="${link_target:4}"
        elif [[ "$link_target" == /* ]]; then
          # Absolute path - resolve directly
          link_real_path=$(realpath "$link_target" 2>/dev/null || echo "$link_target")
        else
          # Relative path - resolve relative to target_link's directory
          local link_dir=$(dirname "$target_link")
          local combined="$link_dir/$link_target"
          # Use Python for reliable path resolution
          link_real_path=$(python3 -c "import os; print(os.path.realpath('$combined'))" 2>/dev/null || echo "$combined")
        fi

        if [ "$skill_real_path" = "$link_real_path" ]; then
          log "  ${GREEN}✓ $skill_name${NC} (已同步)"
          log_verbose "     → $link_target"
          continue
        else
          log "  ${YELLOW}⚠️  $skill_name (链接到其他源: $link_target)${NC}"
          log_verbose "     → 跳过"
          ((SKIP_COUNT++))
          continue
        fi
      else
        # It's a real file/directory
        log "  ${YELLOW}⚠️  $skill_name (已存在非软链)${NC}"
        log_verbose "     → 跳过"
        ((SKIP_COUNT++))
        continue
      fi
    fi

    # Create new symlink - always use absolute path to avoid ambiguity
    local symlink_path=$(realpath "$skill_path" 2>/dev/null || echo "$skill_path")

    log "  ${BLUE}🔗 $skill_name${NC} → $symlink_path"
    log_verbose "     创建软链"

    if [ "$DRY_RUN" = false ]; then
      ln -s "$symlink_path" "$target_link" 2>/dev/null || {
        log_error "创建失败: $skill_name"
        continue
      }
    fi
    ((CREATE_COUNT++))
  done
}

print_summary() {
  local total_skills=$((CREATE_COUNT + SKIP_COUNT + ERROR_COUNT))

  echo ""
  echo "═══════════════════════════════════════════════════"
  echo "📊 统计"
  echo "═══════════════════════════════════════════════════"
  echo "  🔗 创建: $CREATE_COUNT"
  echo "  ⚠️  跳过: $SKIP_COUNT"
  echo "  🗑️  删除: $DELETE_COUNT"
  echo "  ❌ 错误: $ERROR_COUNT"
  echo "  ───────────────────────────────────────────"
  echo "  总计: $total_skills 技能"
  echo "═══════════════════════════════════════════════════"

  if [ "$DRY_RUN" = true ]; then
    log ""
    log "${YELLOW}💡 Dry run 模式 - 无实际操作${NC}"
  fi
}

main() {
  echo "═══════════════════════════════════════════════════"
  echo "🤖 Skill Sync Tool"
  echo "═══════════════════════════════════════════════════"
  echo ""

  parse_args "$@"

  if [ "$DRY_RUN" = true ]; then
    log "${YELLOW}🔍 Dry run 模式${NC}"
  fi

  # Validate source
  validate_source

  # Get skills from source
  local skills_output
  skills_output=$(get_skills_from_source)
  local skills_array=()
  while IFS= read -r line; do
    [ -n "$line" ] && skills_array+=("$line")
  done <<< "$skills_output"
  local skill_count=${#skills_array[@]}
  log "🔍 发现 $skill_count 个技能"

  # Discover target tools (log messages go to stderr, paths to stdout)
  local targets_output
  targets_output=$(discover_target_tools 2>&1)
  # Filter out log messages (lines containing "发现目标")
  local target_array=()
  while IFS= read -r line; do
    # Skip log messages and empty lines
    if [[ "$line" != *"发现目标"* ]] && [[ -n "$line" ]] && [[ -d "$line" ]]; then
      target_array+=("$line")
    fi
  done <<< "$targets_output"

  if [ ${#target_array[@]} -eq 0 ]; then
    log_error "No valid target directories found"
    exit 1
  fi

  # Sync to each target
  for target_dir in "${target_array[@]}"; do
    sync_skills_to_target "$target_dir" "${skills_array[@]}"
  done

  # Print summary
  print_summary
}

main "$@"
