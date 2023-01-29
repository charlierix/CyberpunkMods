function LogError(message)
    message = "Bezier Demo [ERROR] : " .. message

    print(message)
    spdlog.error(message)
end