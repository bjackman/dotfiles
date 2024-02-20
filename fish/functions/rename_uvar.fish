
function rename_uvar --argument-name old_name new_name
    set --local old_val $$old_name
    set --universal $new_name $old_val
    set --erase $old_name
end