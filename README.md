# anakana.fi

This repository contains the source for the static site deployed to GitHub Pages at https://www.anakana.fi/.

## Live
- https://www.anakana.fi/ (custom domain)

## Local preview
- Simple preview with Python 3: `python -m http.server` then visit `http://localhost:8000`.
- Or use an editor extension like Live Server in VS Code.

## Contributing
- Edit files, commit to `main` and push. GitHub Pages will publish the latest commit on `main` (root).

## CI
This repo includes a minimal GitHub Actions workflow that periodically checks the site and fails the job if the site is not reachable. See `.github/workflows/check-pages.yml`.

### HTML validation
- We use the Nu HTML Checker (vnu) to validate HTML for compliance with the HTML spec.
- CI: the workflow will run the validator against `index.html` and fail if any errors or warnings are present (warnings are treated as failures).
- Local: install the checker and run it:

	PowerShell:

	```powershell
	# download the vnu jar (requires Java)
	.\tools\install-vnu.ps1

	# validate one or more files
	.\tools\validate-html.ps1 index.html
	```

	Docker (no Java required locally):

	```powershell
	# Run validator via Docker (requires Docker desktop / CLI)
	.\tools\validate-html-docker.ps1 index.html
	```

	If you don't have Java, install OpenJDK (default-jre) or use the validator's Docker image.

## License
This project has no license specified. Add a `LICENSE` file if you want to set one.
