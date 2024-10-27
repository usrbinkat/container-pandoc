# Pandoc Docker Container

A Docker container for converting Markdown files to high-quality PDFs using Pandoc and XeLaTeX.

## Features

- **Easy Conversion**: Transform Markdown files into professional PDFs effortlessly.
- **High-Quality Output**: Leverages XeLaTeX and custom fonts for superior typography and Unicode support.
- **Fully Featured**: Pre-installed with Pandoc, extensive LaTeX packages, and fonts for comprehensive PDF generation.
- **Customizable**: Modify the Dockerfile to suit your specific needs or extend functionality.
- **Pipeline Ready**: Ideal for integration into CI/CD pipelines or automated documentation workflows.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Simple Conversion](#simple-conversion)
  - [Advanced Conversion](#advanced-conversion)
- [Examples](#examples)
- [Building the Docker Image](#building-the-docker-image)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Getting Started

### Prerequisites

- **Docker**: Ensure Docker is installed on your system. [Get Docker](https://www.docker.com/get-started)

### Installation

Pull the Docker image from Docker Hub:

```bash
docker pull containercraft/pandoc
```

Or build the image locally using the provided Dockerfile:

```bash
docker build --progress plain --tag containercraft/pandoc -f Dockerfile .
```

## Usage

### Simple Conversion

To convert a Markdown file (`my_document.md`) to PDF:

```bash
docker run --rm -v $(pwd):/convert containercraft/pandoc my_document.md
```

- `--rm`: Automatically removes the container after execution.
- `-v $(pwd):/convert`: Mounts the current directory into the container.
- `my_document.md`: The Markdown file to convert.

The generated PDF (`my_document.pdf`) will be saved in your current directory.

### Advanced Conversion

The container uses an entrypoint script (`pandoc-entrypoint`) with the following Pandoc command:

```bash
pandoc my_document.md -o my_document.pdf \
    -V mainfont="Noto Serif" \
    -V monofont="Noto Mono" \
    -V geometry:margin=1in \
    --highlight-style=kate \
    --pdf-engine=xelatex \
    --toc -N
```

#### Explanation of Options:

- `-V mainfont="Noto Serif"`: Sets the main text font.
- `-V monofont="Noto Mono"`: Sets the monospaced font.
- `-V geometry:margin=1in`: Sets document margins.
- `--highlight-style=kate`: Applies syntax highlighting style.
- `--pdf-engine=xelatex`: Uses XeLaTeX for better font and Unicode support.
- `--toc`: Includes a table of contents.
- `-N`: Numbers the sections.

#### Custom Usage

To customize the conversion process, you can:

- **Modify the Entrypoint Script**: Adjust `pandoc-entrypoint` with your preferred options.
- **Run Pandoc Directly**: Access the container's shell and run Pandoc commands manually.

```bash
docker run --rm -it -v $(pwd):/convert containercraft/pandoc /bin/bash
```

Once inside the container:

```bash
pandoc my_document.md -o my_document.pdf [your options]
```

## Examples

### Batch Conversion

Convert all Markdown files in a directory:

```bash
for file in *.md; do
  docker run --rm -v $(pwd):/convert containercraft/pandoc "$file"
done
```

### Integration with CI/CD Pipelines

Use the container in automated workflows:

**GitHub Actions Example:**

```yaml
jobs:
  build_pdf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Convert Markdown to PDF
        run: |
          docker run --rm -v ${{ github.workspace }}:/convert containercraft/pandoc my_document.md
```

**GitLab CI/CD Example:**

```yaml
pdf_generation:
  image: containercraft/pandoc
  script:
    - pandoc my_document.md -o my_document.pdf
  artifacts:
    paths:
      - my_document.pdf
```

## Building the Docker Image

Clone the repository and build the image:

```bash
git clone https://github.com/yourusername/pandoc-docker.git
cd pandoc-docker
docker build --progress plain --tag containercraft/pandoc -f Dockerfile .
```

## Customization

### Modify the Dockerfile

- **Add Packages**: Include additional LaTeX packages or fonts by modifying the `APT_PKGS` variable.
- **Change Entrypoint**: Update `pandoc-entrypoint` to alter default Pandoc options.

### Extend Functionality

- **Install Additional Tools**: Install tools like `tesseract-ocr` for OCR capabilities.
- **Integrate Filters**: Add Pandoc filters or Lua scripts for advanced processing.

## Contributing

Contributions are welcome! Please:

1. **Fork the Repository**: Click the "Fork" button on GitHub.
2. **Create a Feature Branch**: `git checkout -b feature/your-feature`
3. **Commit Your Changes**: `git commit -m 'Add your feature'`
4. **Push to the Branch**: `git push origin feature/your-feature`
5. **Open a Pull Request**: Describe your changes and submit.

## Acknowledgments

- **[Pandoc](https://pandoc.org/)**: Universal document converter.
- **[LaTeX Project](https://www.latex-project.org/)**: High-quality typesetting system.
- **[Docker](https://www.docker.com/)**: Containerization platform.
