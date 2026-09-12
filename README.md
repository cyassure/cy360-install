# cy360-install

The public installer mirror for [Cy360](https://cyassure.eu) — a unified, self-hostable Security Operations platform.

This repo exists so anyone can fetch and **read** the install script before running it, without needing access to the private `cy360` product repository. It contains:

- **`install.sh`** — a byte-for-byte mirror of `cyassure-setup.sh`, published here automatically on every Cy360 release.
- **`manifest.json`** — the list of installable versions, kept in sync with Cy360's GitHub Releases.

No product source code, build context, or proprietary material lives in this repo — only the orchestration script that pulls public Docker images and brings up the stack (Community edition) or authenticates against a license for Enterprise images.

## Install Cy360 (Community edition)

```bash
curl -fsSL https://raw.githubusercontent.com/cyassure/cy360-install/main/install.sh | bash -s -- --version latest
```

Pin a specific version instead of `latest` using any tag from `manifest.json`.

**Read the script first.** It's plain, auditable bash — the same file every `curl | bash` one-liner from Docker, Homebrew, or k3s asks you to trust, except you don't have to take our word for it.

Full documentation: [cyassure.eu/docs](https://cyassure.eu/docs) · Support: [cyassure.eu/support](https://cyassure.eu/support)
