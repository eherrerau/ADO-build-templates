# ADO Build Templates

This repository contains a collection of Azure DevOps (ADO) build templates designed to streamline and standardize CI/CD pipelines. These templates follow Azure best practices to ensure efficient, secure, and scalable workflows.

## Features

- **Reusable Templates**: Modular and reusable YAML templates for various build and release scenarios.
- **Azure Best Practices**: Configurations aligned with Azure's recommended guidelines.
- **Customizable**: Easily adaptable to meet specific project requirements.
- **Version Control**: Organized and versioned for easy maintenance and updates.

## Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/your-repo/ADO-build-templates.git
    ```
2. Review the available templates in the `templates` directory.
3. Integrate the desired templates into your Azure DevOps pipeline YAML files.

## Repository Structure

```
ADO-build-templates/
├── templates/         # YAML templates for build and release pipelines
├── examples/          # Example pipeline configurations
├── docs/              # Documentation for templates and usage
└── README.md          # Repository overview
```

## Usage

1. Reference a template in your pipeline YAML file:
    ```yaml
    resources:
      repositories:
         - repository: templatesRepo
            type: git
            name: your-repo/ADO-build-templates

    jobs:
      - template: templates/build-template.yml@templatesRepo
    ```
2. Customize parameters as needed.

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## License

This repository is licensed under the [MIT License](LICENSE).

## Support

For questions or issues, please open an [issue](https://github.com/your-repo/ADO-build-templates/issues) in the repository.

---
By leveraging these templates, you can accelerate your development workflows and maintain consistency across your projects.

Thanks for your support.