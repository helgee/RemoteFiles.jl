import Base.Dates: year, toprev, firstdayofmonth

export needsupdate

const upfun = Dict(
    :never => (created, now) -> false,
    :always => (created, now) -> true,
    :daily => (created, now) -> Date(now) > Date(created),
    :monthly => (created, now) ->
        firstdayofmonth(now) > firstdayofmonth(created),
    :yearly => (created, now) -> year(now) > year(created),
    :mondays => (created, now) ->
        toprev(now, 1, same=true) > toprev(created, 1, same=true),
    :weekly => (created, now) ->
        toprev(now, 1, same=true) > toprev(created, 1, same=true),
    :tuesdays => (created, now) ->
        toprev(now, 2, same=true) > toprev(created, 2, same=true),
    :wednesdays => (created, now) ->
        toprev(now, 3, same=true) > toprev(created, 3, same=true),
    :thursdays => (created, now) ->
        toprev(now, 4, same=true) > toprev(created, 4, same=true),
    :fridays => (created, now) ->
        toprev(now, 5, same=true) > toprev(created, 5, same=true),
    :saturdays => (created, now) ->
        toprev(now, 6, same=true) > toprev(created, 6, same=true),
    :sundays => (created, now) ->
        toprev(now, 7, same=true) > toprev(created, 7, same=true),
)

function needsupdate(created, now, updates)
    if !haskey(upfun, updates)
        error("Unknown update frequency specification: $updates.")
    end

    upfun[updates](created, now)
end

needsupdate(rf::RemoteFile) = needsupdate(lastupdate(rf), now(), rf.updates)
