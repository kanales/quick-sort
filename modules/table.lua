local T = {}

function T.range(high)
    local t = {}
    for i = 1,high do
        table.insert(t,i)
    end
    return t
end

function T.shuffleM(table)
    for i = #table, 1, -1 do
        local j = math.random(i)
        T.swap(table, i, j)
    end
end

function T.shuffle(table)
    local t = {unpack(table)}
    for i = #t, 1, -1 do
        local j = math.random(i)
        T.swap(t, i, j)
    end
    return t
end

function T.swap(table, i, j)
    table[i], table[j] = table[j], table[i]
end

function T.reversePerm(perm)
    local inv = {}
    for i,v in ipairs(perm) do
        inv[v] = i
    end
    return inv
end

function T.print(t)
    for k,v in pairs(t) do
        print(k, ": ", v)
    end
end

function T.equals(a, b)
    if #b ~= #a then return false end

    for i,v in ipairs(a) do
        if v ~= b[i] then return false end
    end
    return true
end

function T.map(cb, table)
    local new = {}
    for idx, v in ipairs(table) do
        new[idx] = cb(v)
    end

    return new
end

function T.randpick(table)
    local idx = math.random(#table)
    return table[idx]
end

return T
