function onCreatePost()
    callOnLuas("_gcall", {"createpost"})
end

function onDestroy()
    callOnLuas("_gcall", {"destroy"})
end
