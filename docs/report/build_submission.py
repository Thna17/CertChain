"""Package reviewed source and evidence; deliberately excludes local runtime data."""

from __future__ import annotations

import hashlib
import json
import subprocess
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "output/submission/CertChain-submission-PREPARED.zip"
REPORT = "output/pdf/CertChain-assignment-report-DRAFT.pdf"
ADDITIONS = {
    "docs/report/build_submission.py",
    "docs/report/submission-preparation.md",
    "docs/report/submission-validation-2026-10-03.json",
    "docs/report/submission-validation-2026-10-06.md",
    "docs/report/contributions-from-git.md",
    "docs/report/final-submission-gate-2026-09-29.md",
    "docs/screenshots/submission-dashboard-local.png",
    "docs/screenshots/submission-issued-local.png",
    "docs/screenshots/submission-issued-local.pdf",
    "docs/screenshots/production-certificate-sepolia-2026-10-06.png",
    "docs/screenshots/production-certificate-sepolia-2026-10-06.pdf",
}


def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT).decode("utf-8")


def safe_path(name: str) -> None:
    path = PurePosixPath(name)
    forbidden = {".git", "node_modules", ".next", "target", "tmp", "storage",
                 "artifacts", "cache", "coverage", "deployments"}
    if path.is_absolute() or ".." in path.parts or forbidden.intersection(path.parts):
        raise ValueError(f"Unsafe archive path: {name}")
    if path.name.startswith(".env") and path.name != ".env.example":
        raise ValueError(f"Real environment file rejected: {name}")
    if path.suffix.lower() in {".log", ".pem", ".key", ".p12", ".pfx", ".db", ".class", ".zip"}:
        raise ValueError(f"Private/runtime file rejected: {name}")


def build() -> None:
    tracked = set(git("ls-files", "-z").split("\0")) - {""}
    files = tracked | ADDITIONS
    entries: dict[str, bytes] = {}
    for name in sorted(files):
        safe_path(name)
        path = ROOT / name
        if not path.is_file() or path.is_symlink():
            raise ValueError(f"Missing or symbolic source file: {name}")
        archive_name = Path(REPORT).name if name == REPORT else f"CertChain/{name}"
        entries[archive_name] = path.read_bytes()

    entries["START-HERE.md"] = (ROOT / "docs/report/submission-preparation.md").read_bytes()
    manifest = {
        "prepared_date": "2026-10-06",
        "status": "PREPARED_DRAFT_NOT_RELEASE_READY",
        "repository": "https://github.com/Thna17/CertChain",
        "source_commit": git("rev-parse", "HEAD").strip(),
        "branch": git("branch", "--show-current").strip(),
        "working_tree_changes": git("status", "--short").splitlines(),
        "files": [{"path": name, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
                  for name, data in sorted(entries.items())],
    }
    entries["MANIFEST.json"] = (json.dumps(manifest, indent=2) + "\n").encode()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(OUTPUT, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for name, data in sorted(entries.items()):
            info = zipfile.ZipInfo(name, date_time=(2026, 10, 6, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o755 if name.endswith("/mvnw") else 0o644) << 16
            archive.writestr(info, data)
    with zipfile.ZipFile(OUTPUT) as archive:
        assert archive.testzip() is None
        for entry in manifest["files"]:
            assert hashlib.sha256(archive.read(entry["path"])).hexdigest() == entry["sha256"]
    checksum = hashlib.sha256(OUTPUT.read_bytes()).hexdigest()
    OUTPUT.with_suffix(".zip.sha256").write_text(f"{checksum}  {OUTPUT.name}\n", encoding="utf-8")
    print(f"Created {OUTPUT.relative_to(ROOT)} ({len(entries)} files); manifest hashes verified")


if __name__ == "__main__":
    build()
