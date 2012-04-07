SystemDefaultBrowser =
    name: "System Default"
    executables:
        "linux[0-9]*":
            "xdg-open"
        "darwin":
            "open"
    args: [
        "%url%"
    ]

module.exports = SystemDefaultBrowser
