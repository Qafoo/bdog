chromium =
    name: "chromium"
    executables:
        "linux[0-9]*":
            "chromium-browser"
    args: [
        "%url%"
    ]

module.exports = chromium
