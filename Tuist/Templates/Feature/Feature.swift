import ProjectDescription

let featureTemplate = Template(
    description: "새 Feature 모듈을 생성합니다 (TCA + 3-Layer)",
    attributes: [
        .required("name")
    ],
    items: [
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Project.swift",
            templatePath: "project.stencil"
        ),
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Sources/\(Template.Attribute.required("name"))Feature.swift",
            templatePath: "feature.stencil"
        ),
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Sources/\(Template.Attribute.required("name"))View.swift",
            templatePath: "view.stencil"
        ),
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Testing/Mock/Mock\(Template.Attribute.required("name"))Client.swift",
            templatePath: "mock.stencil"
        ),
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Tests/\(Template.Attribute.required("name"))FeatureTests.swift",
            templatePath: "tests.stencil"
        ),
        .file(
            path: "Projects/Feature/\(Template.Attribute.required("name"))/Example/Sources/\(Template.Attribute.required("name"))ExampleApp.swift",
            templatePath: "example.stencil"
        )
    ]
)
