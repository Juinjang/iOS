import { danger, warn, message } from "danger"

const pr = danger.github.pr

if (pr.additions > 600) {
 warn("PR is too large. Consider splitting it.")
}

if (pr.changed_files > 10) {
 warn("PR modifies many files.")
}

const hasTests = danger.git.modified_files.some(f => f.includes("Tests"))

if (!hasTests) {
 message("No tests were added.")
}

