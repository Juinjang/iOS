import ProjectDescription

let coreTemplate = Template(
    description: "새 Core 모듈을 생성합니다",
    attributes: [
        .required("name")
    ],
    items: [
        .file(
            path: "Projects/Core/\(Template.Attribute.required("name"))/Project.swift",
            templatePath: "project.stencil"
        ),
        .file(
            path: "Projects/Core/\(Template.Attribute.required("name"))/Sources/\(Template.Attribute.required("name")).swift",
            templatePath: "source.stencil"
        )
    ]
)
