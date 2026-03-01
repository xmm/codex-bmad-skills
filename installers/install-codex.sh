#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Install BMAD skills for OpenAI Codex.

Usage:
  ./installers/install-codex.sh [--dest <path>] [--force] [--dry-run]

Optional:
  --dest          destination skills directory (default: $HOME/.agents/skills)
  --force         overwrite existing installed skill directories
  --dry-run       print operations without copying files
  -h, --help      show this help

Runtime requirements:
  - yq v4+
  - python3 (or python)
USAGE
}

log() {
  printf '[%s] %s\n' "$1" "$2"
}

die() {
  log ERROR "$1"
  exit 1
}

resolve_version_from_git() {
  local git_version=""

  if ! command -v git >/dev/null 2>&1; then
    return 1
  fi

  if ! git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 1
  fi

  git_version="$(git -C "$REPO_ROOT" describe --tags --abbrev=0 --match 'v[0-9]*' 2>/dev/null | head -n1 || true)"
  if [[ -z "$git_version" ]]; then
    git_version="$(git -C "$REPO_ROOT" describe --tags --abbrev=0 --match '[0-9]*' 2>/dev/null | head -n1 || true)"
  fi
  if [[ -z "$git_version" ]]; then
    git_version="$(git -C "$REPO_ROOT" tag --list 'v[0-9]*' --sort=-v:refname | head -n1 || true)"
  fi
  if [[ -z "$git_version" ]]; then
    git_version="$(git -C "$REPO_ROOT" tag --list '[0-9]*' --sort=-v:refname | head -n1 || true)"
  fi

  [[ -n "$git_version" ]] || return 1
  printf '%s\n' "${git_version#v}"
}

resolve_version_from_changelog() {
  local changelog="$REPO_ROOT/CHANGELOG.md"
  local changelog_version=""

  [[ -f "$changelog" ]] || return 1

  changelog_version="$(sed -nE 's/^## \[([0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.-]+)?)\].*$/\1/p' "$changelog" | head -n1 || true)"
  if [[ -z "$changelog_version" ]]; then
    changelog_version="$(sed -nE 's/^## ([0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.-]+)?).*/\1/p' "$changelog" | head -n1 || true)"
  fi

  [[ -n "$changelog_version" ]] || return 1
  printf '%s\n' "$changelog_version"
}

resolve_codex_bmad_version() {
  if CODEX_BMAD_VERSION="$(resolve_version_from_git)"; then
    CODEX_BMAD_VERSION_SOURCE="git"
  elif CODEX_BMAD_VERSION="$(resolve_version_from_changelog)"; then
    CODEX_BMAD_VERSION_SOURCE="changelog"
  else
    CODEX_BMAD_VERSION="0.0.0-unknown"
    CODEX_BMAD_VERSION_SOURCE="unknown"
  fi
}

write_codex_version_file() {
  local version_file="$REPO_ROOT/skills/bmad-orchestrator/version.yaml"
  local timestamp

  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log INFO "Would write version file: $version_file (version=$CODEX_BMAD_VERSION source=$CODEX_BMAD_VERSION_SOURCE)"
    return
  fi

  cat > "$version_file" <<EOF
version: "$CODEX_BMAD_VERSION"
source: "$CODEX_BMAD_VERSION_SOURCE"
updated_at_utc: "$timestamp"
EOF

  log OK "Wrote version metadata: $version_file"
}

cleanup_codex_version_file() {
  local exit_code=$?
  local version_file="$REPO_ROOT/skills/bmad-orchestrator/version.yaml"

  if [[ "$DRY_RUN" -eq 0 && -f "$version_file" ]]; then
    if rm -f "$version_file"; then
      log OK "Removed temporary version metadata: $version_file"
    else
      log WARN "Failed to remove temporary version metadata: $version_file"
    fi
  fi

  return "$exit_code"
}

copy_project_readme() {
  local source_readme="$REPO_ROOT/README.md"
  local target_readme="$DEST/bmad-README.md"

  [[ -f "$source_readme" ]] || die "Project README not found: $source_readme"

  if [[ -e "$target_readme" && "$FORCE" -ne 1 ]]; then
    log WARN "Project README exists, skipping: $target_readme"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -e "$target_readme" ]]; then
      log INFO "Would overwrite project README -> $target_readme"
    else
      log INFO "Would copy project README -> $target_readme"
    fi
    return
  fi

  cp "$source_readme" "$target_readme"
  log OK "Copied project README: $target_readme"
}

expand_dest_path() {
  local path="$1"

  case "$path" in
    "~")
      printf '%s\n' "$HOME"
      return
      ;;
    "~/"*)
      printf '%s\n' "$HOME/${path#\~/}"
      return
      ;;
  esac

  printf '%s\n' "$path"
}

check_runtime_requirements() {
  local yq_version
  local python_version

  if ! command -v yq >/dev/null 2>&1; then
    die "yq not found in PATH. Install yq v4+ before running installer."
  fi

  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
  elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
  else
    die "python not found in PATH. Install python3 before running installer."
  fi

  yq_version="$(yq --version 2>/dev/null | head -1 || true)"
  python_version="$("$PYTHON_BIN" --version 2>&1 | head -1 || true)"

  log OK "Runtime check: ${yq_version:-yq detected}, ${python_version:-$PYTHON_BIN detected}"
}

DEST="${HOME}/.agents/skills"
FORCE=0
DRY_RUN=0
CODEX_BMAD_VERSION=""
CODEX_BMAD_VERSION_SOURCE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      [[ $# -ge 2 ]] || die "Missing value for --dest"
      DEST="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown argument: $1"
      ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trap cleanup_codex_version_file EXIT
check_runtime_requirements
DEST="$(expand_dest_path "$DEST")"

if [[ -d "$REPO_ROOT/skills" ]]; then
  SOURCE_ROOT="$REPO_ROOT/skills"
else
  die "No skill source directory found (expected skills/)"
fi

resolve_codex_bmad_version
log OK "Installable codex-bmad-skills version: $CODEX_BMAD_VERSION (source=$CODEX_BMAD_VERSION_SOURCE)"
write_codex_version_file

SKILL_DIRS=()
for d in "$SOURCE_ROOT"/*; do
  if [[ -d "$d" && -f "$d/SKILL.md" ]]; then
    SKILL_DIRS+=("$d")
  fi
done

if [[ ${#SKILL_DIRS[@]} -gt 1 ]]; then
  IFS=$'\n' SKILL_DIRS=($(printf '%s\n' "${SKILL_DIRS[@]}" | sort))
  unset IFS
fi

[[ ${#SKILL_DIRS[@]} -gt 0 ]] || die "No installable skills were found in $SOURCE_ROOT"

if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$DEST"
fi

copy_project_readme

INSTALLED=0
SKIPPED=0

for skill_dir in "${SKILL_DIRS[@]}"; do
  skill_name="$(basename "$skill_dir")"
  target_dir="$DEST/$skill_name"

  if [[ -e "$target_dir" && "$FORCE" -ne 1 ]]; then
    log WARN "Skill exists, skipping: $target_dir"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log INFO "Would install $skill_name -> $target_dir"
    INSTALLED=$((INSTALLED + 1))
    continue
  fi

  if [[ -e "$target_dir" ]]; then
    rm -rf "$target_dir"
  fi

  cp -R "$skill_dir" "$target_dir"
  log OK "Installed $skill_name"
  INSTALLED=$((INSTALLED + 1))
done

log OK "Done. source=$SOURCE_ROOT dest=$DEST installed=$INSTALLED skipped=$SKIPPED"
