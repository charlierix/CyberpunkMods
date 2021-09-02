-- These functions are so people don't blow up memory by storing novels in their
-- json files.  These functions are pretty minimal, but they avoid code duplication

function Cap_Author(author)
    return String_Cap(author, 72)
end

function Cap_Description(description)
    return String_Cap(description, 1024)
end

function Cap_Entity(entity)
    return String_Cap(entity, 256)
end

function Cap_Tags(tags)
    if not tags then
        do return end
    end

    for i = 1, #tags do
        tags[i] = String_Cap(tags[i], 24)
    end
end