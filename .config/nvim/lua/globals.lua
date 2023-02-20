-- Develop functions
P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return require("pleanary.reload").reload_module(...)
end


R = function(name)
    RELOAD(name)
    return require(name)
end

